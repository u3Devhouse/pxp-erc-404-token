// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC404} from "./interfaces/IERC404.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract PXP404 is Ownable, IERC404 {
    using Strings for uint256;
    //----------------------------------------------------
    // Errors
    //----------------------------------------------------
    error PXP404__InvalidId(uint id);
    error PXP404__InvalidOwner();
    error PXP404__InvalidApproval();
    error PXP404__UnsafeRecipient();
    error PXP404__InvalidAddress();
    error PXP404__Redundant();
    error PXP404__TransferFailed();
    //----------------------------------------------------
    // Data Structure
    //----------------------------------------------------
    struct IdInfo {
        address owner;
        uint256 ownerArrayIndex;
        bool isFractioned;
    }
    struct UserInfo {
        uint balance;
        uint256[] ownedIds;
    }
    struct AllowanceInfo {
        uint allowance;
        bool approvedForAll;
    }
    //----------------------------------------------------
    // State Variables
    //----------------------------------------------------
    mapping(uint256 id => address approvedUserToSpendThisId)
        internal _getApproved;
    mapping(uint id => IdInfo) internal _idInfo;
    mapping(address user => UserInfo) internal _userInfo;
    mapping(address user => mapping(address spender => AllowanceInfo))
        internal _allowanceInfo;
    mapping(address user => bool isWhitelisted) private whitelist;

    uint public immutable totalSupply;
    uint private immutable totalIds;
    /// @dev Queued ids that are fractioned
    uint[] private _queuedIds;
    uint private maxCurrentMintedId;
    /// @dev these are the bits that are used to represent IDs
    uint private constant UNIT = 1 ether;
    uint private constant BITS_FOR_ID = 16;
    uint private constant ID_MASK = 0xffff;

    //----------------------------------------------------
    // Events
    //----------------------------------------------------
    event WhitelistStatusChanged(address indexed user, bool isWhitelisted);

    //----------------------------------------------------
    // Constructor
    //----------------------------------------------------
    /**
     * @param _owner The address of the owner of the tokens and contract
     * @dev The owner will hold all tokens but these tokens will not yet be "minted" all IDS are assumed to belong to
     * the owner and as they're transferred will be "minted" to the receiver.
     * Although there are 18 decimals, the decimals are reduced by 16 bits in the least significant digits to make sure
     * that the values are reserved.
     */
    constructor(address _owner) Ownable(_owner) {
        totalIds = 30_000;
        totalSupply = totalIds * 1 ether;
        _userInfo[_owner].balance = totalSupply;
        whitelist[_owner] = true;
        emit Transfer(address(0), _owner, totalSupply);
    }

    //----------------------------------------------------
    // External / Public Functions
    //----------------------------------------------------
    function approve(
        address spenderOrOperator,
        uint valueOrId
    ) public override returns (bool) {
        uint256 balanceToApprove = valueOrId >> BITS_FOR_ID;
        if (balanceToApprove == 0) {
            // approve a single ID
            balanceToApprove = valueOrId & ID_MASK;
            if (
                !_checkIfIdIsValid(balanceToApprove) ||
                _idInfo[balanceToApprove].isFractioned
            ) {
                revert PXP404__InvalidId(balanceToApprove);
            }
            // Check for ID ownership
            if (_idInfo[balanceToApprove].owner != msg.sender) {
                revert PXP404__InvalidOwner();
            }
            _getApproved[balanceToApprove] = spenderOrOperator;
            emit Approval(msg.sender, spenderOrOperator, balanceToApprove);
        } else {
            // approve a balance
            _allowanceInfo[msg.sender][spenderOrOperator].allowance =
                balanceToApprove <<
                BITS_FOR_ID;
            emit Approval(msg.sender, spenderOrOperator, balanceToApprove);
        }
        return true;
    }

    function setApprovalForAll(
        address operator,
        bool _approved
    ) public override {
        _allowanceInfo[msg.sender][operator].approvedForAll = _approved;
        emit ApprovalForAll(msg.sender, operator, _approved);
    }

    /**
     * @notice Sets the whitelist status of an address
     * @param _newWhitelist The address to set the whitelist status for
     * @param _isWhitelisted The new whitelist status, if true the address is whitelisted, if false the address is not whitelisted
     */
    function setWhitelistedStatus(
        address _newWhitelist,
        bool _isWhitelisted
    ) external onlyOwner {
        if (_newWhitelist == address(0)) {
            revert PXP404__InvalidAddress();
        }
        if (_isWhitelisted == whitelist[_newWhitelist]) {
            revert PXP404__Redundant();
        }
        whitelist[_newWhitelist] = _isWhitelisted;

        UserInfo storage newWhitelistUser = _userInfo[_newWhitelist];
        if (_isWhitelisted) {
            uint idsHeld = newWhitelistUser.ownedIds.length;
            for (uint i = 0; i < idsHeld; i++) {
                uint ownedLastIndex = newWhitelistUser.ownedIds.length - 1;
                uint idValue = newWhitelistUser.ownedIds[ownedLastIndex];
                _queuedIds.push(idValue);
                _getApproved[idValue] = address(0);
                newWhitelistUser.ownedIds.pop();
            }
        } else {
            uint heldBalance = newWhitelistUser.balance;
            uint idsToMint = heldBalance / UNIT;
            for (uint i = 0; i < idsToMint; i++) {
                if (_queuedIds.length > 0) {
                    uint lastIndex = _queuedIds.length - 1;
                    newWhitelistUser.ownedIds.push(_queuedIds[lastIndex]);
                    _queuedIds.pop();
                } else {
                    newWhitelistUser.ownedIds.push(maxCurrentMintedId);
                    maxCurrentMintedId++;
                }
            }
        }
        emit WhitelistStatusChanged(_newWhitelist, _isWhitelisted);
    }

    function transfer(
        address _to,
        uint amountOrId
    ) public override returns (bool) {
        return _transfer(msg.sender, _to, amountOrId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id
    ) public override {
        transferFrom(from, to, id);
        if (
            to.code.length != 0 &&
            IERC721Receiver(to).onERC721Received(msg.sender, from, id, "") !=
            IERC721Receiver.onERC721Received.selector
        ) {
            revert PXP404__UnsafeRecipient();
        }
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        bytes memory data
    ) public override {
        transferFrom(from, to, id);
        if (
            to.code.length != 0 &&
            IERC721Receiver(to).onERC721Received(msg.sender, from, id, data) !=
            IERC721Receiver.onERC721Received.selector
        ) {
            revert PXP404__UnsafeRecipient();
        }
    }

    function transferFrom(
        address _from,
        address _to,
        uint amountOrId
    ) public override returns (bool) {
        if (amountOrId >> BITS_FOR_ID == 0) {
            // id
            // check approve for all or approve for id
            if (
                !_allowanceInfo[_from][msg.sender].approvedForAll &&
                !(_getApproved[amountOrId] == msg.sender)
            ) {
                revert PXP404__InvalidApproval();
            }
            _getApproved[amountOrId] = address(0);
        } else {
            // balance
            uint allowanceCheck = amountOrId >> BITS_FOR_ID;
            // check allowance
            if (_allowanceInfo[_from][msg.sender].allowance < allowanceCheck) {
                revert PXP404__InvalidApproval();
            }
            _allowanceInfo[_from][msg.sender].allowance -=
                allowanceCheck <<
                BITS_FOR_ID;
        }
        return _transfer(_from, _to, amountOrId);
    }

    function removeRogueTokens(address _token) external onlyOwner {
        uint balance;
        if (_token == address(0)) {
            balance = address(this).balance;
            (bool success, ) = payable(owner()).call{value: balance}("");
            if (!success) {
                revert PXP404__TransferFailed();
            }
            return;
        }
        balance = IERC20(_token).balanceOf(address(this));
        IERC20(_token).transfer(owner(), balance);
    }

    //----------------------------------------------------
    // Internal / Private Functions
    //----------------------------------------------------
    /**
     * @notice Transfers an ID or a balance to another address
     * @param _to The address to transfer the ID or balance to
     * @param amountOrId The ID or balance to transfer
     * @return True if the transfer was successful, reverts otherwise
     *
     * @dev GENERAL NOTES TO CONSIDER
     *  - Whitelisted users cannot have any IDs associated to them
     *
     * @dev ID TRANSFER NOTES
     *  - Whitelisted users cannot transfer IDs
     *  - Whitelisted users that receive IDs, the ID is sent to the queue.
     *
     * @dev BALANCE TRANSFER NOTES
     */
    function _transfer(
        address _from,
        address _to,
        uint amountOrId
    ) internal returns (bool) {
        UserInfo storage sender = _userInfo[_from];
        UserInfo storage receiver = _userInfo[_to];
        if (amountOrId >> BITS_FOR_ID == 0) {
            // transfer a single ID
            if (!_checkIfIdIsValid(amountOrId) || whitelist[_from]) {
                revert PXP404__InvalidId(amountOrId);
            }
            IdInfo storage idToTransfer = _idInfo[amountOrId];
            if (ownerOf(amountOrId) != _from) {
                revert PXP404__InvalidOwner();
            }
            // removeID from owner
            uint arrayLength = sender.ownedIds.length;
            uint lastArrayValue = sender.ownedIds[arrayLength - 1];
            sender.ownedIds[idToTransfer.ownerArrayIndex] = lastArrayValue;
            sender.ownedIds.pop();
            // deduct balance from owner
            sender.balance -= 1 ether;
            // increase balance of receiver
            receiver.balance += 1 ether;
            if (whitelist[_to]) {
                _queuedIds.push(amountOrId);
            } else {
                // add ID to receiver
                receiver.ownedIds.push(amountOrId);
            }
            // emit transfer event
            emit Transfer(_from, _to, amountOrId);
            return true;
        } else {
            // Clean up amount
            amountOrId = amountOrId >> BITS_FOR_ID;
            amountOrId = amountOrId << BITS_FOR_ID;
            // transfer a balance
            sender.balance -= amountOrId;
            receiver.balance += amountOrId;
            // @audit-ok
            // Transfer of IDs
            uint idsToSend = 0;
            uint[] memory idsToSendArray = new uint[](0);
            if (!whitelist[_from]) {
                idsToSend = sender.ownedIds.length; // should be 15
                idsToSend -= sender.balance / UNIT; // sending 9.3 diff should be 6

                idsToSendArray = new uint[](idsToSend);
                for (uint i = 0; i < idsToSend; i++) {
                    uint lastIndex = sender.ownedIds.length - 1;
                    idsToSendArray[i] = sender.ownedIds[lastIndex];
                    _getApproved[idsToSendArray[i]] = address(0);
                    sender.ownedIds.pop();
                }
            }
            uint idsToGet = 0;
            if (idsToSend > 0) {
                if (whitelist[_to]) {
                    for (uint j = 0; j < idsToSend; j++) {
                        _queuedIds.push(idsToSendArray[j]);
                        _idInfo[idsToSendArray[j]].isFractioned = true;
                        _idInfo[idsToSendArray[j]].owner = address(0);
                    }
                } else {
                    idsToGet =
                        (receiver.balance / UNIT) - // 9.3 ~ 9
                        receiver.ownedIds.length; // 0
                    uint receiveFromSender = idsToSend > idsToGet
                        ? idsToGet
                        : idsToSend;
                    for (uint j = 0; j < receiveFromSender; j++) {
                        receiver.ownedIds.push(idsToSendArray[j]);
                        _idInfo[idsToSendArray[j]].isFractioned = false;
                        _idInfo[idsToSendArray[j]].owner = _to;
                    }
                    if (idsToSend > receiveFromSender) {
                        for (uint j = receiveFromSender; j < idsToSend; j++) {
                            _queuedIds.push(idsToSendArray[j]);
                            _idInfo[idsToSendArray[j]].isFractioned = true;
                            _idInfo[idsToSendArray[j]].owner = address(0);
                        }
                    }
                }
            }
            if (!whitelist[_to]) {
                /// Getting NEW ids
                idsToGet =
                    (receiver.balance / UNIT) - // 9.3 ~ 9
                    receiver.ownedIds.length; // 0
                for (uint i = 0; i < idsToGet; i++) {
                    /// else MINT new ID
                    if (_queuedIds.length > 0) {
                        uint lastIndexValue = _queuedIds.length - 1;
                        lastIndexValue = _queuedIds[lastIndexValue];
                        receiver.ownedIds.push(lastIndexValue);
                        _idInfo[lastIndexValue].isFractioned = false;
                        _idInfo[lastIndexValue].owner = _to;
                        _queuedIds.pop();
                    } else {
                        maxCurrentMintedId++;
                        receiver.ownedIds.push(maxCurrentMintedId);
                        _idInfo[maxCurrentMintedId].owner = _to;
                    }
                }
            }

            emit Transfer(_from, _to, amountOrId);
            return true;
        }
    }

    //----------------------------------------------------
    // External / Public VIEW - PURE Functions
    //----------------------------------------------------
    function balanceOf(address _owner) public view returns (uint) {
        return _userInfo[_owner].balance;
    }

    /**
     * @notice Returns the IDs owned by the owner
     * @param _owner The owner of the IDs
     * @return The IDs owned by the owner
     */
    function userOwnedIds(
        address _owner
    ) external view returns (uint[] memory) {
        return _userInfo[_owner].ownedIds;
    }

    function ownerOf(uint id) public view returns (address) {
        if (!_checkIfIdIsValid(id)) {
            revert PXP404__InvalidId(id);
        }
        if (id > maxCurrentMintedId) {
            return owner();
        }
        if (_idInfo[id].isFractioned) {
            return address(0);
        }
        return _idInfo[id].owner;
    }

    function getApproved(uint id) external view returns (address operator) {
        if (!_checkIfIdIsValid(id)) {
            revert PXP404__InvalidId(id);
        }
        if (_idInfo[id].isFractioned) {
            return address(0);
        }
        if (id > maxCurrentMintedId) {
            return address(0);
        }
        return _getApproved[id];
    }

    function allowance(
        address _owner,
        address spender
    ) external view returns (uint) {
        return _allowanceInfo[_owner][spender].allowance;
    }

    function isApprovedForAll(
        address _operator,
        address _owner
    ) external view returns (bool) {
        return _allowanceInfo[_owner][_operator].approvedForAll;
    }

    function tokenURI(uint256 id) external view returns (string memory) {
        if (!_checkIfIdIsValid(id)) {
            revert PXP404__InvalidId(id);
        }
        return
            string.concat(
                string.concat(
                    "ipfs://bafybeicguehuve4djpaf6ay2drq7lb6wlpy43fyfsfr6vlri3z2rzt2e7u/",
                    id.toString()
                ),
                ".json"
            );
    }

    //----------------------------------------------------
    // Internal / Private VIEW - PURE Functions
    //----------------------------------------------------
    /**
     * @notice Checks if the id is valid
     * @param id The id to check
     * @return True if the id is valid, false otherwise
     */
    function _checkIfIdIsValid(uint id) private view returns (bool) {
        return id <= totalSupply && id > 0;
    }
}

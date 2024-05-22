// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC404} from "./interfaces/IERC404.sol";
import {ERC721Holder} from "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

contract PXP404 is Ownable, ERC721Holder, IERC404 {
    //----------------------------------------------------
    // Errors
    //----------------------------------------------------
    error PXP404__InvalidId(uint id);
    error PXP404__InvalidOwner();
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
            if (!_checkIfIdIsValid(balanceToApprove)) {
                revert PXP404__InvalidId(balanceToApprove);
            }
            // Check for ID ownership
            if (_idInfo[balanceToApprove].owner != msg.sender) {
                revert PXP404__InvalidOwner();
            }
            getApproved[balanceToApprove] = spenderOrOperator;
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
    function setWhitelisedStatus(
        address _newWhitelist,
        bool _isWhitelisted
    ) external onlyOwner {
        whitelist[_newWhitelist] = _isWhitelisted;
        emit WhitelistStatusChanged(_newWhitelist, _isWhitelisted);
    }

    //----------------------------------------------------
    // Internal / Private Functions
    //----------------------------------------------------
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
        if (id < maxCurrentMintedId) {
            return owner();
        }
        address idOwner = _idInfo[id].owner;
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
        if (id < maxCurrentMintedId) {
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

    //----------------------------------------------------
    // Internal / Private VIEW - PURE Functions
    //----------------------------------------------------
    /**
     * @notice Checks if the id is valid
     * @param id The id to check
     * @return True if the id is valid, false otherwise
     */
    function _checkIfIdIsValid(uint id) private view returns (bool) {
        return id < totalSupply;
    }
}

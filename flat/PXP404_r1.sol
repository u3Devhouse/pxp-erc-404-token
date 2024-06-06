// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol

// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/IERC20.sol)

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}

// lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol

// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC721/IERC721Receiver.sol)

/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be
     * reverted.
     *
     * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

// lib/openzeppelin-contracts/contracts/utils/Context.sol

// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// lib/openzeppelin-contracts/contracts/utils/math/Math.sol

// OpenZeppelin Contracts (last updated v5.0.0) (utils/math/Math.sol)

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    /**
     * @dev Muldiv operation overflow.
     */
    error MathOverflowedMulDiv();

    enum Rounding {
        Floor, // Toward negative infinity
        Ceil, // Toward positive infinity
        Trunc, // Toward zero
        Expand // Away from zero
    }

    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     */
    function tryAdd(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
     */
    function trySub(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     */
    function tryMul(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     */
    function tryDiv(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     */
    function tryMod(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow.
        return (a & b) + (a ^ b) / 2;
    }

    /**
     * @dev Returns the ceiling of the division of two numbers.
     *
     * This differs from standard division with `/` in that it rounds towards infinity instead
     * of rounding towards zero.
     */
    function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        if (b == 0) {
            // Guarantee the same behavior as in a regular Solidity division.
            return a / b;
        }

        // (a + b - 1) / b can overflow on addition, so we distribute.
        return a == 0 ? 0 : (a - 1) / b + 1;
    }

    /**
     * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or
     * denominator == 0.
     * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv) with further edits by
     * Uniswap Labs also under MIT license.
     */
    function mulDiv(
        uint256 x,
        uint256 y,
        uint256 denominator
    ) internal pure returns (uint256 result) {
        unchecked {
            // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
            // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
            // variables such that product = prod1 * 2^256 + prod0.
            uint256 prod0 = x * y; // Least significant 256 bits of the product
            uint256 prod1; // Most significant 256 bits of the product
            assembly {
                let mm := mulmod(x, y, not(0))
                prod1 := sub(sub(mm, prod0), lt(mm, prod0))
            }

            // Handle non-overflow cases, 256 by 256 division.
            if (prod1 == 0) {
                // Solidity will revert if denominator == 0, unlike the div opcode on its own.
                // The surrounding unchecked block does not change this fact.
                // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
                return prod0 / denominator;
            }

            // Make sure the result is less than 2^256. Also prevents denominator == 0.
            if (denominator <= prod1) {
                revert MathOverflowedMulDiv();
            }

            ///////////////////////////////////////////////
            // 512 by 256 division.
            ///////////////////////////////////////////////

            // Make division exact by subtracting the remainder from [prod1 prod0].
            uint256 remainder;
            assembly {
                // Compute remainder using mulmod.
                remainder := mulmod(x, y, denominator)

                // Subtract 256 bit number from 512 bit number.
                prod1 := sub(prod1, gt(remainder, prod0))
                prod0 := sub(prod0, remainder)
            }

            // Factor powers of two out of denominator and compute largest power of two divisor of denominator.
            // Always >= 1. See https://cs.stackexchange.com/q/138556/92363.

            uint256 twos = denominator & (0 - denominator);
            assembly {
                // Divide denominator by twos.
                denominator := div(denominator, twos)

                // Divide [prod1 prod0] by twos.
                prod0 := div(prod0, twos)

                // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
                twos := add(div(sub(0, twos), twos), 1)
            }

            // Shift in bits from prod1 into prod0.
            prod0 |= prod1 * twos;

            // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
            // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
            // four bits. That is, denominator * inv = 1 mod 2^4.
            uint256 inverse = (3 * denominator) ^ 2;

            // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also
            // works in modular arithmetic, doubling the correct bits in each step.
            inverse *= 2 - denominator * inverse; // inverse mod 2^8
            inverse *= 2 - denominator * inverse; // inverse mod 2^16
            inverse *= 2 - denominator * inverse; // inverse mod 2^32
            inverse *= 2 - denominator * inverse; // inverse mod 2^64
            inverse *= 2 - denominator * inverse; // inverse mod 2^128
            inverse *= 2 - denominator * inverse; // inverse mod 2^256

            // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
            // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
            // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
            // is no longer required.
            result = prod0 * inverse;
            return result;
        }
    }

    /**
     * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
     */
    function mulDiv(
        uint256 x,
        uint256 y,
        uint256 denominator,
        Rounding rounding
    ) internal pure returns (uint256) {
        uint256 result = mulDiv(x, y, denominator);
        if (unsignedRoundsUp(rounding) && mulmod(x, y, denominator) > 0) {
            result += 1;
        }
        return result;
    }

    /**
     * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded
     * towards zero.
     *
     * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
     */
    function sqrt(uint256 a) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
        //
        // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
        // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
        //
        // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
        // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
        // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
        //
        // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
        uint256 result = 1 << (log2(a) >> 1);

        // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
        // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
        // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
        // into the expected uint128 result.
        unchecked {
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            return min(result, a / result);
        }
    }

    /**
     * @notice Calculates sqrt(a), following the selected rounding direction.
     */
    function sqrt(
        uint256 a,
        Rounding rounding
    ) internal pure returns (uint256) {
        unchecked {
            uint256 result = sqrt(a);
            return
                result +
                (unsignedRoundsUp(rounding) && result * result < a ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 2 of a positive value rounded towards zero.
     * Returns 0 if given 0.
     */
    function log2(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 128;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 64;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 32;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 16;
            }
            if (value >> 8 > 0) {
                value >>= 8;
                result += 8;
            }
            if (value >> 4 > 0) {
                value >>= 4;
                result += 4;
            }
            if (value >> 2 > 0) {
                value >>= 2;
                result += 2;
            }
            if (value >> 1 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(
        uint256 value,
        Rounding rounding
    ) internal pure returns (uint256) {
        unchecked {
            uint256 result = log2(value);
            return
                result +
                (unsignedRoundsUp(rounding) && 1 << result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 10 of a positive value rounded towards zero.
     * Returns 0 if given 0.
     */
    function log10(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >= 10 ** 64) {
                value /= 10 ** 64;
                result += 64;
            }
            if (value >= 10 ** 32) {
                value /= 10 ** 32;
                result += 32;
            }
            if (value >= 10 ** 16) {
                value /= 10 ** 16;
                result += 16;
            }
            if (value >= 10 ** 8) {
                value /= 10 ** 8;
                result += 8;
            }
            if (value >= 10 ** 4) {
                value /= 10 ** 4;
                result += 4;
            }
            if (value >= 10 ** 2) {
                value /= 10 ** 2;
                result += 2;
            }
            if (value >= 10 ** 1) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(
        uint256 value,
        Rounding rounding
    ) internal pure returns (uint256) {
        unchecked {
            uint256 result = log10(value);
            return
                result +
                (unsignedRoundsUp(rounding) && 10 ** result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 256 of a positive value rounded towards zero.
     * Returns 0 if given 0.
     *
     * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
     */
    function log256(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 16;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 8;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 4;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 2;
            }
            if (value >> 8 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log256(
        uint256 value,
        Rounding rounding
    ) internal pure returns (uint256) {
        unchecked {
            uint256 result = log256(value);
            return
                result +
                (
                    unsignedRoundsUp(rounding) && 1 << (result << 3) < value
                        ? 1
                        : 0
                );
        }
    }

    /**
     * @dev Returns whether a provided rounding mode is considered rounding up for unsigned integers.
     */
    function unsignedRoundsUp(Rounding rounding) internal pure returns (bool) {
        return uint8(rounding) % 2 == 1;
    }
}

// lib/openzeppelin-contracts/contracts/utils/math/SignedMath.sol

// OpenZeppelin Contracts (last updated v5.0.0) (utils/math/SignedMath.sol)

/**
 * @dev Standard signed math utilities missing in the Solidity language.
 */
library SignedMath {
    /**
     * @dev Returns the largest of two signed numbers.
     */
    function max(int256 a, int256 b) internal pure returns (int256) {
        return a > b ? a : b;
    }

    /**
     * @dev Returns the smallest of two signed numbers.
     */
    function min(int256 a, int256 b) internal pure returns (int256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two signed numbers without overflow.
     * The result is rounded towards zero.
     */
    function average(int256 a, int256 b) internal pure returns (int256) {
        // Formula from the book "Hacker's Delight"
        int256 x = (a & b) + ((a ^ b) >> 1);
        return x + (int256(uint256(x) >> 255) & (a ^ b));
    }

    /**
     * @dev Returns the absolute unsigned value of a signed value.
     */
    function abs(int256 n) internal pure returns (uint256) {
        unchecked {
            // must be unchecked in order to support `n = type(int256).min`
            return uint256(n >= 0 ? n : -n);
        }
    }
}

// lib/openzeppelin-contracts/contracts/access/Ownable.sol

// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// src/interfaces/IERC404.sol

/**
 * @title IERC404
 * @author Semi Invader
 * @notice This is the interface to complete ERC404 by using ERC20 and what's missing of ERC721
 */
interface IERC404 is IERC20 {
    event IdTransfer(address indexed from, address indexed to, uint indexed id);
    event IdApproval(
        address indexed owner,
        address indexed operator,
        uint indexed id
    );
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    function ownerOf(uint256 tokenId) external view returns (address owner);

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function setApprovalForAll(address operator, bool approved) external;

    function getApproved(
        uint256 tokenId
    ) external view returns (address operator);

    function isApprovedForAll(
        address owner,
        address operator
    ) external view returns (bool);
}

// lib/openzeppelin-contracts/contracts/utils/Strings.sol

// OpenZeppelin Contracts (last updated v5.0.0) (utils/Strings.sol)

/**
 * @dev String operations.
 */
library Strings {
    bytes16 private constant HEX_DIGITS = "0123456789abcdef";
    uint8 private constant ADDRESS_LENGTH = 20;

    /**
     * @dev The `value` string doesn't fit in the specified `length`.
     */
    error StringsInsufficientHexLength(uint256 value, uint256 length);

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        unchecked {
            uint256 length = Math.log10(value) + 1;
            string memory buffer = new string(length);
            uint256 ptr;
            /// @solidity memory-safe-assembly
            assembly {
                ptr := add(buffer, add(32, length))
            }
            while (true) {
                ptr--;
                /// @solidity memory-safe-assembly
                assembly {
                    mstore8(ptr, byte(mod(value, 10), HEX_DIGITS))
                }
                value /= 10;
                if (value == 0) break;
            }
            return buffer;
        }
    }

    /**
     * @dev Converts a `int256` to its ASCII `string` decimal representation.
     */
    function toStringSigned(
        int256 value
    ) internal pure returns (string memory) {
        return
            string.concat(
                value < 0 ? "-" : "",
                toString(SignedMath.abs(value))
            );
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        unchecked {
            return toHexString(value, Math.log256(value) + 1);
        }
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(
        uint256 value,
        uint256 length
    ) internal pure returns (string memory) {
        uint256 localValue = value;
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = HEX_DIGITS[localValue & 0xf];
            localValue >>= 4;
        }
        if (localValue != 0) {
            revert StringsInsufficientHexLength(value, length);
        }
        return string(buffer);
    }

    /**
     * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal
     * representation.
     */
    function toHexString(address addr) internal pure returns (string memory) {
        return toHexString(uint256(uint160(addr)), ADDRESS_LENGTH);
    }

    /**
     * @dev Returns true if the two strings are equal.
     */
    function equal(
        string memory a,
        string memory b
    ) internal pure returns (bool) {
        return
            bytes(a).length == bytes(b).length &&
            keccak256(bytes(a)) == keccak256(bytes(b));
    }
}

// src/PXP404.sol

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

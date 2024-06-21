# PXP ERC404 Implementation

## ERC404

### Disclaimer

ERC404 is not an actual ERC. It is a made up proposal that mixed up ERC20 and ERC721.

### Motivation

Client requested an ERC404 implementation for their NFT project. The contract follows a few added constraints that deviate from the base ERC404 created by [Pandora-Labs-Org](https://github.com/Pandora-Labs-Org/erc404/blob/main/contracts/ERC404.sol).

#### Additional Constraints

1. Token Ids are not to be repeated, each token will have it's own id.
2. Fractionalized tokens are allowed and placed in a queue.
3. Minting should still be considered random.

### Implementation

In order to correctly separate between `ID` definition and full tokens, we take an approach where the value stored for balances, reserves the least significant 16 bits which will be exclusively for storing IDs.

The process can be described as follows on a high level:

1. UserA sets up to Transfer `X` tokens to UserB.
2. The value of `X` in wei is `X * 1e18`.
3. `transfer` function proceeds to strip the value down by doing a right shift of 16 bits.
   a. If the resulting value is `0`, then the transfer is considered a specific `ID` transfer.
   b. If the resulting value is not `0`, then the transfer is considered a normal balance transfer.
4. For `ID` transfers, the contract verifies ownership beforehand.
   a. Balance for recipient is updated.
   b. `ID` is stored in UserB's list of owned `IDs`
5. For normal balance transfers, it is assumed that the recipient already has the tokens and any IDs associated to them transfered out in a First-In-Last-Out manner.
   a. Any `IDs` that might be fractionalized are stored in an intermediary queue.
   b. Balance for recipient is updated.
   c. Any fully created tokens are either minted or popped from the queue, this depends on the current length of the queue.

### Randomness

There is no actual randomness involved in the minting process, however when organizing the ID's for the URI, all NFTs where shuffled and then uploaded in a shuffled manner.

To prevent any bias, all tokens prefer to use the queued token ID's first before minting, and the queue is marked private to prevent any would be snipers from easily manipulating the queue.

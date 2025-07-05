# SimpleSwap  - Detailed Explanation

Overview:
----------
SimpleSwap is a decentralized exchange (DEX) smart contract implemented in Solidity. Inspired by the core mechanics of Uniswap, it allows users to:

1. Add liquidity to a pool of two ERC-20 tokens.
2. Remove liquidity from an existing pool.
3. Swap tokens between pairs with an automatic pricing mechanism.
4. Query token prices and expected swap outputs.

Core Concepts:
--------------

1. Liquidity Pools:
   - Each token pair (tokenA, tokenB) is associated with a 'LiquidityData' structure.
   - This structure contains:
     • totalSupply: Total amount of liquidity tokens issued.
     • balance: Mapping of user addresses to their liquidity balance.
     • amounts: Contains current token reserves (amountA and amountB)
## 📦 Functions 

### addLiquidity

Adds liquidity to the pool and mints LP tokens.

- Parameters:
  - `tokenA`, `tokenB`: Token addresses
  - `amountADesired`, `amountBDesired`: Desired amounts
  - `amountAMin`, `amountBMin`: Minimum amounts for slippage protection
  - `to`: Receiver of LP tokens
  - `deadline`: Expiration timestamp

### `removeLiquidity(...)`

Burns LP tokens and returns the corresponding share of tokens.

- Parameters:
  - `tokenA`, `tokenB`: Token addresses
  - `liquidity`: Amount of LP tokens to burn
  - `amountAMin`, `amountBMin`: Minimum withdrawal amounts
  - `to`: Receiver of tokens
  - `deadline`: Expiration timestamp

### `swapExactTokensForTokens(...)`

Swaps a fixed amount of one token for another.

- Parameters:
  - `amountIn`: Exact input token amount
  - `amountOutMin`: Minimum output (slippage protection)
  - `path`: `[tokenIn, tokenOut]`
  - `to`: Receiver of output tokens
  - `deadline`: Expiration timestamp

### `getPrice(tokenA, tokenB)`

Returns the price ratio between two tokens.

### `getAmountOut(amountIn, reserveIn, reserveOut)`

Returns the estimated output amount given input and pool reserves.

Security:
---------
- Uses OpenZeppelin's ReentrancyGuard to prevent reentrancy attacks on liquidity and swap operations.
- Input validation is performed for deadlines, amount values, and reserve checks.


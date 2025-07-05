// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.0;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract Simpleswap is ERC20 {
    constructor() ERC20("li","l"){}
     /// @notice Adds liquidity to the pool
    /// @dev Mints LP tokens proportionally based on token reserves
    /// @param tokenA Address of token A
    /// @param tokenB Address of token B
    /// @param amountADesired Desired amount of token A to add
    /// @param amountBDesired Desired amount of token B to add
    /// @param amountAMin Minimum acceptable amount of token A
    /// @param amountBMin Minimum acceptable amount of token B
    /// @param to Address to receive LP tokens
    /// @param deadline Timestamp after which the transaction is invalid
    /// @return amountA Final amount of token A added
    /// @return amountB Final amount of token B added
    /// @return liquidity Amount of LP tokens minted

    function addLiquidity(
        address tokenA, 
        address tokenB, 
        uint amountADesired,
        uint amountBDesired, 
        uint amountAMin, 
        uint amountBMin, 
        address to, 
        uint deadline
        ) external returns (uint amountA, uint amountB, uint liquidity){
            require(deadline >=block.timestamp,"deadlineReached" );
            liquidity = totalSupply();
            if(liquidity > 0){
                uint256 l1= (amountADesired * liquidity)/ ERC20(tokenA).balanceOf(address(this));
                uint256 l2= (amountBDesired * liquidity)/ ERC20(tokenB).balanceOf(address(this));
                if(l1 < l2) {
                    amountA = amountADesired;
                    amountB = getPrice(tokenA, tokenB)*amountA;
                }else {
                    amountB = amountBDesired;
                    amountA = getPrice(tokenB, tokenA)*amountB;
                }
            }else{
                liquidity = amountADesired;
                amountA = amountADesired;
                amountB = amountBDesired;
            }
            require(amountAMin<=amountA);
            require(amountBMin <=amountB);
            ERC20(tokenA).transferFrom(msg.sender, address(this),amountA);
            ERC20(tokenB).transferFrom(msg.sender, address(this), amountB);
            _mint(to, liquidity);
        }
            /** @notice Removes liquidity and returns tokens to the user
              * @dev Burns LP tokens in exchange for tokenA and tokenB from the pool
              * @param tokenA Address of token A
              * @param tokenB Address of token B
              *  @param liquidity Amount of LP tokens to burn
              * @param amountAMin Minimum acceptable amount of token A
              * @param amountBMin Minimum acceptable amount of token B
              * @param to Address to receive tokens
              * @param deadline Timestamp after which the transaction is invalid
              *@return amountA Amount of token A returned
              *@return amountB Amount of token B returned
           **/ 
           

         function removeLiquidity(
            address tokenA, 
            address tokenB, 
            uint liquidity, 
            uint amountAMin, 
            uint amountBMin, 
            address to, 
            uint deadline
            ) external returns (uint amountA, uint amountB){
                //implementacion goes here
                require(deadline>= block.timestamp, "deadlineReached");
                uint256 totalLiquidity = totalSupply();

                amountA = liquidity * ERC20(tokenA).balanceOf(address(this))/totalLiquidity;
                amountB = liquidity * ERC20(tokenB).balanceOf(address(this))/totalLiquidity;

                require(amountAMin<=amountA);
                require(amountBMin <=amountB);

                _burn(msg.sender, liquidity);
                ERC20(tokenA).transfer(to, amountA);
                ERC20(tokenB).transfer(to,amountB);

            }
          /**
             @notice Swaps exact amount of input token for as much as possible of output token
             @dev Uses a simplified pricing formula, not constant product
             @param amountIn Exact amount of input token to send
             @param amountOutMin Minimum acceptable amount of output token to receive
             @param path Array with [tokenIn, tokenOut]
             @param to Recipient address for output token
             @param deadline Timestamp after which the transaction is invalid
             @return amounts Array of [amountIn, amountOut]
          **/

            function swapExactTokensForTokens(
                uint amountIn, 
                uint amountOutMin, 
                address[] calldata path, 
                address to, 
                uint deadline
                ) external returns (uint[] memory amounts){
                    require(deadline>= block.timestamp, "deadlineReached");
                    //implementacion goes here
                    ERC20 tokenA = ERC20(path[0]);
                    ERC20 tokenB = ERC20(path[1]);
                    
                    uint256 amountOut = amountIn * tokenB.balanceOf(address(this))/(amountIn+tokenA.balanceOf(address(this)));
                    require(amountOut>=amountOutMin);
                    tokenA.transferFrom(msg.sender, address(this),0);
                    tokenB.transfer(to, amountOut);
                    amounts = new uint[](2);
                    amounts[0] = amountIn;
                    amounts[1]= amountOut;
                }
                /**
                 * @notice Returns the current price of tokenA in terms of tokenB.
                 * @param tokenA Address of tokenA.
                 * @param tokenB Address of tokenB.
                 * @return price The ratio tokenB/tokenA with 18 decimals.
                 **/

                function getPrice(address tokenA, address tokenB) public view returns (uint price){
                    //implementacion goes here
                    uint256 amount1 = ERC20(tokenA).balanceOf(address(this));
                    uint256 amount2 = ERC20(tokenB).balanceOf(address(this));
                    return (amount2*1e18)/amount1;
                }

                /**
                  * @dev Calculates how many tokens will be received in a swap.
                  * @param amountIn Input token amount.
                  * @param reserveIn Reserve of input token.
                  * @param reserveOut Reserve of output token.
                  * @return amountOut Expected output amount.
                 **/

                function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut){
                    //implementacion goes here
                    amountOut = amountIn * reserveOut/(amountIn+reserveIn);
                }
        

    

}
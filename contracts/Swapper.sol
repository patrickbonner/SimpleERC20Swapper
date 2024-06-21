// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ERC20Swapper {
    /// @dev swaps the `msg.value` Ether to at least `minAmount` of tokens in `address`, or reverts
    /// @param token The address of ERC-20 token to swap
    /// @param minAmount The minimum amount of tokens transferred to msg.sender
    /// @return The actual amount of transferred tokens
    function swapEtherToToken(address token, uint minAmount) external payable returns (uint);
}

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
}

interface IUniswapV2Router {
    function WETH() external pure returns (address);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
}

contract SimpleERC20Swapper is ERC20Swapper {
    address private owner;
    IUniswapV2Router private uniswapRouter;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    function initialize(address _uniswapRouter) external {
        owner = msg.sender;
        uniswapRouter = IUniswapV2Router(_uniswapRouter);
    }

    function swapEtherToToken(address token, uint minAmount) external override payable returns (uint) {
        require(msg.value > 0, "Must send Ether to swap");

        address[] memory path = new address[](2);
        path[0] = uniswapRouter.WETH();
        path[1] = token;

        uint[] memory amounts = uniswapRouter.swapExactETHForTokens{ value: msg.value }(
            minAmount,
            path,
            msg.sender,
            block.timestamp
        );

        require(amounts[1] >= minAmount, "Received less tokens than expected");
        return amounts[1];
    }

    function updateUniswapRouter(address _newRouter) external onlyOwner {
        uniswapRouter = IUniswapV2Router(_newRouter);
    }

    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    function withdrawTokens(address token, uint amount) external onlyOwner {
        IERC20(token).transfer(owner, amount);
    }

    receive() external payable {}
}

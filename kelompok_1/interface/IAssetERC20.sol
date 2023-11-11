// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IAssetERC20 is IERC20 {
    function name() external returns (string memory);
    function decimals() external returns (uint8);
}

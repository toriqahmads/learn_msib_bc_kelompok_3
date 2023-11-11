// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ITokenRewardSampah is IERC20 {
    function awardToken(address _target, uint256 _amount) external;
    function addAdmin(address user) external;
    function decimals() external returns (uint8);
    function name() external returns (string memory);
}

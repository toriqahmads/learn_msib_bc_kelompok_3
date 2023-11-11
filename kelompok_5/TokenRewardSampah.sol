// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenRewardSampah is ERC20, Ownable {
    constructor() ERC20("Token Reward Sampah", "TRS") Ownable(msg.sender) {
        is_admin[msg.sender] = true;
    }

    // mapping of admin
    mapping(address => bool) public is_admin;

    modifier onlyAdmin() {
        require(is_admin[msg.sender], "only admin can perform this action");
        _;
    }

    function addAdmin(address user) public onlyOwner {
        is_admin[user] = true;
    }

    function decimals() override public pure returns (uint8) {
        return 6;
    }

    function awardToken(address _target, uint256 _amount) public onlyAdmin {
        _mint(_target, _amount);
    }
}

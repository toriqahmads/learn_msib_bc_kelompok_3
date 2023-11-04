// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TestToken is ERC20, Ownable {
    address perpustakaan;

    constructor(uint256 initialSupply) ERC20("Test Token", "TEST") Ownable(msg.sender)  {
        _mint(msg.sender, initialSupply);
    }

    function awardToken(address to, uint256 amount) public {
        require(msg.sender == perpustakaan, "hanya perpustakaan yg boleh call");
        _mint(to, amount);
    }

    function setAddressPerpustakaan(address _perpustakaan) public onlyOwner {
        perpustakaan = _perpustakaan;
    }
}

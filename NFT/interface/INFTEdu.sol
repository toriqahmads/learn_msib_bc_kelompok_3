// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface INFTEdu is IERC721 {
    function awardItem(address user, string memory tokenURI) external returns (uint256);
}

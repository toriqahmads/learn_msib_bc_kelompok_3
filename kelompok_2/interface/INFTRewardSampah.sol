// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface INFTRewardSampah is IERC721 {
    function addAdmin(address user) external;
    function getTokenCategory(uint256 tokenId) external view returns (string memory);
    function isCategoryExist(string memory category) external view returns (bool);
    function addCategory(string memory category, string memory tokenURI) external;
    function awardNft(address target, string memory category) external returns (uint256);
}

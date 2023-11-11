// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTRewardSampah is ERC721URIStorage, Ownable(msg.sender) {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // list of category
    string[] public categories;
    // mapping of admin
    mapping(address => bool) public is_admin;
    // mapping of tokenId have category
    mapping(uint256 => string) public token_to_category;
    // mapping of category have token uri
    mapping(string => string) public category_to_uri;

    modifier onlyAdmin() {
        require(is_admin[msg.sender], "only admin can perform this action");
        _;
    }

    constructor() ERC721("NFT Reward Sampah", "NRS") {
        is_admin[msg.sender] = true;
    }

    function addAdmin(address user) public onlyOwner {
        is_admin[user] = true;
    }

    function getTokenCategory(uint256 tokenId) public view returns (string memory) {
        return token_to_category[tokenId];
    }

    function isCategoryExist(string memory category) public view returns (bool) {
        return bytes(category_to_uri[category]).length != 0;
    }

    function addCategory(string memory category, string memory tokenURI) public onlyAdmin {
        require(!isCategoryExist(category), "NFT category already exist");
        category_to_uri[category] = tokenURI;
        categories.push(category);
    }

    function awardNft(address target, string memory category) public onlyAdmin returns (uint256) {
        require(isCategoryExist(category), "NFT category is not exist");
        uint256 newItemId = _tokenIds.current();

        _mint(target, newItemId);
        _setTokenURI(newItemId, category_to_uri[category]);
        token_to_category[newItemId] = category;

        _tokenIds.increment();
        return newItemId;
    }
}

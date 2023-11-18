// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interface/INFTRewardSampah.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TradeTrash is Ownable(msg.sender) {
    constructor (address nft_address) {
        is_admin[msg.sender] = true;
        nft = INFTRewardSampah(nft_address);
    }

    struct Trade {
        string owner_name;
        address owner_address;
        uint256 weight;
        string[] image_proof_uri;
        uint256 token_reward_id;
        uint256 date;
    }

    INFTRewardSampah public nft;

    // min weight is in gram
    uint256 public min_weight = 1000;

    Trade[] public trades;
    // for history purpose
    mapping(address => Trade[]) public owner_trades;
    // mapping of admin
    mapping(address => bool) public is_admin;

    // mapping of min weight to category
    mapping(uint256 => string) public min_weight_category;

    modifier onlyAdmin() {
        require(is_admin[msg.sender], "only admin can perform this action");
        _;
    }

    function addAdmin(address user) public onlyOwner {
        is_admin[user] = true;
        nft.addAdmin(user);
    }

    function setNftAddress(address nft_address) public onlyAdmin {
        nft = INFTRewardSampah(nft_address);
    }

    function setMinimumWeight(uint256 _min_weight) public onlyAdmin {
        min_weight = _min_weight;
    }

    function addCategory(string memory category_name, string memory token_uri) public onlyAdmin {
        nft.addCategory(category_name, token_uri);
    }

    // weight is in gram
    function tradeTrash(string memory _owner_name, address _owner, uint256 _weight, string[] memory _image_proof, string memory category) public onlyAdmin {
        require(nft.isCategoryExist(category), "Reward category is not exist");
        require(_weight >= min_weight, "Trash weight doesn't reach minimum weight for trade");

        uint256 tokenId = nft.awardNft(_owner, category);
        Trade memory trade = Trade({
            owner_name: _owner_name,
            owner_address: _owner,
            weight: _weight,
            image_proof_uri: _image_proof,
            token_reward_id: tokenId,
            date: block.timestamp
        });

        trades.push(trade);
        owner_trades[_owner].push(trade);
    }

    function getTradeByOwner(address _owner) public view returns(Trade[] memory) {
        return owner_trades[_owner];
    }

    // additional function
    // you can add function to trade the nft by category to exchange to token or what you want
}

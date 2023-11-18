// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interface/ITokenRewardSampah.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TradeTrash is Ownable(msg.sender) {
    constructor (address token_address) {
        is_admin[msg.sender] = true;
        token = ITokenRewardSampah(token_address);
        token_decimals = token.decimals();
    }

    struct Trade {
        string trade_id;
        string owner_name;
        address owner_address;
        uint256 weight;
        string[] image_proof_uri;
        uint256 reward_amount;
        uint256 date;
        bool is_verified;
    }

    ITokenRewardSampah public token;

    uint8 token_decimals;

    // exchange rate
    uint256 public exchange_rate = 600;

    // min weight is in gram
    uint256 public min_weight = 1000;

    Trade[] public trades;

    // mapping for trade id to index
    mapping(string => uint256) public trade_index;
    // mapping for trade id to index
    mapping(address => mapping(string => uint256)) public owner_trade_index;
    // for history purpose
    mapping(address => Trade[]) public owner_trades;
    // mapping of admin
    mapping(address => bool) public is_admin;

    modifier onlyAdmin() {
        require(is_admin[msg.sender], "only admin can perform this action");
        _;
    }

    function addAdmin(address user) public onlyOwner {
        is_admin[user] = true;
        token.addAdmin(user);
    }

    function setTokenAddress(address token_address) public onlyAdmin {
        token = ITokenRewardSampah(token_address);
        token_decimals = token.decimals();
    }

    function setExchangeRate(uint256 _rate) public onlyAdmin {
        exchange_rate = _rate;
    }

    function setMinimumWeight(uint256 _min_weight) public onlyAdmin {
        min_weight = _min_weight;
    }

    // weight is in gram
    // trade id should be unique id
    // please add a custom validation to check if trade is unique in this contract
    function storeTrash(string memory trade_id, string memory _owner_name, uint256 _weight, string[] memory _image_proof) public returns(string memory) {
        require(_weight >= min_weight, "Trash weight doesn't reach minimum weight for trade");

        uint256 reward_amount = getExchangeReward(_weight);

        Trade memory trade = Trade({
            trade_id: trade_id,
            owner_name: _owner_name,
            owner_address: msg.sender,
            weight: _weight,
            image_proof_uri: _image_proof,
            reward_amount: reward_amount,
            date: block.timestamp,
            is_verified: false
        });

        trades.push(trade);
        owner_trades[msg.sender].push(trade);
        trade_index[trade_id] = trades.length - 1;
        owner_trade_index[msg.sender][trade_id] = owner_trades[msg.sender].length - 1;

        return trade_id;
    }

    function verifyTradeTrash(string memory trade_id) public onlyAdmin {
        uint256 global_trade_index = trade_index[trade_id];
        require(bytes(trades[global_trade_index].trade_id).length != 0, "Trade doesn't exist");

        Trade storage global_trade = trades[global_trade_index];
        require(!global_trade.is_verified, "Trade already verified");

        uint256 _owner_trade_index = owner_trade_index[global_trade.owner_address][trade_id];
        
        global_trade.is_verified = true;
        Trade storage owner_trade = owner_trades[global_trade.owner_address][_owner_trade_index];
        owner_trade.is_verified = true;

        token.awardToken(global_trade.owner_address, global_trade.reward_amount);
    }

    function getAllTrades() public view returns(Trade[] memory) {
        return trades;
    }

    function getTradeByOwner(address _owner) public view returns(Trade[] memory) {
        return owner_trades[_owner];
    }

    // please do with your own rate ratio calculation
    function getExchangeReward(uint256 _weight) public view returns(uint256) {
        return _weight * 10 ** token_decimals * exchange_rate / 1000;
    }

    function getNotVeriviedTradeByOwner(address owner) public view returns(Trade[] memory) {
        Trade[] memory allPendingTrades = new Trade[](owner_trades[owner].length);
        for(uint i = 0; i < owner_trades[owner].length; i++) {
            if (!owner_trades[owner][i].is_verified) {
                allPendingTrades[i] = owner_trades[owner][i];
            }
        }

        return allPendingTrades;
    }

    function getNotVeriviedTrade() public view returns(Trade[] memory) {
        Trade[] memory allPendingTrades = new Trade[](trades.length);
        for(uint i = 0; i < trades.length; i++) {
            if (!trades[i].is_verified) {
                allPendingTrades[i] = trades[i];
            }
        }

        return allPendingTrades;
    }
}

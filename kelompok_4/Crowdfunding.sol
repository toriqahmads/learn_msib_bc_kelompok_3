// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Crowdfunding is Ownable(msg.sender) {
    struct Campaign {
        string campaign_id;
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        // donation id
        uint256[] donations;
    }

    struct Donation {
        address donatur;
        string campaign_id;
        uint256 amount;
        uint256 date;
    }

    struct Withdraw {
        address withdrawer;
        string campaign_id;
        address recipient;
        uint256 amount;
        uint256 date;
    }
    
    // id campaign => campaign detail
    mapping(string => Campaign) public campaigns;
    // owner address => string id campaign
    mapping(address => string[]) public owner_campaigns;
    mapping(string => uint256) public campaign_list_index;
    mapping(address => mapping(string => uint256)) public owner_campaign_list_index;
    // list id campaign
    string[] public campaign_list;

    uint256 public numberOfCampaigns;

    mapping(address => bool) public is_admin;

    // mapping saldo donatur. address token/coin => address donatur => jumlah total donasi per token/coin
    mapping(address => mapping(address => uint256)) public donatur_balance;

    // list donation for all reporting donation
    Donation[] public donations;
    // mapping donation history
    // address donatur => donation info
    // digunakan untuk melihat history per masing-masing donatur
    mapping(address => Donation[]) public donation_history;

    // list withdraw for all reporting withdraw
    Withdraw[] public withdraws;
    // mapping withdraw history
    // address withdrawer => withdraw info
    // digunakan untuk melihat history per masing-masing withdrawer
    mapping(address => Withdraw[]) public withdraw_history;

    // digunakan untuk mencatat jumlah donasi yg telah dilakukan
    uint256 public donation_total;

    uint256 public withdraw_total;

    address[] public donatur_list;

    modifier onlyAdmin() {
        require(is_admin[msg.sender], "Only admin can do this action");
        _;
    }

    constructor() {
        is_admin[msg.sender] = true;
    }

    function createCampaign(string memory _campaign_id, address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image) public onlyAdmin {
        require(!isCampaignExists(_campaign_id), "campaign already exist");
        require(_deadline > block.timestamp, "The deadline should be a date in the future");

        campaigns[_campaign_id] = Campaign({
            campaign_id: _campaign_id,
            owner: _owner,
            title: _title,
            description: _description,
            target: _target,
            deadline: _deadline,
            amountCollected: 0,
            image: _image,
            donators: new address[](0),
            donations: new uint256[](0)
        });

        owner_campaigns[_owner].push(_campaign_id);
        campaign_list.push(_campaign_id);

        campaign_list_index[_campaign_id] = campaign_list.length - 1;
        owner_campaign_list_index[_owner][_campaign_id] = owner_campaigns[_owner].length - 1;

        numberOfCampaigns += 1;
    }

    function updateCampaign(string memory _campaign_id, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image) public onlyAdmin {
        require(isCampaignExists(_campaign_id), "campaign doesn't exist");
        require(_deadline >= block.timestamp, "The deadline should be a date in the future");

        Campaign storage campaign = campaigns[_campaign_id];
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.image = _image;
    }

    function deleteCampaign(string memory _campaign_id) public onlyAdmin {
        require(isCampaignExists(_campaign_id), "campaign doesn't exist");
        
        Campaign memory campaignToDelete = campaigns[_campaign_id];
        // Pindahkan campaign terakhir ke posisi terhapus
        uint256 indexCampaignIdToDelete = campaign_list_index[_campaign_id];
        string memory lastCampaignId = campaign_list[campaign_list.length - 1];
        campaign_list[indexCampaignIdToDelete] = lastCampaignId;
        campaign_list.pop();

        uint256 indexOwnerCampaignIdToDelete = owner_campaign_list_index[campaignToDelete.owner][_campaign_id];
        string memory lastOwnerCampaignId = owner_campaigns[campaignToDelete.owner][owner_campaigns[campaignToDelete.owner].length - 1];
        owner_campaigns[campaignToDelete.owner][indexOwnerCampaignIdToDelete] = lastOwnerCampaignId;
        owner_campaigns[campaignToDelete.owner].pop();

        delete campaigns[_campaign_id];
        delete campaign_list_index[_campaign_id];

        numberOfCampaigns -= 1;
    }

    function getCampaignInfo(string memory _campaign_id) public view returns (Campaign memory campaign) {
        require(isCampaignExists(_campaign_id), "campaign doesn't exist");
        return campaigns[_campaign_id];
    }

    function isCampaignExists(string memory _campaign_id) public view returns (bool) {
        return bytes(campaigns[_campaign_id].title).length != 0;
    }

    function getCampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);
        for(uint i = 0; i < numberOfCampaigns; i++) {
            allCampaigns[i] = campaigns[campaign_list[i]];
        }
        return allCampaigns;
    }

    function getCampaignsByOwner(address owner) public view returns (Campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);
        for(uint i = 0; i < numberOfCampaigns; i++) {
            if (campaigns[campaign_list[i]].owner == owner) {
                allCampaigns[allCampaigns.length] = campaigns[campaign_list[i]];
            }
        }
        return allCampaigns;
    }

    function getCampaignIdList() public view returns (string[] memory) {
        return campaign_list;
    }

    function addAdmin(address _admin) public onlyOwner {
        is_admin[_admin] = true;
    }

    function getDonationList() public view returns (Donation[] memory) {
        return donations;
    }

    function getWithdrawList() public view returns (Withdraw[] memory) {
        return withdraws;
    }

    function getDonaturList() public view returns (address[] memory) {
        return donatur_list;
    }

    function getDonationHistoryByAddress(address donatur) public view returns (Donation[] memory) {
        return donation_history[donatur];
    }

    function getWithdrawHisotyByAddress(address withdrawer) public view returns (Withdraw[] memory) {
        return withdraw_history[withdrawer];
    }

    function donateToCampaign(string memory _campaign_id) public payable {
        require(isCampaignExists(_campaign_id), "campaign doesn't exist");
        uint256 amount = msg.value;

        Campaign storage campaign = campaigns[_campaign_id];

        require(campaign.deadline >= block.timestamp, "Campaign already finish");
    
        Donation memory donation = Donation({
            donatur: msg.sender,
            campaign_id: _campaign_id,
            amount: amount,
            date: block.timestamp
        });

        donation_history[msg.sender].push(donation);
        donations.push(donation);

        campaign.amountCollected = campaign.amountCollected + amount;
        campaign.donators.push(msg.sender);
        campaign.donations.push(donations.length - 1);

        donatur_list.push(msg.sender);

        donation_total += 1;
    }

    function withdraw(string memory _campaign_id) public {
        require(isCampaignExists(_campaign_id), "campaign doesn't exist");
        
        Campaign storage campaign = campaigns[_campaign_id];
        require(msg.sender == campaign.owner || is_admin[msg.sender], "Only campaign owner or admin can withdraw this balance");
        require(campaign.deadline <= block.timestamp, "Campaign doesn't finish yet");

        (bool sent,) = payable(campaign.owner).call{value: campaign.amountCollected}("");
        require(sent, "Failed to transfer campaign balance to campaign owner");
        Withdraw memory _withdraw = Withdraw({
            withdrawer: msg.sender,
            campaign_id: _campaign_id,
            recipient: campaign.owner,
            amount: campaign.amountCollected,
            date: block.timestamp
        });

        withdraw_history[msg.sender].push(_withdraw);
        withdraws.push(_withdraw);

        withdraw_total += 1;
    }
}

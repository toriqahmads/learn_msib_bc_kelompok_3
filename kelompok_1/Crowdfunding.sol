// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interface/IAssetERC20.sol";

contract Crowdfunding is Ownable(msg.sender) {
    struct Project {
        // name of project
        string name;
        // description of project;
        string description;
        // list of image url of project
        string[] images;
        // start_date is a unix timestamp epoch of date
        // ex.: 1699679853 -> GMT: Saturday, November 11, 2023 5:17:33 AM
        // https://www.epochconverter.com
        uint256 date;
    }

    struct Donation {
        address donatur;
        address asset;
        string asset_name;
        uint256 amount;
        uint8 decimal;
        uint256 date;
    }

    struct Withdraw {
        address recipient;
        string usage_description;
        address asset;
        string asset_name;
        uint256 amount;
        uint8 decimal;
        uint256 date;
    }

    struct Asset {
        address token;
        string name;
        uint8 decimal;
    }

    Project[] public projects;
    string[] public project_name_list;
    address[] public donatur_list;
    Asset[] public asset_list;

    // token address => index asset
    mapping(address => uint256) public index_asset;
    // name project => index project
    mapping(string => uint256) public index_projects;
    // name project => index name project
    mapping(string => uint256) public index_name_project_list;

    mapping(address => bool) public is_admin;

    mapping(string => bool) public is_project_exist;
    mapping(address => bool) public is_asset_exist;

    // mapping saldo donatur. address token/coin => address donatur => jumlah total donasi per token/coin
    // 0x0000000000000000000000000 address token menandakan donasinya adalah coin
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

    modifier onlyAdmin() {
        require(is_admin[msg.sender], "Only admin can do this action");
        _;
    }

    event ProjectAdded(string indexed name, uint256 index);
    event ProjectUpdated(string indexed name, uint256 index);
    event ProjectDeleted(string indexed name);
    event Donated(address indexed asset, address indexed donatur, uint256 amount);
    event Withdrew(address indexed asset, address indexed withdrawer, uint256 amount, string usage_description);

    constructor() {
        is_admin[msg.sender] = true;
    }

    function addProject(string memory _name, string memory _description, string[] memory _images, uint256 _date) public onlyAdmin {
        require(!isProjectExists(_name), "Project with those name already exist");
        projects.push(Project({
            name: _name,
            description: _description,
            images: _images,
            date: _date
        }));

        index_projects[_name] = projects.length - 1;
        project_name_list.push(_name);
        index_name_project_list[_name] = project_name_list.length - 1;
        is_project_exist[_name] = true;

        emit ProjectAdded(_name, projects.length - 1);
    }

    function updateProject(string memory _name, string memory _description, string[] memory _images, uint256 _date) public onlyAdmin {
        require(isProjectExists(_name), "Project with those name is not exist");

        uint256 index = index_projects[_name];
        projects[index] = Project({
            name: _name,
            description: _description,
            images: _images,
            date: _date
        });
        
        emit ProjectUpdated(_name, index);
    }

    function deleteProject(string memory _name) public onlyAdmin {
        require(isProjectExists(_name), "Project with those name is not exist");
        
        // Pindahkan project terakhir ke posisi terhapus
        uint256 indexToDelete = index_projects[_name];
        Project memory lastProject = projects[projects.length - 1];
        projects[indexToDelete] = lastProject;
        index_projects[lastProject.name] = indexToDelete;
        projects.pop();

        // pindahkan list nama project terakhir ke posisi terhapus
        uint256 indexNameToDelete = index_name_project_list[_name];
        string memory lastProjectName = project_name_list[project_name_list.length - 1];
        project_name_list[indexNameToDelete] = lastProjectName;
        index_name_project_list[lastProjectName] = indexNameToDelete;
        project_name_list.pop();

        delete is_project_exist[_name];
        
        emit ProjectDeleted(_name);
    }

    function getProjectInfo(string memory _name) public view returns (string memory name, string memory description, string[] memory images, uint256 date) {
        require(isProjectExists(_name), "Project with those name is not exist");

        uint256 index = index_projects[_name];
        Project storage project = projects[index];
        return (project.name, project.description, project.images, project.date);
    }

    function isProjectExists(string memory _name) public view returns (bool) {
        return is_project_exist[_name];
    }

    function isAssetExists(address _token) public view returns (bool) {
        return is_asset_exist[_token];
    }

    function getProjectNameList() public view returns (string[] memory) {
        return project_name_list;
    }

    function getProjectList() public view returns (Project[] memory) {
        return projects;
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

    function getAssetList() public view returns (Asset[] memory) {
        return asset_list;
    }

    function getDonationHistoryByAddress(address donatur) public view returns (Donation[] memory) {
        return donation_history[donatur];
    }

    function getWithdrawHisotyByAddress(address withdrawer) public view returns (Withdraw[] memory) {
        return withdraw_history[withdrawer];
    }

    function donate(address _asset, uint256 _amount) public payable {
        uint8 decimal = 18;
        string memory asset_name = "ether";
        if (_asset == address(0)) {
            _amount = msg.value;
            require(msg.value >= 0.001 ether, "Donasi tidak boleh kurang dari 0.001 ether");
            require(payable(msg.sender).balance >= _amount, "Insuffient account coin balances");
        } else {
            IAssetERC20 asset = IAssetERC20(_asset);
            decimal = asset.decimals();
            asset_name = asset.name();
            require(_amount >= 1 * (10 ** decimal) / 1000, "Donasi tidak boleh kurang dari 0.001 token"); // 1 / 1000 = 0.001
            require(asset.balanceOf(msg.sender) >= _amount, "Insuffient account token balances");
        
            asset.transferFrom(payable(msg.sender), payable(address(this)), _amount);
        }
        
        donatur_balance[_asset][msg.sender] += _amount;
        donation_total += 1;

        Donation memory donation = Donation({
            donatur: msg.sender,
            asset: _asset,
            asset_name: asset_name,
            amount: _amount,
            decimal: decimal,
            date: block.timestamp
        });

        donation_history[msg.sender].push(donation);
        donations.push(donation);
        donatur_list.push(msg.sender);
        if (!isAssetExists(_asset)) {
            asset_list.push(Asset({
                token: _asset,
                name: asset_name,
                decimal: decimal
            }));

            is_asset_exist[_asset] = true;
        }
        

        emit Donated(_asset, msg.sender, _amount);
    }

    // digunakan untuk menarik dana dan mencatat dana tersebut digunakan untuk apa
    function withdraw(address _asset, uint256 _amount, string memory _usage_description) public onlyAdmin {
        uint8 decimal = 18;
        string memory asset_name = "ether";

        if (_asset == address(0)) {
            require(payable(address(this)).balance >= _amount, "Dana ether donasi tidak cukup");
            payable(msg.sender).transfer(_amount);
        } else {
            IAssetERC20 asset = IAssetERC20(_asset);
            require(asset.balanceOf(address(this)) >= _amount, "Dana token donasi tidak cukup");
            decimal = asset.decimals();
            asset_name = asset.name();

            asset.transfer(payable(msg.sender), _amount);
        }

        Withdraw memory _withdraw = Withdraw({
            recipient: msg.sender,
            usage_description: _usage_description,
            asset: _asset,
            asset_name: asset_name,
            amount: _amount,
            decimal: decimal,
            date: block.timestamp
        });

        withdraw_history[msg.sender].push(_withdraw);
        withdraws.push(_withdraw);

        emit Withdrew(_asset, msg.sender, _amount, _usage_description);
    }
}

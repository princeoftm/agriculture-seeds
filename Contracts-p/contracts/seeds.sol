pragma solidity ^0.8.0;
import "./roles.sol";
import "./pools.sol";

contract harvests {
  address public owner;
  using Roles for Roles.Role;
  Roles.Role private _intermediary;
  Roles.Role private _burners;
  Roles.Role private _buyers;
  address token_address;

  modifier onlyOwner() {
    require(msg.sender == owner, "Not owner");
    _;
  }

  modifier onlyintermediary() {
    require(_intermediary.has(msg.sender));
    _;
  }

  modifier qualitycontrol() {
    require(_burners.has(msg.sender));
    _;
  }

  LiquidityPool public liquidp = new LiquidityPool(ERC20(token_address), ERC20(token_address));

  constructor(address _tokenAddress) {
    owner = msg.sender;
    token = IERC20(_tokenAddress);
    token_address = _tokenAddress;
  }
  function give_quality_report(uint id,string memory _name,string memory _quality) qualitycontrol() public{
    harvest storage harvest = harvests[id];
    harvest.qualitycheck_name=_name;
    harvest.qualitycheck_result=_quality;
  }

  function give_role_intermediary(address _address) onlyOwner() external {
    _intermediary.add(_address);
  }

  function give_role_quality(address _address) onlyOwner() external {
    _burners.add(_address);
  }

  struct harvest {
    uint256 id;
    address seller;
    string sellerName;
    string location;
    string harvestName;
    uint256 time;
    uint256 quantity;
    uint256 buyValue; // Consider renaming to `buyValue` for clarity
    string qualitycheck_name;
    string qualitycheck_result;
  }

  harvest[] public harvests;
  uint256 public nextId = 0;
  uint256 public price = 1 ether;
  IERC20 public token;

  function add_farmer(
    string memory _sellerName,
    string memory _location,
    string memory _harvestName,
    uint256 _quantity
  ) public  onlyOwner(){
    harvests.push(harvest(nextId, msg.sender, _sellerName, _location, _harvestName, block.timestamp, _quantity, 0,"",""));
    nextId++;
  }

  function get(string memory _harvestName) public view returns (uint256) {
    for (uint256 i = 0; i < harvests.length; i++) {
      if (keccak256(abi.encodePacked(harvests[i].harvestName)) == keccak256(abi.encodePacked(_harvestName))) {
        return i;
      }
    }
    revert("harvest not found.");
  }

  function getSellerAddress(uint256 _harvestId) public view returns (address) {
    require(_harvestId < harvests.length, "harvest does not exist.");
    return harvests[_harvestId].seller;
  }

  function buyHarvest(uint256 _harvestId, uint256 _quantity) public  onlyintermediary(){
    require(_harvestId < harvests.length, "harvest does not exist.");
    harvest storage harvest = harvests[_harvestId];
    require(harvest.quantity >= _quantity, "Not enough harvests available.");
    uint256 cost = price * _quantity;
    require(token.transferFrom(msg.sender, payable(address(liquidp)), cost), "Transfer failed.");
    harvest.quantity -= _quantity;
    harvest.buyValue += cost; 
  }

 function sellharvest(uint256 _harvestId, uint256 _quantity) public {
    require(_harvestId < harvests.length, "harvest does not exist.");
    harvest storage harvest = harvests[_harvestId];
    require(harvest.quantity >= _quantity, "Not enough harvest to sell.");

    uint256 sellingPrice = _quantity * price;

    harvest.quantity -= _quantity;

    require(token.transferFrom(msg.sender, payable(address(liquidp)), sellingPrice), "Transfer failed.");
}

}
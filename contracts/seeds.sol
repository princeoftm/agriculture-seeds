pragma solidity ^0.8.0;
import "./roles.sol";
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}



contract Seeds {
    address public owner;
    using Roles for Roles.Role;
    Roles.Role private _minters;
    Roles.Role private _burners;
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        
        _;
    }
    constructor( address _tokenAddress) {
        // Set the transaction sender as the owner of the contract.
        owner = msg.sender;
        token = IERC20(_tokenAddress);
    }
    function give_role(address _address){
        
    }
    struct Seed {
        uint256 id;
        address seller;
        string sellerName;
        string location;
        string seedName;
        uint256 time;
        uint256 quantity;
    }

    Seed[] public seeds;
    uint256 public nextId = 0;
    uint256 public price = 1 ether; // Price per seed in wei
    IERC20 public token;

    function add(string memory _sellerName, string memory _location, string memory _seedName, uint256 _quantity) public {
        seeds.push(Seed(nextId, msg.sender, _sellerName, _location, _seedName, block.timestamp, _quantity));
        nextId++;
    }

    function get(string memory _seedName) public view returns (uint256) {
        for (uint256 i = 0; i < seeds.length; i++) {
            if (keccak256(abi.encodePacked(seeds[i].seedName)) == keccak256(abi.encodePacked(_seedName))) {
                return i;
            }
        }
        revert("Seed not found.");
    }

    function buySeed(uint256 _seedId, uint256 _quantity) public {
        require(_seedId < seeds.length, "Seed does not exist.");
        Seed storage seed = seeds[_seedId];
        require(seed.quantity >= _quantity, "Not enough seeds available.");
        uint256 cost = price * _quantity;
        require(token.transferFrom(msg.sender, seed.seller, cost), "Transfer failed.");

        seed.quantity -= _quantity; // Update the quantity of seeds
    }
}

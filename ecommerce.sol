// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract Ecommerce{

    address public owner;
    mapping(address => User) public user;
    mapping(uint => Product) public products;
    // this struct stores the user's data
    struct User{
        string name;
        uint telephone;
        string deliveryAddress;
        string userType;
    }
    // this array is used to store the addresses of all the registered users
    address[] public userAddresses;

    struct Product{
        address seller;
        string productName;
        uint productPrice;
        uint productDiscount;
        string productDescription;
        uint productQuantity;
        bool deleted;
    }
    // this array stores the product Ids of all the products in the store
    uint[] public productIds;

    constructor() {
        owner = msg.sender;
    }

    // modifier to restrict access to only owners
    modifier onlyOwner{
        require(msg.sender == owner, "This function can only be performed by the owner");
        _;
    }

    // modifier to restrict access to only sellers
    modifier onlySeller{
        if(keccak256(abi.encodePacked(user[msg.sender].userType)) != keccak256(abi.encodePacked("seller"))){
            revert("Only sellers can create a new product");
        }
        _;
    }

    // this function is used to register users
    function userRegistration(string memory _name, uint _telephone, string memory _deliveryAddress, string memory _userType) public {
        user[msg.sender] = User(_name, _telephone, _deliveryAddress, _userType);
        userAddresses.push(msg.sender);
    }


    // this function can be used to create products in the ecommerce store
    function createProduct(string memory _productName, uint _productPrice, uint _productDiscount, string memory _productDescription, uint _productQuantity) public onlySeller {
        // generate random productIds and multiply them together to get a very random productId
        uint _productIdA = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  
        msg.sender))) % 1000;

        uint _productIdB = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  
        msg.sender))) % 50;

        uint _productIdC = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  
        msg.sender))) % 30;

        uint _productId = _productIdA * _productIdB + _productIdC;
        
        products[_productId] = Product(msg.sender, _productName, _productPrice, _productDiscount, _productDescription, _productQuantity, false);
        productIds.push(_productId);
    }

}

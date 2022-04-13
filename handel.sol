// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract Handel{

    address public owner;
    mapping(address => Manufacturer) public manufacturers;
    mapping(uint => Product) public products;
    
    struct Manufacturer{
        address manufacturerAddress;
        string manufacturerName;
        string manufacturerEmail;
        string manufacturerCategory;
        string manufacturerWebsite;
    }

    address[] public manufacturerAddresses;

    struct Product{
        uint handelNumber;
        address productManufacturer;
        address productOwner;
        string productName;
        string productColor;
        string productDescription;
        string manufacturingDate;
        bool isNFT;
    }

    uint[] public handelNumbers;

    constructor(){
        owner = msg.sender;
    }

    /**
    * @dev this modifier limits access to only registered manufacturers
    **/
    modifier onlyManufacturer{
        for(uint i=0; i<manufacturerAddresses.length; i++){
            if(keccak256(abi.encodePacked(msg.sender)) != keccak256(abi.encodePacked(manufacturerAddresses[i]))){
                revert("This address is not registered on Handel's Database");
            }
        }
        _;
    }

    /**
    * @dev this modifier limits access to only owner
    **/
    modifier onlyOwner{
        require(owner == msg.sender, "This function can only be called by the contract's owner");
        _;
    }

    /**
    * @dev register manufacturers with this function
    **/
    function registerManufacturer(address _manufacturerAddress, string memory _manufacturerName, string memory _manufacturerEmail, string memory _manufacturerCategory, string memory _manufacturerWebsite) public onlyOwner{
        manufacturers[_manufacturerAddress] = Manufacturer(_manufacturerAddress, _manufacturerName, _manufacturerEmail, _manufacturerCategory, _manufacturerWebsite);
        manufacturerAddresses.push(_manufacturerAddress);
    }

    /**
    * @dev add products to mapping with this function
    **/
    function addProduct(string memory _productName, string memory _productColor, string memory _productDesc, string memory _manufacturingDate, uint _quantity, bool _isNFT) public onlyManufacturer{
        
        for(uint i=0; i<_quantity; i++){
            // generate unique numbers and add them together to create a more randomized handel number
            uint _handelA = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  
            msg.sender))) % 1000;

            uint _handelB = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  
            msg.sender))) % 50;

            uint _handelC = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  
            msg.sender))) % 30;

            uint _handelNumber = _handelA * _handelB + _handelC + i;


            products[_handelNumber] = Product(_handelNumber, msg.sender, msg.sender, _productName, _productColor, _productDesc, _manufacturingDate, _isNFT);
            handelNumbers.push(_handelNumber);
        }
    }

    /**
    * @dev transfer product ownership with this product
    **/
    function transferProductOwnership(address _newProductOwner, uint _productHandelNumber) public {

        require(keccak256(abi.encodePacked(msg.sender)) == keccak256(abi.encodePacked(products[_productHandelNumber].productOwner)), "You can't transfer ownership of a product you do not own!");
        products[_productHandelNumber].productOwner = _newProductOwner;

    }

    // get the length of the handelNumbers array, to iterate through it
    function getHandelNumbersLength() public view returns(uint) {
        return handelNumbers.length;
    }
    
}

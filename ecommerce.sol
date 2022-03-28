// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract Ecommerce{

    address public owner;
    mapping(address => User) public user;
    mapping(uint => Product) public products;
    mapping(uint => Transactions) public transactions;
    mapping(uint => Disputes) public disputes;

    // this struct stores the user's data
    struct User{
        string name;
        uint telephone;
        string deliveryAddress;
        string userType;
    }
    address[] public userAddresses;

    // this struct stores seller's products
    struct Product{
        address seller;
        string productName;
        uint productPrice;
        uint productDiscount;
        string productCategory;
        string productDescription;
        string productImage;
        uint productQuantity;
        bool deleted;
    }
    uint[] public productIds;

    // this struct stores the store transactions
    struct Transactions{
        address payable buyerAddress;
        address payable sellerAddress;
        uint transactionAmount;
        bool dispute;
        bool completed;
    }
    uint[] public transactionIds;

    // this struct stores dispute informations
    struct Disputes{
        uint transactionId;
        string body;
        string image; 
    }
    uint[] public disputeIds;

    constructor(string memory _name, uint _telephone, string memory _deliveryAddress) {
        owner = msg.sender;
        user[msg.sender] = User(_name, _telephone, _deliveryAddress, 'owner');
        userAddresses.push(msg.sender);
    }

    // modifier to restrict access to only registered buyers
    modifier onlyBuyers{
        if(keccak256(abi.encodePacked(user[msg.sender].userType)) != keccak256(abi.encodePacked("user"))){
            revert("Only users can carry out this function");
        }
        _;
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
        for (uint i; i < userAddresses.length; i++) {
            if (userAddresses[i] == msg.sender) {
                // corresponding user found, revert function
                revert("You have already been registered!");
            }
        }
        
        user[msg.sender] = User(_name, _telephone, _deliveryAddress, _userType);
        userAddresses.push(msg.sender);
    }


    // this function can be used to create products in the ecommerce store
    function createProduct(string memory _productName, uint _productPrice, uint _productDiscount, string memory _productCategory, string memory _productDescription, string memory _productImage, uint _productQuantity) public onlySeller {
        // generate random productIds and multiply them together to get a very random productId
        uint _productIdA = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  
        msg.sender))) % 1000;

        uint _productIdB = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  
        msg.sender))) % 50;

        uint _productIdC = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  
        msg.sender))) % 30;

        uint _productId = _productIdA * _productIdB + _productIdC;
        
        products[_productId] = Product(msg.sender, _productName, _productPrice, _productDiscount, _productCategory, _productDescription, _productImage, _productQuantity, false);
        productIds.push(_productId);
    }

    // this function can be used for deleting products in the store
    function deleteProduct(uint _productID) public onlySeller {
        products[_productID].deleted = true;
    }

    // this function can be used to purchase products in the cart and store the money in the escrow
    function purchaseProduct(address payable _sellerAddress) public payable onlyBuyers {

        uint _transactionId = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  
        msg.sender))) % 1000;

        transactions[_transactionId] = Transactions(payable(msg.sender), _sellerAddress, msg.value, false, false);
        transactionIds.push(_transactionId);
    }

    // this function is used to confirm that product is received and seller is paid
    function confirmReceived(uint _transactionId) public onlyBuyers {
        require(transactions[_transactionId].completed == false, "You cannot carry out this action, as trade has been completed!");
        require(msg.sender == transactions[_transactionId].buyerAddress, "This transaction can only be called by the buyer");
        transactions[_transactionId].sellerAddress.transfer(transactions[_transactionId].transactionAmount);
        
        transactions[_transactionId] = Transactions(payable(msg.sender), transactions[_transactionId].sellerAddress, transactions[_transactionId].transactionAmount, false, true);
    }

    // this function is used to open a dispute
    function openDispute(uint _disputeTransactionId, string memory _body, string memory _image) public onlyBuyers {
        uint _disputeId = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  
        msg.sender))) % 1000;

        disputes[_disputeId] = Disputes(_disputeTransactionId, _body, _image);
        disputeIds.push(_disputeId);
    }
    
    // this function is used to force-pay seller after dispute
    function paySeller(uint _transactionId) public onlyOwner {
        require(transactions[_transactionId].completed == false, "You cannot carry out this action, as trade has been completed!");
        transactions[_transactionId].sellerAddress.transfer(transactions[_transactionId].transactionAmount);
        
        transactions[_transactionId] = Transactions( transactions[_transactionId].buyerAddress, transactions[_transactionId].sellerAddress, transactions[_transactionId].transactionAmount, true, true);
    }

    // this function is used to force-pay buyer after dispute
    function payBuyer(uint _transactionId) public onlyOwner {
        require(transactions[_transactionId].completed == false, "You cannot carry out this action, as trade has been completed!");
        transactions[_transactionId].buyerAddress.transfer(transactions[_transactionId].transactionAmount);
        
        transactions[_transactionId] = Transactions( transactions[_transactionId].buyerAddress, transactions[_transactionId].sellerAddress, transactions[_transactionId].transactionAmount, true, true);
    }

}

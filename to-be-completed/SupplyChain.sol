//SPDX-License-Identifier: MIT

/*
    This exercise has been updated to use Solidity version 0.5
    Breaking changes from 0.4 to 0.5 can be found here: 
    https://solidity.readthedocs.io/en/v0.5.0/050-breaking-changes.html
*/

pragma solidity ^0.8.10;

contract SupplyChain {
    /* set owner */
    address owner;

    /* Add a variable called skuCount to track the most recent sku # */
    uint256 skuCount;

    /* Add a line that creates a public mapping that maps the SKU (a number) to an Item.
     Call this mappings items
  */
    mapping(uint256 => Item) items;

    /* Add a line that creates an enum called State. This should have 4 states
    ForSale
    Sold
    Shipped
    Received
    (declaring them in this order is important for testing)
  */
    enum State {
        ForSale,
        Sold,
        Shipped,
        Received
    }

    /* Create a struct named Item.
    Here, add a name, sku, price, state, seller, and buyer
    We've left you to figure out what the appropriate types are,
    if you need help you can ask around :)
    Be sure to add "payable" to addresses that will be handling value transfer
  */
    struct Item {
        string name;
        uint256 sku;
        uint256 price;
        State state;
        address payable seller;
        address payable buyer;
    }

    /* Create 4 events with the same name as each possible State (see above)
    Prefix each event with "Log" for clarity, so the forSale event will be called "LogForSale"
    Each event should accept one argument, the sku */
    event LogForSale(uint256 sku);
    event LogSold(uint256 sku);
    event LogShipped(uint256 sku);
    event LogReceived(uint256 sku);

    /* Create a modifer that checks if the msg.sender is the owner of the contract */
    modifier onlyOwner(address _address) {
        require(msg.sender == owner);
        _;
    }

    /* Create a modifer that checks if the msg.sender is the Seller of the item */
    modifier verifySeller(address _address) {
        require(msg.sender == _address);
        _;
    }
     /* Create a modifer that checks if the msg.sender is the Buyer of the item */
    modifier verifyBuyer(address _address) {
        require(msg.sender == _address);
        _;
    }

    /* Create a modifier that checks if enough value is sent */
    modifier paidEnough(uint256 _price) {
        require(msg.value >= _price);
        _;
    }

    modifier checkValue(uint256 _sku) {
        //refund them after pay for item (why it is before, _ checks for logic before func)
        _;
        uint256 _price = items[_sku].price;
        uint256 amountToRefund = msg.value - _price;
        items[_sku].buyer.transfer(amountToRefund);
    }

    /* For each of the following modifiers, use what you learned about modifiers
   to give them functionality. For example, the forSale modifier should require
   that the item with the given sku has the state ForSale. 
   Note that the uninitialized Item.State is 0, which is also the index of the ForSale value,
   so checking that Item.State == ForSale is not sufficient to check that an Item is for sale.
   Hint: What item properties will be non-zero when an Item has been added?
   */
    modifier forSale(uint256 _sku) {
        require(items[_sku].state == State.ForSale, "Item is not for sale");
        _;
    }
    modifier sold(uint256 _sku) {
        require(items[_sku].state == State.Sold, "Item is not sold");
        _;
    }
    modifier shipped(uint256 _sku) {
        require(items[_sku].state == State.Shipped, "Item is not shipped");
        _;
    }
    modifier received(uint256 _sku) {
        require(items[_sku].state == State.Received, "Item is not received");
        _;
    }

    constructor() {
        /* Here, set the owner as the person who instantiated the contract
       and set your skuCount to 0. */
        owner = msg.sender;
        skuCount = 0;
    }

    /// @notice Add an item for sale to the contract
    /// @dev adds item to items mapping, emits the appropriate event
    /// @param _itemName The name of the item
    /// @param _itemPrice The price of the item
    /// @return A boolean that is true if the function call was successful,i.e. item is added for sale
    function addItem(
        string memory _itemName,
        uint256 _itemPrice
    ) public returns (bool) {
        emit LogForSale(skuCount);
        items[skuCount] = Item({
            name: _itemName,
            sku: skuCount,
            price: _itemPrice,
            state: State.ForSale,
            seller: payable(msg.sender),
            buyer: payable(address(0))
        });
        skuCount++;
        return true;
    }

    /* Add a keyword so the function can be paid. This function should transfer money
    to the seller, set the buyer as the person who called this transaction, and set the state
    to Sold. Be careful, this function should use 3 modifiers to check if the item is for sale,
    if the buyer paid enough, and check the value after the function is called to make sure the buyer is
    refunded any excess ether sent. Remember to call the event associated with this function!*/

    /// @notice Buy an item by sending ether
    /// @dev Transfers money to the seller, sets the buyer as the person who called this transaction, and sets the state to Sold,if the item is for sale, if the buyer paid enough, and check the value after the function is called to make sure the buyer is refunded any excess ether sent.
    /// @param sku sku of the item to be bought

    function buyItem(
        uint256 sku
    ) public payable forSale(sku) paidEnough(items[sku].price) checkValue(sku) {
        items[sku].seller.transfer(items[sku].price);
        items[sku].buyer = payable(msg.sender);
        items[sku].state = State.Sold;
        emit LogSold(sku);
    }

    /* Add 2 modifiers to check if the item is sold already, and that the person calling this function
  is the seller. Change the state of the item to shipped. Remember to call the event associated with this function!*/

    /// @notice Ship an item
    /// @dev Changes the state of the item to shipped, if the item is sold already, and that the person calling this function is the seller.
    /// @param sku sku of the item to be shipped
    function shipItem(
        uint256 sku
    ) public sold(sku) verifySeller(items[sku].seller) {
        items[sku].state = State.Shipped;
        emit LogShipped(sku);
    }

    /* Add 2 modifiers to check if the item is shipped already, and that the person calling this function
  is the buyer. Change the state of the item to received. Remember to call the event associated with this function!*/
  
    /// @notice Receive an item
    /// @dev Changes the state of the item to received, if the item is shipped already, and that the person calling this function is the buyer.
    /// @param sku sku of the item to be received
    function receiveItem(uint256 sku) public shipped(sku) verifyBuyer(items[sku].buyer) {
        items[sku].state = State.Received;
        emit LogReceived(sku);
    }

    /* We have these functions completed so we can run tests, just ignore it :) */
    function fetchItem(
        uint256 _sku
    )
        public
        view
        returns (
            string memory name,
            uint256 sku,
            uint256 price,
            uint256 state,
            address seller,
            address buyer
        )
    {
        name = items[_sku].name;
        sku = items[_sku].sku;
        price = items[_sku].price;
        state = uint(items[_sku].state);
        seller = items[_sku].seller;
        buyer = items[_sku].buyer;
        return (name, sku, price, state, seller, buyer);
    }
}

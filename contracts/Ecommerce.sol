// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Ecommerce {
    struct Product {
        address owner;
        string name;
        string description;
        uint256 price;
        uint256 stocks;
        string image;
        address[] buyers;
        uint256[] amountBought;
    }

    mapping(uint256 => Product) public products;

    uint256 public numberOfProducts = 0;

    function createProduct(address _owner, string memory _name, string memory _description, uint256 _price, uint256 _stocks, string memory _image) public returns (uint256) {
        Product storage product = products[numberOfProducts];

        // Is everythin okay?
        require(product.stocks <= 0, "Product out of stock");

        product.owner = _owner;
        product.name = _name;
        product.description = _description;
        product.price = _price;
        product.stocks = _stocks;
        product.image = _image;

        numberOfProducts++;

        return numberOfProducts - 1;
    }

    function buyProduct(uint256 _productId) public payable {
        Product storage product = products[_productId];

        uint256 amount = product.price;

        product.buyers.push(msg.sender);
        product.amountBought.push(amount);

        (bool sent,) = payable(product.owner).call{value: amount}("");
        if (sent) {
            product.stocks = product.stocks - 1;
        }
    }

    function getBuyers(uint256 _productId) view public returns(address[] memory, uint256[] memory) {
        return (products[_productId].buyers, products[_productId].amountBought);
    }

    function getProducts() public view returns(Product[] memory) {
        Product[] memory allProducts = new Product[](numberOfProducts);

        for(uint i = 0; i < numberOfProducts; i++) {
            Product storage item = products[i];

            allProducts[i] = item;
        }

        return allProducts;
    }

    function getProduct(uint256 _productId) view public returns(Product memory) {
        return products[_productId];
    }
}
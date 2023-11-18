// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract SupplementTracker {
    struct SupplementInfo {
        string name;
        string manufacturer;
        uint proteinContent;
        uint carbs;
        uint fats;
        string expiryDate;
    }

    mapping(uint => SupplementInfo) public supplements;
    uint public productCount = 0;

    function addSupplement(string memory _name, string memory _manufacturer, uint _proteinContent, uint _carbs, uint _fats, string memory _expiryDate) public returns (SupplementInfo memory) {
        supplements[productCount] = SupplementInfo(_name, _manufacturer, _proteinContent, _carbs, _fats, _expiryDate);
        productCount++;
        return supplements[productCount];
    }

    function getSupplementInfo(uint _productId) public view returns (SupplementInfo memory) {
        require(_productId < productCount, "Product not found.");
        return supplements[_productId];
    }
}
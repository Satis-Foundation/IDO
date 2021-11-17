// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract satisWhiteListAddress {
    address public owner;
    mapping (address => uint256) whiteList;
    event whiteListed(address acceptedAddress);
    event changeOwnership(address newOwner);

    modifier isOwner() {
        require (msg.sender == owner, "Not an admin");
        _;
    }


    /**
     * @dev Sets the value for {owner}.
     */
    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Transfer the ownership of this contract.
     */
    function transferOwnership(address _newOwner) public isOwner {
        owner = _newOwner;
        emit changeOwnership(owner);
    }

    /**
     * @dev Add address to whitelist by contract owner.
     */
    function addWhiteList(address _acceptedAddress) external isOwner {
        whiteList[_acceptedAddress] = 1;
        emit whiteListed(_acceptedAddress);
    }

    /**
     * @dev Use view function to check if an address is on whitelist.
     */
    function viewWhiteList(address _testAddress) view external returns(uint256 _whiteListBoolean) {
        _whiteListBoolean = whiteList[_testAddress];
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract abstractWhiteListAddress {

    function transferOwnership(address _newOwner) public isOwner returns(address _newAddress);

    function addWhiteList(address _acceptedAddress) external isOwner returns(uint256 _whiteListBoolean);

    function viewWhiteList(address _testAddress) view external returns(uint256 _whiteListBoolean);

}
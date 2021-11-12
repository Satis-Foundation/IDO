// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Learn more about the ERC20 implementation 
// on OpenZeppelin docs: https://docs.openzeppelin.com/contracts/4.x/erc20
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";



contract fakeUSDC is ERC20 {

    address public owner;

    event mintToken(address receiverAddress, uint tokenAmount);
    event burnToken(address burnedFrom, uint tokenAmount);

    modifier isOwner() {
        require (msg.sender == owner, "Not an admin");
        _;
    }


    constructor() ERC20("fakeUSDC", "FUS") {
        owner = msg.sender;
        _mint(msg.sender, 1000000 * 10 ** 18);
    }

    function minting(address _recipient, uint256 _amount) external isOwner {
        _mint(_recipient, _amount * 10 ** 18);
        emit mintToken(_recipient, _amount);
    }

    function burning(uint256 _amount) external {
        _burn(msg.sender, _amount);
        emit burnToken(msg.sender, _amount);
    }
}

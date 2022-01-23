/**
 * @type import('hardhat/config').HardhatUserConfig
 */
require('@nomiclabs/hardhat-waffle');
require("hardhat-gas-reporter");

module.exports = {
  
  solidity: "0.8.0",

  networks: {
    "optimistic-kovan": {
      url: 'https://kovan.optimism.io',
      accounts: ['0x3cdb6a0cf7b1883b96e7c57896c7812775cbca6f51fbf0b52073db05fca16875'],
      gasPrice: 15000000,
      ovm: true,
    }
  }

};

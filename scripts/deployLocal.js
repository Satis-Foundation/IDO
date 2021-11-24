const { ethers } = require("hardhat");

async function main() {
    
    const [deployer] = await ethers.getSigners();
    console.log('Deploying contracts with account: ', deployer.address);

    const balance = await deployer.getBalance();
    console.log('Account balance = ', balance.toString());

    const fakeUSDC = await ethers.getContractFactory('fakeUSDC');
    const contractFakeUSDC = await fakeUSDC.deploy();
    console.log('Local USDC address: ', contractFakeUSDC.address);

    const satisToken = await ethers.getContractFactory('satisToken');
    const contractSatisToken = await satisToken.deploy();
    console.log('Local Satis Token address: ', contractSatisToken.address);

    totalTokenSupply = ;
    const ido = await ethers.getContractFactory('satisIDO');
    const contractIDO = await ido.deploy(contractFakeUSDC.address, contractSatisToken.address, totalTokenSupply);
    console.log('Local IDO contract address: ', contractIDO.address);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
async function main() {
    
    const [deployer] = await ethers.getSigners();
    console.log('Deploying contracts with account: ', deployer.address);

    const balance = await deployer.getBalance();
    console.log('Account balance = ', balance.toString());

    const moniesPull = await ethers.getContractFactory('moniesPull');
    const contractMoniesPull = await moniesPull.deploy();
    console.log('Contract address: ', contractMoniesPull.address);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
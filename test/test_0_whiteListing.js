const { expect } = require("chai");
const { ethers } = require("hardhat");
const { getContractAddress } = require('@ethersproject/address');



function delay(time) {
    console.log("Wait " + time + "ms")
    return new Promise(resolve => setTimeout(resolve, time));
}

describe ("Test add whitelist", function() {
    it ("Add whitelist", async function() {

        const signers = await ethers.getSigners();

        

        const fakeUSDCOwner = signers[0];
        fakeUSDCOwnerAddress = await fakeUSDCOwner.getAddress();
        console.log("Fake USDC Owner: " + fakeUSDCOwnerAddress);

        const fakeUSDCContract = await ethers.getContractFactory("fakeUSDC", fakeUSDCOwner);
        const usdc = await fakeUSDCContract.deploy();
        console.log("Fake USDC contract deployed");

        const fakeUSDCAddress = usdc.address;
        console.log("Fake USDC address: " + fakeUSDCAddress);



        const satisTokenOwner = signers[1];
        satisTokenOwnerAddress = await satisTokenOwner.getAddress();
        console.log("Satis Token Owner: " + satisTokenOwnerAddress);

        const satisTokenContract = await ethers.getContractFactory("satisToken", satisTokenOwner);
        const satToken = await satisTokenContract.deploy();
        console.log("Satis Token contract deployed");

        const satisTokenAddress = satToken.address;
        console.log("Satis Token address: "+ satisTokenAddress);



        const whiteListOwner = signers[1];
        whiteListOwnerAddress = await whiteListOwner.getAddress();
        console.log("Whitelist Owner: " + whiteListOwnerAddress);

        const whiteListContract = await ethers.getContractFactory("satisWhiteListAddress", whiteListOwner);
        const whiteList = await whiteListContract.deploy();
        console.log("Whitelist contract deployed");

        const whiteListContractAddress = whiteList.address;
        console.log("Whitelist contract address: " + whiteListContractAddress);



        const idoContractOwner = signers[1];
        idoContractOwnerAddress = await idoContractOwner.getAddress();
        console.log("IDO contract Owner: " + idoContractOwnerAddress);

        let sumSatisToken = 500000;
        const idoContract = await ethers.getContractFactory("satisIDORemixWhitelist", idoContractOwner);
        const ido = await idoContract.deploy(fakeUSDCAddress,satisTokenAddress,sumSatisToken,10);
        console.log("IDO deployed");

        const idoAddress = ido.address;
        await satToken.connect(satisTokenOwner).transfer(idoAddress,sumSatisToken);
        console.log("IDO address: " + idoAddress);



        //Initialize and approve fake USDC
        const clientX = signers[2];
        const clientX_address = await clientX.getAddress();
        const clientY = signers[3];
        const clientY_address = await clientY.getAddress();
        const clientZ = signers[4];
        const clientZ_address = await clientZ.getAddress();
        const clientA = signers[5];
        const clientA_address = await clientA.getAddress();

        await usdc.connect(fakeUSDCOwner).transfer(idoContractOwnerAddress,5000);
        await usdc.connect(fakeUSDCOwner).transfer(clientX_address,1000);
        await usdc.connect(fakeUSDCOwner).transfer(clientY_address,1000);
        await usdc.connect(fakeUSDCOwner).transfer(clientZ_address,1000);
        await usdc.connect(clientX).approve(idoAddress,1000);
        await usdc.connect(clientY).approve(idoAddress,1000);
        await usdc.connect(clientZ).approve(idoAddress,1000);

        //Whitelist clients
        await ido.connect(idoContractOwner).addUserWhiteList([clientX_address,clientY_address,clientZ_address]);
        const testBool = await ido.connect(idoContractOwner).viewUserWhiteList(clientX_address);
        expect (testBool).to.equal(1);
        const testBool2 = await ido.connect(clientX).viewUserWhiteList(clientA_address);
        expect (testBool2).to.equal(0);

        //Sign the verification signature
        let rawMessage = "This is an EOA";
        let message = ethers.utils.solidityKeccak256(['string'],[rawMessage]);
        let messageBytes = ethers.utils.arrayify(message);
        let contractReceiveHash = ethers.utils.hashMessage(messageBytes);
        let randomHash = '0x0000000000000000000000000000000000000000000000000000000000000000'
        let randomSignature = '0x0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
        signatureX = await clientX.signMessage(messageBytes);
        signatureY = await clientY.signMessage(messageBytes);
        signatureZ = await clientZ.signMessage(messageBytes);

        /*
        let sumSatisToken = 500000;
        await ido.connect(idoContractOwner).testInitiation(fakeUSDCAddress,satisTokenAddress,sumSatisToken);
        await satToken.connect(satisTokenOwner).transfer(idoAddress,sumSatisToken);
        */

        console.log("Initialization completed");



        // Start auction
        await ido.connect(idoContractOwner).startIDO();
        console.log("Auction started");
        // Wait for 1 seconds
        await delay(1000);
        await usdc.connect(fakeUSDCOwner).transfer(idoContractOwnerAddress,10);
        
        await ido.connect(clientX).depositAssets(500,contractReceiveHash,signatureX);
        usdcValueX = await ido.connect(clientX).viewPersonalAssets();
        expect (usdcValueX).to.equal(500);
        usdcTotal = await ido.connect(clientX).viewTotalAssetsInContract();
        expect (usdcTotal).to.equal(500);
        let whiteListBoolean = await ido.connect(clientX).viewEOAWhitelist(clientX_address);
        console.log("Whitelist status: " + whiteListBoolean);
        //console.log(contractReceiveHash);
        //console.log(signatureX);

        await ido.connect(clientX).depositAssets(300,randomHash,randomSignature);
        usdcValueX = await ido.connect(clientX).viewPersonalAssets();
        expect (usdcValueX).to.equal(800);
        usdcTotal = await ido.connect(clientX).viewTotalAssetsInContract();
        expect (usdcTotal).to.equal(800);
        whiteListBoolean = await ido.connect(clientX).viewEOAWhitelist(clientX_address);
        console.log("Whitelist status " + whiteListBoolean);

    })
}) 
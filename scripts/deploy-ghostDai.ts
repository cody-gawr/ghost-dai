import { ethers } from "hardhat";
async function main() {

  const qiStablecoinFactory = await ethers.getContractFactory("QiStablecoin");

  const vault = await ethers.getContractFactory("VaultNFT");

  let vaultContract = await vault.deploy();

  // If we had constructor arguments, they would be passed into deploy()
  let qiStablecoin = await qiStablecoinFactory.deploy(
            "0x656c0544eF4C98A6a98491833A89204Abb045d6b", // mainnet 0xAB594600376Ec9fD91F8e885dADF0CE036862dE0
            150,                                          // mumbai 0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada
            'ghostDai',
            'gDai',
            vaultContract.address
            );
  // The address the Contract WILL have once mined
  console.log(qiStablecoin.address);
    // The address the Contract WILL have once mined
  console.log(vaultContract.address);
  // The transaction that was sent to the network to deploy the Contract
  console.log(qiStablecoin.deployTransaction.hash);
  // The contract is NOT deployed yet; we must wait until it is mined
  await qiStablecoin.deployed();

  await vaultContract.setAdmin(qiStablecoin.address);

  const firstOwner = await qiStablecoin.owner();

  console.log("owner", firstOwner);

  console.log("transferring ownership to the Ledger wallet.");

  await qiStablecoin.transferOwnership("0x4Ba09bFE1ff1AACeAE099E7b8302B5c035F8381F")

  const secondOwner = await qiStablecoin.owner(); 
  console.log(secondOwner);
  // mainnet v1 mimatic = 0xa3Fa99A148fA48D14Ed51d610c367C61876997F1
  // mainnet MMVT = 0x6AF1d9376a7060488558cfB443939eD67Bb9b48d
  // then set the oracle for price
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
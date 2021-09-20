import { ethers } from "hardhat";
async function main() {

  const ghoulx = await ethers.getContractFactory("ghoulx");


  let ghoulx = await ghoulx.deploy();

 
  // The address the Contract WILL have once mined
  console.log(ghoulx.address);
    // The address the Contract WILL have once mined
 
  console.log(ghoulx.deployTransaction.hash);
  // The contract is NOT deployed yet; we must wait until it is mined
  await ghoulx.deployed();

  
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
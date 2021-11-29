import { ethers } from "hardhat";
import { PriceConsumer } from "../typechain/PriceConsumer";

async function main() {
    const priceConsumerFactory = await ethers.getContractFactory("PriceConsumer");
    const priceConsumer = (await priceConsumerFactory.deploy()) as PriceConsumer;
    await priceConsumer.deployed();
    console.log(`PriceConsumer contract is deployed at ${priceConsumer.address} and verified`);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
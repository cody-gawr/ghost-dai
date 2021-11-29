import {
    network,
    ethers
} from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { MockV3Aggregator } from "../../typechain/MockV3Aggregator";

export const INITIAL_PRICE_FEED_VALUE = 2000000000000000000000;
export const DECIMALS = 18;

export const NON_FORKED_LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["hardhat", "development", "ganache"]
export const LOCAL_BLOCKCHAIN_ENVIRONMENTS =
    NON_FORKED_LOCAL_BLOCKCHAIN_ENVIRONMENTS.concat([
        "mainnet-fork",
        "binance-fork",
        "matic-fork",
    ]);

export async function getAccount(index?: number, address?: string): Promise<SignerWithAddress> {
    const accounts = await ethers.getSigners();
    if (index) {
        return accounts[index];
    }
    if (network.name in LOCAL_BLOCKCHAIN_ENVIRONMENTS) {
        return accounts[0];
    }
    if (address) {
        return await ethers.getSigner(address);
    }
    
    return ethers.getSigner(String(process.env.PUBLIC_KEY));
}

export function getContract() {

}
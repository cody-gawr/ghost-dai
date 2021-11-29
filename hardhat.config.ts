require('dotenv').config()

import { HardhatUserConfig } from "hardhat/types";
import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-etherscan";
import "hardhat-typechain";

const config: HardhatUserConfig = {
  defaultNetwork: "hardhat",
  solidity: {
    compilers: [
      {
        version: "0.5.0",
        settings: {
          optimizer: {
            enabled: true,
            runs: 1000
          }
        }
      },
      {
        version: "0.5.5",
        settings: {
          optimizer: {
            enabled: true,
            runs: 1000
          }
        }
      },
      {
        version: "0.5.16",
        settings: {
          optimizer: {
            enabled: true,
            runs: 1000
          }
        }
      },
      {
        version: "0.6.12",
        settings: {
          optimizer: {
            enabled: true,
            runs: 1000
          }
        }
      },
      {
        version: "0.7.6",
        settings: {
          optimizer: {
            enabled: true,
            runs: 1000
          }
        }
      },
      {
        version: "0.8.3",
        settings: {
          optimizer: {
            enabled: true,
            runs: 1000
          }
        }
      }
    ],
  },
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545"
    },
    hardhat: {},
    kovan: {
      url: "https://kovan.infura.io/v3/3b5a7e5210714ab9987bed6f373848a3",
      accounts: [String(process.env.PRIVATE_KEY)],
    },
    mainnet: {
      url: "https://mainnet.infura.io/v3/3b5a7e5210714ab9987bed6f373848a3",
      accounts: [String(process.env.PRIVATE_KEY)],
    },
    bsc_testnet: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545",
      chainId: 97,
      gasPrice: 20000000000,
      accounts: [String(process.env.PRIVATE_KEY)]
    },
    bsc_mainnet: {
      url: "https://bsc-dataseed.binance.org/",
      chainId: 56,
      gasPrice: 20000000000,
      accounts: [String(process.env.PRIVATE_KEY)]
    }
  },
  etherscan: {
    apiKey: "UFCG3BXXNR58RSNCSFSRYWTNNTG3YW5G7B" //0x9441e2FCD9D18f2a73512B882Da91205E67592ac
  },
};
export default config;
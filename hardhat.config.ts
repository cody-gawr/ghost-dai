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
        version: "0.4.0",
        settings: {
          optimizer: {
            enabled: true,
            runs: 1000
          }
        }
      },
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
    hardhat: {},
    kovan: {
      url: "https://kovan.infura.io/v3/3b5a7e5210714ab9987bed6f373848a3",
      accounts: [String(process.env.PRIVATE_KEY)],
    },
    mainnet: {
      url: "https://mainnet.infura.io/v3/3b5a7e5210714ab9987bed6f373848a3",
      accounts: [String(process.env.PRIVATE_KEY)],
    },
  },
  etherscan: {
    
    apiKey: "UFCG3BXXNR58RSNCSFSRYWTNNTG3YW5G7B"
  }
};
export default config;
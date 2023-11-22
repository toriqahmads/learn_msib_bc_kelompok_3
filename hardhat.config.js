require("@nomicfoundation/hardhat-toolbox");
// require('hardhat-ethernal');

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  hardhat: {
    url: "http://localhost:8545",
    accounts: ["0x4d0d424fea53f5c431eb1d4220216063bef9cd4ddb9dedbf3b3686223c6e9a7b"]
  },
  mumbai_testnet: {
    url: "https://rpc-mumbai.maticvigil.com",
    accounts: ["0x4d0d424fea53f5c431eb1d4220216063bef9cd4ddb9dedbf3b3686223c6e9a7b"]
  },
  solidity: {
    version: "0.8.19",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  // ethernal: {
  //   apiToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaXJlYmFzZVVzZXJJZCI6IktWbW1sblpqY1FVVTRwRk4ydG1pNU44ck9lRjIiLCJhcGlLZXkiOiJQVEpIOFg0LVNTQTQ1RzUtUUNGNTVOUC0yOU05Ukc2XHUwMDAxIiwiaWF0IjoxNjk2NjU0OTk0fQ.bGyTHNK6jJFBfrlr8U6IIIRcoIKa1AWfvnhPFUOaCoE"
  // }
};

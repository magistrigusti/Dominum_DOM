require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
    solidity: "0.8.20",
    networks: {
        hardhat: {
            chainId: 31337, // Локальная сеть HardHat
        },
    },
};

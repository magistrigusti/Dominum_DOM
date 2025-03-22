const { ethers } = require("hardhat");
//Deploying contract with account: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
// Dominum deployed at: 0x610178dA211FEF7D417bC0e6FeD39F05609AD788

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contract with account:", deployer.address);

  const inflationWallet = deployer.address;
  const taxWallet = deployer.address;

  const Dominum = await ethers.getContractFactory("Dominum");
  const dominum = await Dominum.deploy(inflationWallet, taxWallet);

  await dominum.waitForDeployment(); 
  console.log("✅ Dominum deployed at:", await dominum.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// scripts/2.upgradeV2.ts
import { ethers } from "hardhat";
import { upgrades } from "hardhat";

const proxyAddress = '0x9fe46736679d2d9a65f0992f2272de9f3c7fa6e0'
// const proxyAddress = '0x1CD0c84b7C7C1350d203677Bb22037A92Cc7e268'

async function main() {
  console.log(proxyAddress," original Swapper(proxy) address")
  const SwapperV2 = await ethers.getContractFactory("SimpleERC20Swapper")
  console.log("upgrade to SwapperV2...")
  const swappperV2 = await upgrades.upgradeProxy(proxyAddress, SwapperV2)
  console.log(swappperV2.address," SwapperV2 address")  
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})

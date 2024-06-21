// scripts/1.deploy_box.ts
import { ethers } from "hardhat"
import { upgrades } from "hardhat"

async function main() {
  const Swapper = await ethers.getContractFactory("SimpleERC20Swapper")
  console.log("Deploying Swapper...")
  const swpper = await upgrades.deployProxy(Swapper, ["0x425141165d3DE9FEC831896C016617a52363b687"], { initializer: 'initialize' })
  console.log(swpper.address," Swapper(proxy) address") 
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})

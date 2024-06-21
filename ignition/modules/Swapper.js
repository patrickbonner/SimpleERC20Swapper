const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

const TokenModule = buildModule("SwapperModule", (m) => {
  const token = m.contract("SimpleERC20Swapper");

  return { token };
});

module.exports = TokenModule;
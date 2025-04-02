import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("HarvestsModule", (m) => {
  const token = m.contract("MyToken", ["MyToken", "MTK", 18, 1000000]);

  const harvests = m.contract("harvests", [token]);

  return { token, harvests };
});

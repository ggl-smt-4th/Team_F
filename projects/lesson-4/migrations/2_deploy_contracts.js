var SafeMathLib = artifacts.require("../contracts/SafeMath.sol");
var Payroll = artifacts.require("../contracts/Payroll.sol");

module.exports = function(deployer) {
  deployer.deploy(SafeMathLib);
  deployer.link(SafeMathLib, Payroll);
  deployer.deploy(Payroll);
};


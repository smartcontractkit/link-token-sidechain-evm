const LinkToken = artifacts.require("LinkTokenOnMatic");

module.exports = function (deployer, network, accounts) {
  const childChainManager = accounts[0];
  deployer.deploy(LinkToken, childChainManager);
};

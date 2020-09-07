const axios = require("axios");
const LinkToken = artifacts.require("LinkTokenOnMatic");

const MATIC_NETWORK_STATIC_VERSION = "v2.4.3";
const MATIC_NETWORK_NETWORK = "testnet/mumbai";

const getConfigURL = (version, network) =>
  `https://raw.githubusercontent.com/maticnetwork/static/${version}/network/${network}/index.json`;

module.exports = async (deployer, network, accounts) => {
  const configURL = getConfigURL(
    process.env.MATIC_NETWORK_STATIC_VERSION || MATIC_NETWORK_STATIC_VERSION,
    process.env.MATIC_NETWORK_NETWORK || MATIC_NETWORK_NETWORK
  );

  console.log(`Reading Matic Network config: `, configURL);
  const resp = await axios.get(configURL);
  const config = resp.data;

  const childChainManager = config.Matic.POSContracts.ChildChainManagerProxy;
  console.log(`Setting 'childChainManager': `, childChainManager);
  await deployer.deploy(LinkToken, childChainManager);
};

const axios = require('axios')
const LinkToken = artifacts.require('ChildLinkToken')

const MATIC_NETWORK_TESTNET_MUMBAI = 'testnet/mumbai'
const MATIC_NETWORK_MAINNET_V1 = 'mainnet/v1'
const MATIC_NETWORK_DEFAULT_STATIC_VERSION = 'v2.4.3'

const getConfigURL = (version, network) =>
  `https://raw.githubusercontent.com/maticnetwork/static/${version}/network/${network}/index.json`

// Query the Matic static repo to get the manager account
const getMaticNetworkManager = async (network) => {
  const version = process.env.MATIC_NETWORK_STATIC_VERSION || MATIC_NETWORK_DEFAULT_STATIC_VERSION
  const configURL = getConfigURL(version, network)

  console.log(`Reading Matic Network config: `, configURL)
  const resp = await axios.get(configURL)
  const config = resp.data

  return config.Matic.POSContracts.ChildChainManagerProxy
}

// Preconfigured manager accounts for different sidechain networks
const getManager = async (network) => {
  switch (network) {
    case 'maticDevelopment':
    case 'maticMumbai':
      return getMaticNetworkManager(MATIC_NETWORK_TESTNET_MUMBAI)
    case 'maticMainnet':
      return getMaticNetworkManager(MATIC_NETWORK_MAINNET_V1)
    default:
      throw Error(`Manager not configured for network: ${network}`)
  }
}

module.exports = async (deployer, network, accounts) => {
  const childChainManager = process.env.CHILD_CHAIN_MANAGER || (await getManager(network))
  console.log(`Setting 'childChainManager': ${childChainManager}`)
  await deployer.deploy(LinkToken, childChainManager)
}

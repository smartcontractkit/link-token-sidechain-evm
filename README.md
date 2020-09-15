# LINK Token for deployment on EVM sidechains | Contracts [![Build Status](https://travis-ci.org/smartcontractkit/LinkToken.svg?branch=master)](https://travis-ci.org/smartcontractkit/LinkToken)

The LINK token is an [EIP20](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md) token with additional [ERC677](https://github.com/ethereum/EIPs/issues/677) functionality.

The total supply of the token is 0 (at deployment), and each token is divisible up to 18 decimal places. Tokens are minted (deposited) and burned (withdrawn) by the sidechain bridge operator/depositor.

To prevent accidental burns, the token does not allow transfers to the contract itself and to 0x0.

**To bridge Link Token on Sidechains, `ChildLinkToken` implements additional `deposit` and `withdraw` methods to be used by the bridge operator.**

## Details

- Decimals: 18
- Name: ChainLink Token
- Symbol: LINK

### Deployments

- Matic Network [PoS Portal](https://github.com/maticnetwork/pos-portal):
  - Testnet:
    - Ethereum Goerli root [**LinkToken v0.4**](https://github.com/smartcontractkit/LinkToken/blob/master/contracts/LinkToken.sol): [`0x326c977e6efc84e512bb9c30f76e30c160ed06fb`](https://goerli.etherscan.io/address/0x326c977e6efc84e512bb9c30f76e30c160ed06fb)
    - Matic Mumbai child: [`0xA5a937AfEF5924f60b948472FcD681bae469CE9c`](https://mumbai-explorer.matic.today/address/0xA5a937AfEF5924f60b948472FcD681bae469CE9c)
  - Mainnet:
    - Ethereum Mainnet root [**LinkToken v0.4**](https://github.com/smartcontractkit/LinkToken/blob/master/contracts/LinkToken.sol): [`0x514910771af9ca656af840dff83e8264ecf986ca`](https://etherscan.io/token/0x514910771af9ca656af840dff83e8264ecf986ca)
    - Matic Mainnet child: `TODO!`

### Solidity Function Hashes:

```json
{
  "39509351": "increaseAllowance(address,uint256)",
  "66188463": "decreaseApproval(address,uint256)",
  "a217fddf": "DEFAULT_ADMIN_ROLE()",
  "a3b0b5a3": "DEPOSITOR_ROLE()",
  "dd62ed3e": "allowance(address,address)",
  "095ea7b3": "approve(address,uint256)",
  "70a08231": "balanceOf(address)",
  "313ce567": "decimals()",
  "a457c2d7": "decreaseAllowance(address,uint256)",
  "cf2c52cb": "deposit(address,bytes)",
  "248a9ca3": "getRoleAdmin(bytes32)",
  "9010d07c": "getRoleMember(bytes32,uint256)",
  "ca15c873": "getRoleMemberCount(bytes32)",
  "2f2ff15d": "grantRole(bytes32,address)",
  "91d14854": "hasRole(bytes32,address)",
  "d73dd623": "increaseApproval(address,uint256)",
  "06fdde03": "name()",
  "36568abe": "renounceRole(bytes32,address)",
  "d547741f": "revokeRole(bytes32,address)",
  "95d89b41": "symbol()",
  "18160ddd": "totalSupply()",
  "a9059cbb": "transfer(address,uint256)",
  "4000aea0": "transferAndCall(address,uint256,bytes)",
  "23b872dd": "transferFrom(address,address,uint256)",
  "2e1a7d4d": "withdraw(uint256)"
}
```

### JSON ABI:

```json
[
  {
    "inputs": [{ "internalType": "address", "name": "childChainManager", "type": "address" }],
    "stateMutability": "nonpayable",
    "type": "constructor"
  },
  {
    "anonymous": false,
    "inputs": [
      { "indexed": true, "internalType": "address", "name": "owner", "type": "address" },
      { "indexed": true, "internalType": "address", "name": "spender", "type": "address" },
      { "indexed": false, "internalType": "uint256", "name": "value", "type": "uint256" }
    ],
    "name": "Approval",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      { "indexed": true, "internalType": "bytes32", "name": "role", "type": "bytes32" },
      {
        "indexed": true,
        "internalType": "bytes32",
        "name": "previousAdminRole",
        "type": "bytes32"
      },
      { "indexed": true, "internalType": "bytes32", "name": "newAdminRole", "type": "bytes32" }
    ],
    "name": "RoleAdminChanged",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      { "indexed": true, "internalType": "bytes32", "name": "role", "type": "bytes32" },
      { "indexed": true, "internalType": "address", "name": "account", "type": "address" },
      { "indexed": true, "internalType": "address", "name": "sender", "type": "address" }
    ],
    "name": "RoleGranted",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      { "indexed": true, "internalType": "bytes32", "name": "role", "type": "bytes32" },
      { "indexed": true, "internalType": "address", "name": "account", "type": "address" },
      { "indexed": true, "internalType": "address", "name": "sender", "type": "address" }
    ],
    "name": "RoleRevoked",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      { "indexed": true, "internalType": "address", "name": "from", "type": "address" },
      { "indexed": true, "internalType": "address", "name": "to", "type": "address" },
      { "indexed": false, "internalType": "uint256", "name": "value", "type": "uint256" },
      { "indexed": false, "internalType": "bytes", "name": "data", "type": "bytes" }
    ],
    "name": "Transfer",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      { "indexed": true, "internalType": "address", "name": "from", "type": "address" },
      { "indexed": true, "internalType": "address", "name": "to", "type": "address" },
      { "indexed": false, "internalType": "uint256", "name": "value", "type": "uint256" }
    ],
    "name": "Transfer",
    "type": "event"
  },
  {
    "inputs": [],
    "name": "DEFAULT_ADMIN_ROLE",
    "outputs": [{ "internalType": "bytes32", "name": "", "type": "bytes32" }],
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [],
    "name": "DEPOSITOR_ROLE",
    "outputs": [{ "internalType": "bytes32", "name": "", "type": "bytes32" }],
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [
      { "internalType": "address", "name": "owner", "type": "address" },
      { "internalType": "address", "name": "spender", "type": "address" }
    ],
    "name": "allowance",
    "outputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }],
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [
      { "internalType": "address", "name": "spender", "type": "address" },
      { "internalType": "uint256", "name": "amount", "type": "uint256" }
    ],
    "name": "approve",
    "outputs": [{ "internalType": "bool", "name": "", "type": "bool" }],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [{ "internalType": "address", "name": "account", "type": "address" }],
    "name": "balanceOf",
    "outputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }],
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [],
    "name": "decimals",
    "outputs": [{ "internalType": "uint8", "name": "", "type": "uint8" }],
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [
      { "internalType": "address", "name": "spender", "type": "address" },
      { "internalType": "uint256", "name": "subtractedValue", "type": "uint256" }
    ],
    "name": "decreaseAllowance",
    "outputs": [{ "internalType": "bool", "name": "", "type": "bool" }],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      { "internalType": "address", "name": "spender", "type": "address" },
      { "internalType": "uint256", "name": "subtractedValue", "type": "uint256" }
    ],
    "name": "decreaseApproval",
    "outputs": [{ "internalType": "bool", "name": "", "type": "bool" }],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [{ "internalType": "bytes32", "name": "role", "type": "bytes32" }],
    "name": "getRoleAdmin",
    "outputs": [{ "internalType": "bytes32", "name": "", "type": "bytes32" }],
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [
      { "internalType": "bytes32", "name": "role", "type": "bytes32" },
      { "internalType": "uint256", "name": "index", "type": "uint256" }
    ],
    "name": "getRoleMember",
    "outputs": [{ "internalType": "address", "name": "", "type": "address" }],
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [{ "internalType": "bytes32", "name": "role", "type": "bytes32" }],
    "name": "getRoleMemberCount",
    "outputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }],
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [
      { "internalType": "bytes32", "name": "role", "type": "bytes32" },
      { "internalType": "address", "name": "account", "type": "address" }
    ],
    "name": "grantRole",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      { "internalType": "bytes32", "name": "role", "type": "bytes32" },
      { "internalType": "address", "name": "account", "type": "address" }
    ],
    "name": "hasRole",
    "outputs": [{ "internalType": "bool", "name": "", "type": "bool" }],
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [
      { "internalType": "address", "name": "spender", "type": "address" },
      { "internalType": "uint256", "name": "addedValue", "type": "uint256" }
    ],
    "name": "increaseAllowance",
    "outputs": [{ "internalType": "bool", "name": "", "type": "bool" }],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      { "internalType": "address", "name": "spender", "type": "address" },
      { "internalType": "uint256", "name": "addedValue", "type": "uint256" }
    ],
    "name": "increaseApproval",
    "outputs": [{ "internalType": "bool", "name": "", "type": "bool" }],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "name",
    "outputs": [{ "internalType": "string", "name": "", "type": "string" }],
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [
      { "internalType": "bytes32", "name": "role", "type": "bytes32" },
      { "internalType": "address", "name": "account", "type": "address" }
    ],
    "name": "renounceRole",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      { "internalType": "bytes32", "name": "role", "type": "bytes32" },
      { "internalType": "address", "name": "account", "type": "address" }
    ],
    "name": "revokeRole",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "symbol",
    "outputs": [{ "internalType": "string", "name": "", "type": "string" }],
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [],
    "name": "totalSupply",
    "outputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }],
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [
      { "internalType": "address", "name": "recipient", "type": "address" },
      { "internalType": "uint256", "name": "amount", "type": "uint256" }
    ],
    "name": "transfer",
    "outputs": [{ "internalType": "bool", "name": "", "type": "bool" }],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      { "internalType": "address", "name": "_to", "type": "address" },
      { "internalType": "uint256", "name": "_value", "type": "uint256" },
      { "internalType": "bytes", "name": "_data", "type": "bytes" }
    ],
    "name": "transferAndCall",
    "outputs": [{ "internalType": "bool", "name": "success", "type": "bool" }],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      { "internalType": "address", "name": "sender", "type": "address" },
      { "internalType": "address", "name": "recipient", "type": "address" },
      { "internalType": "uint256", "name": "amount", "type": "uint256" }
    ],
    "name": "transferFrom",
    "outputs": [{ "internalType": "bool", "name": "", "type": "bool" }],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      { "internalType": "address", "name": "user", "type": "address" },
      { "internalType": "bytes", "name": "depositData", "type": "bytes" }
    ],
    "name": "deposit",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [{ "internalType": "uint256", "name": "amount", "type": "uint256" }],
    "name": "withdraw",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  }
]
```

## Installation

```bash
yarn install
```

## Testing

Before running tests, open a new terminal and start Ganache on port `8454`:

```bash
ganache-cli -l 8000000
```

Run tests:

```bash
yarn test
```

This will instruct the tests to run against your locally deployed instance of Ganache.

`CHILD_CHAIN_MANAGER` environment is required for deployment to work. If not set, the deployment script will try to use a predefined manager for the `network`:

```bash
yarn test --network maticDevelopment
```

## Migration

```bash
yarn migrate:development
```

This will migrate the `ChildLinkToken` contract to your locally deployed instance of Ganache blockchain.

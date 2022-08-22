import fs from 'fs';
import readline from 'readline';
import {
	Account,
	Contract,
	defaultProvider,
	ec,
	json,
	stark,
	Provider,
	number,
} from 'starknet';

const provider =
	process.env.STARKNET_PROVIDER_BASE_URL === undefined
		? defaultProvider
		: new Provider({ baseUrl: process.env.STARKNET_PROVIDER_BASE_URL });

console.log('Reading OpenZeppelin Account Contract...');
const compiledOZAccount = json.parse(
	fs.readFileSync('./OZAccount.json').toString('ascii')
);

const privateKey1 = stark.randomAddress();
const starkKeyPair1 = ec.genKeyPair(privateKey1);
const starkKeyPub1 = ec.getStarkKey(starkKeyPair1);

console.log('Deployment Tx - Account Contract to StarkNet...');
const accountResponse1 = await provider.deployContract({
	contract: compiledOZAccount,
	constructorCalldata: [starkKeyPub1],
	addressSalt: starkKeyPub1,
});

const privateKey2 = stark.randomAddress();
const starkKeyPair2 = ec.genKeyPair(privateKey2);
const starkKeyPub2 = ec.getStarkKey(starkKeyPair2);

const accountResponse2 = await provider.deployContract({
	contract: compiledOZAccount,
	constructorCalldata: [starkKeyPub2],
	addressSalt: starkKeyPub2,
});

const privateKey3 = stark.randomAddress();
const starkKeyPair3 = ec.genKeyPair(privateKey3);
const starkKeyPub3 = ec.getStarkKey(starkKeyPair3);

const accountResponse3 = await provider.deployContract({
	contract: compiledOZAccount,
	constructorCalldata: [starkKeyPub3],
	addressSalt: starkKeyPub3,
});

console.log('Account 1 address ', accountResponse1.contract_address);
console.log('Account 2 address ', accountResponse2.contract_address);
console.log('Account 3 address ', accountResponse3.contract_address);

console.log(
	'Waiting for Tx to be Accepted on Starknet - OpenZeppelin Account Deployment...'
);
await provider.waitForTransaction(accountResponse1.transaction_hash);

function askQuestion(query) {
	const rl = readline.createInterface({
		input: process.stdin,
		output: process.stdout,
	});

	return new Promise((resolve) =>
		rl.question(query, (ans) => {
			rl.close();
			resolve(ans);
		})
	);
}

////////////////////////////////////////////////////////////////////////////////
// IMPORTANT: you need to fund your newly created account before you use it.
// You can do so by using a faucet:
// https://faucet.goerli.starknet.io/
////////////////////////////////////////////////////////////////////////////////

const ans = await askQuestion(
	'Did you add funds to your Account? Hit enter if yes'
);

////////////////
//// PART 2 ////
////////////////

const account = new Account(
	provider,
	accountResponse1.contract_address,
	starkKeyPair1
);

const account2 = new Account(
	provider,
	accountResponse2.contract_address,
	starkKeyPair2
);

const account3 = new Account(
	provider,
	accountResponse3.contract_address,
	starkKeyPair3
);

// ----------------------------------------------------------------------------------
// ERC20 Contract
// ----------------------------------------------------------------------------------

console.log('Reading ERC20 Contract...');
const compiledErc20 = json.parse(
	fs.readFileSync('./ERC20.json').toString('ascii')
);

console.log('Deployment Tx - ERC20 Contract to StarkNet...');
const erc20Response = await provider.deployContract({
	contract: compiledErc20,
});

console.log('Waiting for Tx to be Accepted on Starknet - ERC20 Deployment...');
await provider.waitForTransaction(erc20Response.transaction_hash);
const erc20Address = erc20Response.contract_address;
console.log('ERC20 Address: ', erc20Address);

const erc20 = new Contract(compiledErc20.abi, erc20Address, provider);

erc20.connect(account);

console.log(`Invoke Tx - Minting 1000 tokens to ${account.address}...`);
const { transaction_hash: mintTxHash } = await erc20.mint(
	account.address,
	'1000',
	{
		maxFee: '999999995330000',
	}
);
console.log(`Waiting for Tx to be Accepted on Starknet - Minting...`);
await provider.waitForTransaction(mintTxHash);

console.log(`Calling StarkNet for account balance...`);
const balAc1 = await erc20.balance_of(account.address);
const balAc2 = await erc20.balance_of(account2.address);
const balAc3 = await erc20.balance_of(account3.address);

console.log(
	`account 1 Address ${account.address} has a balance of:`,
	number.toBN(balAc1.res, 16).toString()
);
console.log(
	`account 2 Address ${account2.address} has a balance of:`,
	number.toBN(balAc2.res, 16).toString()
);
console.log(
	`account 3 Address ${account3.address} has a balance of:`,
	number.toBN(balAc3.res, 16).toString()
);

// -----------------------------------------------------------------------------------------
// Deploy MULTI-SIG contract
// -----------------------------------------------------------------------------------------

console.log('Deploying MultiSig Contract...');
const multiSigContract = json.parse(
	fs.readFileSync('./multisig_compiled.json').toString('ascii')
);

let owners = [account.address, account2.address, account3.address];

const multiSigResponse = await provider.deployContract({
	contract: multiSigContract,
	constructorCalldata: [owners],
});

console.log(
	'Waiting for Tx to be Accepted on Starknet - MultiSig Deployment...'
);
await provider.waitForTransaction(multiSigResponse.transaction_hash);
const multiSigAddress = erc20Response.contract_address;
console.log('MultiSig Address: ', multiSigAddress);

const wallet = new Contract(compiledErc20.abi, multiSigAddress, provider);

wallet.connect(account);

//--------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------

// Execute tx transfer of 10 tokens
console.log(`Invoke Tx - Transfer 300 tokens back to Multi sig wallet ...`);
const { code, transaction_hash: transferTxHash } = await account.execute(
	{
		contractAddress: erc20Address,
		entrypoint: 'transfer',
		calldata: [multiSigAddress, '10'],
	},
	undefined,
	{
		maxFee: '999999995330000',
	}
);

// Wait for the invoke transaction to be accepted on StarkNet
console.log(`Waiting for Tx to be Accepted on Starknet - Transfer...`);
await provider.waitForTransaction(transferTxHash);

// Check balance after transfer - should be 990
console.log(`Calling StarkNet for account balance...`);
const walletBal = await erc20.balance_of(account.address);

console.log(
	`account Address ${multiSigAddress} has a balance of:`,
	number.toBN(walletBal.res, 16).toString()
);

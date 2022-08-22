// import { hash } from 'starknet';
const { hash } = require('starknet');

const fs = require('fs');
const { fetch } = require('cross-fetch');
const {
	Account,
	Contract,
	defaultProvider,
	ec,
	json,
	number,
	uint256,
	stark,
	toFelt,
	shortString,
} = require('starknet');

// const openDiamondAbi = require('../starknet-artifacts/contracts/open_diamond.cairo/open_diamond_abi.json');

global.fetch = fetch;

async function main() {
	await testExample();
}

async function testExample() {
	const initializer = hash.getSelectorFromName('initializer');
	const view_balance = hash.getSelectorFromName('view_balance');
	const add_balance = hash.getSelectorFromName('add_balance');
	console.log('initializer: ', initializer);
	console.log('view_balance: ', view_balance);
	console.log('add_balance: ', add_balance);

	let account;

	console.log('-------Deploying Account-------');
	// Generate public and private key pair.
	const privateKey = stark.randomAddress();
	const starkKeyPair = ec.genKeyPair(privateKey);
	const starkKeyPub = ec.getStarkKey(starkKeyPair);

	try {
		const compiledAccount = json.parse(
			fs.readFileSync('./Account.json').toString('ascii')
		);

		console.time();
		const accountResponse = await defaultProvider.deployContract({
			contract: compiledAccount,
			constructorCalldata: [starkKeyPub],
			addressSalt: starkKeyPub,
		});

		await defaultProvider.waitForTransaction(accountResponse.transaction_hash);
		console.log('transaction_hash: ', accountResponse.transaction_hash);

		account = new Contract(compiledAccount.abi, accountResponse.address);

		console.log('account: ', account);
		console.log('----Account created----');

		const compiledProxy = json.parse(
			fs.readFileSync('./compiled/Proxy_compiled.json').toString('ascii')
		);
		// erc20 instance
		const proxy = new Contract(
			compiledProxy.abi,
			'0x0731c2512ec336a46c32db1b8135249d667ae80f8a30d0c63bd8d5ad19d98944',
			defaultProvider
		);

		proxy.connect(account);

		const { transaction_hash: mintTxHash } = await proxy.setValue1(
			number.toFelt(1789)
		);
		console.log(`Waiting for Tx to be Accepted on Starknet - Minting...`);
		await defaultProvider.waitForTransaction(mintTxHash);

		const res = await defaultProvider.callContract({
			contractAddress:
				'0x0012e4618a9947c908f7aad0eff3a618407fc769cdf6bc416854f299fab72f38',
			entrypoint: 'setValue1',
			calldata: [number.toFelt(1789)],
		});
		console.log('res', res);

		const res2 = await defaultProvider.callContract({
			contractAddress:
				'0x0731c2512ec336a46c32db1b8135249d667ae80f8a30d0c63bd8d5ad19d98944',
			entrypoint: 'upgrade',
			calldata: [
				number.toFelt(
					'0xb96ff60606c8d5ab032e7bce5d2d5fa7709a93e1834147cc189e82ded8a26f'
				),
			],
		});
		console.log('res', res2);

		const res3 = await defaultProvider.callContract({
			contractAddress:
				'0x0731c2512ec336a46c32db1b8135249d667ae80f8a30d0c63bd8d5ad19d98944',
			entrypoint: 'add_ten',
			calldata: [],
		});
		console.log('res', res3);
	} catch (error) {
		console.log(error);
	}

	console.log('DONE');
}

if (require.main === module) {
	main()
		.then(() => {
			process.exit(0);
		})
		.catch((error) => {
			console.error(error);
			process.exit(1);
		});
}

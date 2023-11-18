import { ethers } from "ethers";
import { readFile } from 'fs/promises';

class Web3 {
    provider;
    wallet;
    contract;
    // connect to mumbai testnet
    // url = https://endpoints.omniatech.io/v1/matic/mumbai/public
    getProvider(url) {
        if (!this.provider) {
            this.provider = new ethers.providers.JsonRpcProvider(url);
        }
        
        return this.provider;
    }

    // private key
    // 4d0d424fea53f5c431eb1d4220216063bexxxxxxxxxxxxxx
    connectWallet(private_key) {
        const wallet = new ethers.Wallet(private_key);
        this.wallet = wallet.connect(this.provider);

        return this.wallet;
    }

    initContract(address, abi) {
        const contract = new ethers.Contract(address, abi, this.provider);
        this.contract = contract.connect(this.wallet);
        return this.contract;
    }

    async getTokenName() {
        return await this.contract.name();
    }

    async isAdmin(address) {
        return await this.contract.is_admin(address);
    }

    async getTokenDecimal() {
        return await this.contract.decimals();
    }

    async hadiahkanToken(to, amount) {
        const formated_amount = ethers.utils.parseUnits(amount, await this.getTokenDecimal());
        return await this.contract.awardToken(to, formated_amount);
    }

    // send token (interaksi ke smart contract)
    async sendToken(to, amount) {
        const formated_amount = ethers.utils.parseUnits(amount, await this.getTokenDecimal());
        return await this.contract.transfer(to, formated_amount);
    }

    getAddress() {
        return this.wallet.address;
    }

    async getCoinAccountBalance(address) {
        const balance = await this.provider.getBalance(address);
        // format ethers should filled with wei, wei is 18 decimal from ether
        // return wei to ether (1 * 10 ** 18 ===> 1);
        const formatted = ethers.utils.formatEther(balance);
        return formatted;
    }

    // amount format is in ether
    // send coin (tidak ada interaksi ke smart contract, langsung ke blockchain aja)
    async sendBalance(to, amount) {
        // parse ether should filled with ether, 0.001 0.1 1
        // return ether to wei (1 ===> 1 * 10 ** 18)
        const amount_to_wei = ethers.utils.parseEther(amount);

        const send = await this.wallet.sendTransaction({
            to: to,
            value: amount_to_wei
        });

        console.log('send', send);
        await send.wait();

        return send;
    }


}

(async () => {
    const web3 = new Web3();
    web3.getProvider("https://polygon-mumbai-pokt.nodies.app");
    // isi private keynya
    web3.connectWallet("");
    const balance = await web3.getCoinAccountBalance(web3.getAddress());
    console.log(balance, web3.getAddress())
    const token_abi = JSON.parse(
        await readFile(
          new URL('./tokenabi.json', import.meta.url)
        )
    );
    web3.initContract("0x9b6576434b0e3e48b3c38ac4db1586dbc24acbad", token_abi);
    const is_admin = await web3.isAdmin(web3.getAddress());
    const send_token = await web3.sendToken("0x7663Dc8Ee7Cc112ad2F1Afaa23838DC6Ebf88B88", "2");
    console.log(send_token);
})();
const crypto = require("crypto"), SHA256 = message => crypto.createHash("sha256").update(message).digest("hex");
 
class Block {
    timestamp;
    data;
    hash;
    prevHash;
    nonce;
    object = {
        test: {
            contoh: 'test'
        }
    };
    
    constructor(timestamp = "", data = []){
        this.timestamp = timestamp;
        this.data = data;
        this.hash = this.getHash();
        this.prevHash = "";
        this.nonce =0;
    }
 
    getHash() {
        console.log(this.object.test.contoh);
        return SHA256(JSON.stringify(this.data) + this.timestamp + this.prevHash + this.nonce);
    }

    mine(difficulty){
        console.log('test block class 1')
        while(!this.hash.startsWith(Array(difficulty + 1).join("0"))){
            console.log('test block class 2', this.hash.startsWith(Array(difficulty + 1).join("0")), this.hash)
            this.nonce++;
            console.log('nonce', this.nonce);
            this.hash = this.getHash();
        }
    }
}
 
class Blockchain {
    constructor(){
        this.chain = [new Block(Date.now().toString())];
        this.difficulty = 1;
        this.blockTime = 30000;
    }
    getLastBlock(){
        return this.chain[this.chain.length - 1];
    }
 
    addBlock(block){
        console.log('test 2');
        block.prevHash = this.getLastBlock().hash;
        console.log('test 3', block.prevHash);
        block.hash = block.getHash();
        console.log('test 4', block.hash);
        block.mine(this.difficulty);
        console.log('test 5', this.difficulty);
 
        this.difficulty += Date.now() - parseInt(this.getLastBlock().timestamp) < this.blocktime ? 1 : -1;
 
        this.chain.push(block);
    }
    isValid(blockchain = this){
        for (let i = 1; i < blockchain.chain.length; i++){
            const currentBlock = blockchain.chain[i];
            const prevBlock = blockchain.chain[i-1];
 
            if (currentBlock.hash !== currentBlock.getHash() || currentBlock.prevHash !== prevBlock.hash){
                return false;
            }
        }
        return true;
    }
}
 
// const aisyahChain = new Blockchain();
// console.log('test');
// const block = new Block(Date.now().toString(), ["Hello BUIDLERS1"]);
// aisyahChain.addBlock(block);
 
// console.log(aisyahChain);

const block = new Block(Date.now().toString(), ["Hello BUIDLERS1"]);
console.log(block.getHash())
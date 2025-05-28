const crypto = require('node:crypto')
const ECDSA = require('elliptic').ec
const ec = new ECDSA('secp256k1')

const hexKeys = {
	"privateKey": "779d135b9526dc15715ed7afab5323fb703d579f1ac192b2f1959f528af6583a",
	"publicKey": "046115eb1a061ba8ac8507e7ab6136dae5cbb1fb1cd641452ef97b4a3761497df838eea576696709ea3fad5373bab00e14375bc8114451c3cfe37eb7b8e8be5d5e"
}
const KeyPair = ec.keyFromPrivate(hexKeys.privateKey, 'hex')

const msg = 'send:1:0x1'
const msgHash = crypto.createHash('sha256').update(msg).digest('hex')
console.log('msg hash:', msgHash)

const signature = KeyPair.sign(msgHash, 'hex')
console.log('signature:', signature.toDER('hex'))

const isValid = KeyPair.verify(msgHash, signature)
console.log('is valid?', isValid)
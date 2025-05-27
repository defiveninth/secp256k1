const ECDSA = require('elliptic').ec
const crypto = require('crypto');

const ec = new ECDSA('secp256k1')

const keyPair = ec.genKeyPair()

console.log(keyPair.getPrivate('hex'))
console.log(keyPair.getPublic('hex'))


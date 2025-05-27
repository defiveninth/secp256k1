const crypto = require('node:crypto');
const msg = 'send:1:0x1'

const msgHash1 = crypto
	.createHash('sha256')
	.update(msg)
	.digest('hex')
console.log(msgHash1)

const msgHash2 = crypto
	.createHash('sha256')
	.update('send')
	.update(':1')
	.update(':0x1')
	.digest('hex')
console.log(msgHash2)
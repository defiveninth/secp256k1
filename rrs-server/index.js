const express = require('express');
const authRouter = require('./routes/auth');

const app = express();
const PORT = process.env.PORT || 3000;

// Enable JSON body parsing middleware
app.use(express.json());

// Mount authentication router
app.use('/auth', authRouter);

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

const express = require('express');
const authRouter = require('./routes/auth');
const restaurantsRouter = require('./routes/restaurants');
const mockRouter = require('./routes/mock');

const app = express();
const PORT = process.env.PORT || 3000;

// Enable JSON body parsing middleware
app.use(express.json());

// Mount routers
app.use('/auth', authRouter);
app.use('/restaurants', restaurantsRouter);
app.use('/mock', mockRouter);

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

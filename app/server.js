// app/server.js
const express = require('express');

const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (_req, res) => {
  res.json({
    name: 'containers-build-showdown-app',
    message: 'Hello from the sample app!',
    time: new Date().toISOString(),
  });
});

app.listen(PORT, () => {
  console.log(`Sample app listening on port ${PORT}`);
});

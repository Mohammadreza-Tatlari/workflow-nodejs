const express = require('express')
const app = express()

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '/src/index.html'))
})

const PORT = 8080

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`)
})
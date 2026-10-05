import 'dotenv/config'
import app from './src/app.js'
import sequelize from './src/config/database.js'
import './src/models/index.js'

const port = Number(process.env.PORT || 5000)

async function startServer() {
  try {
    await sequelize.authenticate()
    console.log('Database connected successfully.')

    app.listen(port, () => {
      console.log(`Server running on http://localhost:${port}`)
    })
  } catch (error) {
    console.error('Database connection failed:', error.message)
    process.exitCode = 1
  }
}

startServer()
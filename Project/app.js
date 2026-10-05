import cors from 'cors'
import express from 'express'
import authRoutes from './routes/authRoutes.js'
import vehicleRoutes from './routes/vehicleRoutes.js'

const app = express()

app.use(cors({ origin: 'http://localhost:5173' }))
app.use(express.json())

app.get('/api/health', (_request, response) => {
  response.json({
    success: true,
    message: 'Vehicle Service Booking API is running',
  })
})

app.use('/api/auth', authRoutes)
app.use('/api/vehicles', vehicleRoutes)

app.use((_request, response) => {
  response.status(404).json({ success: false, message: 'Route not found' })
})

app.use((error, _request, response, _next) => {
  console.error('Unhandled server error:', error.message)
  response.status(error.statusCode || 500).json({
    success: false,
    message: error.statusCode ? error.message : 'Something went wrong',
  })
})

export default app
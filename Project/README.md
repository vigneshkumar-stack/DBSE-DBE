# Vehicle Service Booking Backend

## Technologies

Node.js, Express.js, MySQL, Sequelize, dotenv, CORS, bcrypt, jsonwebtoken, and nodemon.

## Folder structure

```text
backend/
├── src/
│   ├── config/database.js
│   ├── controllers/authController.js
│   ├── middleware/authMiddleware.js
│   ├── models/Role.js
│   ├── models/User.js
│   ├── models/index.js
│   ├── routes/authRoutes.js
│   ├── services/authService.js
│   └── app.js
├── server.js
├── .env.example
├── .gitignore
└── package.json
```

## Installation

From this directory:

```bash
npm install
```

## Environment configuration

Copy `.env.example` to `.env` and set the MySQL password and a private JWT secret. The `.env` file is ignored by Git.

## MySQL configuration

The backend connects to the existing `vehicle_service_db` database using the `DB_*` variables. It only calls Sequelize `authenticate()` at startup. It does not call `sync()`, alter tables, drop tables, or recreate the database.

The initial models map the existing `roles` and `users` tables and use `roles.role_id` and `users.role_id` for their relationship.

## Development server

```bash
npm run dev
```

For a normal start:

```bash
npm start
```

The server starts on `http://localhost:5000` only after the database connection succeeds.

## Health check

`GET http://localhost:5000/api/health`

```json
{
  "success": true,
  "message": "Vehicle Service Booking API is running"
}
```

## Authentication APIs

`POST /api/auth/register` creates a `CUSTOMER` account or maps `SERVICE_CENTER` registration to the existing `SERVICE_ADVISOR` role. Public registration for `ADMIN` and `TECHNICIAN` is rejected.

`POST /api/auth/login` verifies the bcrypt password and returns a one-day JWT. Send it on protected requests as `Authorization: Bearer <token>`.

Protected test endpoints:

- `GET /api/auth/profile`
- `GET /api/auth/customer-test` requires `CUSTOMER`
- `GET /api/auth/service-center-test` requires `SERVICE_ADVISOR`

## Vehicle APIs

All vehicle endpoints require a valid customer JWT:

- `POST /api/vehicles`
- `GET /api/vehicles`
- `GET /api/vehicles/:id`
- `PUT /api/vehicles/:id`
- `DELETE /api/vehicles/:id`

Vehicle ownership is taken from the verified JWT, never from the request body. The model maps the existing `vehicles` table and no Sequelize synchronization is run.

## Current implementation status

The Express foundation, database connectivity, health endpoint, bcrypt registration and login, JWT authentication, role authorization, authentication middleware, Role/User relationship, and customer Vehicle CRUD are implemented. Booking, inventory, payment, and other module APIs are not included.
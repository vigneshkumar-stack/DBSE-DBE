# Backend API Audit

Date: 2026-09-29

## Audit scope

Audited `src/config`, `src/controllers`, `src/middleware`, `src/models`, `src/routes`, `src/services`, `src/app.js`, and `server.js`. The audit was based on executable route registration and the route -> controller -> service -> model path, not file presence alone.

## Existing and implemented APIs

| Module | Status | Evidence |
|---|---|---|
| Authentication | COMPLETE | `authRoutes.js` registers register, login, profile, customer-test, and service-center-test. `authService.js` uses bcrypt and JWT. Middleware verifies JWT and roles. |
| Vehicle Management | COMPLETE | `vehicleRoutes.js`, `vehicleController.js`, `vehicleService.js`, and `Vehicle.js` implement protected customer CRUD at `/api/vehicles`. |
| Service Centers | NOT IMPLEMENTED | No service-center route, controller, service, or model is registered. |
| Services | NOT IMPLEMENTED | No service route, controller, service, or model is registered. |
| Service Slots | NOT IMPLEMENTED | No slot route, controller, service, or model is registered. |
| Booking Management | NOT IMPLEMENTED | No booking route, controller, service, or model is registered. |
| Job Cards | NOT IMPLEMENTED | No job-card route, controller, service, or model is registered. |
| Technician Management | NOT IMPLEMENTED | No technician route, controller, service, or model is registered. |
| Technician Allocation | NOT IMPLEMENTED | No allocation route, controller, service, or model is registered. |
| Vehicle Inspection | NOT IMPLEMENTED | No inspection route, controller, service, or model is registered. |
| Additional Repair Requests | NOT IMPLEMENTED | No repair-request route, controller, service, or model is registered. |
| Spare Parts | NOT IMPLEMENTED | No spare-parts route, controller, service, or model is registered. |
| Inventory | NOT IMPLEMENTED | No inventory route, controller, service, or model is registered. |
| Inventory Transactions | NOT IMPLEMENTED | No inventory-transaction route, controller, service, or model is registered. |
| Invoices | NOT IMPLEMENTED | No invoice route, controller, service, or model is registered. |
| Invoice Items | NOT IMPLEMENTED | No invoice-item route, controller, service, or model is registered. |
| Payments | NOT IMPLEMENTED | No payment route, controller, service, or model is registered. |
| Service Tracking / Job Status History | NOT IMPLEMENTED | No tracking or job-status-history route, controller, service, or model is registered. |
| Notifications | NOT IMPLEMENTED | No notification route, controller, service, or model is registered. |
| Maintenance Reminders | NOT IMPLEMENTED | No reminder route, controller, service, or model is registered. |
| Reviews | NOT IMPLEMENTED | No review route, controller, service, or model is registered. |
| Customer Management | NOT IMPLEMENTED | No customer-management route, controller, service, or model is registered. |
| Audit Logs | NOT IMPLEMENTED | No audit-log route, controller, service, or model is registered. |

## Base API

- `GET /api/health` is implemented in `src/app.js`.
- Unknown routes return JSON `404` responses.
- Central error handling returns sanitized JSON responses.
- `server.js` authenticates the existing MySQL database before starting Express.
- No `sequelize.sync()` call is present. No database or table creation/drop operation was added.

## Database findings

The existing live schema was inspected read-only. The `vehicles` table contains:

`vehicle_id`, `user_id`, `vehicle_type_id`, `brand`, `model`, `registration_number`, `model_year`, `fuel_type`, `color`, and `mileage`.

`registration_number` has a unique database constraint. The new Sequelize model maps those columns exactly and does not alter the schema.

## Vehicle APIs

All vehicle routes require `Bearer <JWT>` and `CUSTOMER` role authorization:

- `POST /api/vehicles`
- `GET /api/vehicles`
- `GET /api/vehicles/:id`
- `PUT /api/vehicles/:id`
- `DELETE /api/vehicles/:id`

Vehicle ownership is always scoped to `request.user.user_id` from the verified JWT. A request body cannot choose another owner. A vehicle belonging to another customer is returned as `404`.

## Final implementation status

Authentication was not replaced or modified. Vehicle Management was the only missing module implemented in this step. All remaining modules are intentionally left for later implementation.

## Verification results

- Existing authentication login: `200`
- Vehicle creation: `201`
- Vehicle list, get, update, and delete: `200`
- Duplicate registration number: `409`
- Missing JWT: `401`
- Cross-customer vehicle access: `404`
- Lookup after deletion: `404`
- No schema-destructive operation was added.

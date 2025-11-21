# API Reference

This document provides detailed information about the Arnold Commerce API, including endpoints, request/response formats, and examples.

## Table of Contents
1. [Base URL](#base-url)
2. [Authentication](#authentication)
3. [Request Format](#request-format)
4. [Response Format](#response-format)
5. [Error Handling](#error-handling)
6. [Pagination](#pagination)
7. [Filtering](#filtering)
8. [Sorting](#sorting)
9. [Field Selection](#field-selection)
10. [Rate Limiting](#rate-limiting)
11. [API Endpoints](#api-endpoints)
12. [Webhooks](#webhooks)
13. [Changelog](#changelog)

## Base URL

All API requests should be made to the following base URL:

```
https://api.arnoldcommerce.com/v1
```

For local development:
```
http://localhost:5000/api/v1
```

## Authentication

Most API endpoints require authentication. Include the access token in the `Authorization` header:

```http
GET /api/v1/users/me
Authorization: Bearer <access_token>
```

### Authentication Methods

1. **JWT (Recommended)**
   - Obtain tokens via `/auth/login`
   - Include in `Authorization: Bearer <token>` header

2. **API Key**
   - For server-to-server communication
   - Include in `X-API-Key: <api_key>` header

3. **Session Cookie**
   - For browser-based applications
   - Set via `Set-Cookie` header during login

## Request Format

### Headers

| Header | Description | Required |
|--------|-------------|----------|
| `Authorization` | Bearer token for authentication | Yes* |
| `Content-Type` | Must be `application/json` for JSON payloads | Yes** |
| `Accept` | Should be `application/json` | No |
| `X-Requested-With` | Set to `XMLHttpRequest` for AJAX requests | No |
| `X-API-Key` | API key for server-to-server communication | No |

*Required for authenticated endpoints
**Required for POST, PUT, PATCH requests with a body

### Query Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `fields` | string | Comma-separated list of fields to return | `fields=id,name,price` |
| `include` | string | Related resources to include | `include=category,reviews` |
| `filter` | object | Filter criteria (see [Filtering](#filtering)) | `filter[price][gt]=100` |
| `sort` | string | Sort order (see [Sorting](#sorting)) | `sort=-createdAt,price` |
| `page` | number | Page number for pagination | `page=2` |
| `limit` | number | Items per page (default: 10, max: 100) | `limit=25` |

### Request Body

For `POST`, `PUT`, and `PATCH` requests, include a JSON payload in the request body:

```json
{
  "name": "New Product",
  "price": 99.99,
  "inStock": true
}
```

## Response Format

### Success Response

```json
{
  "success": true,
  "data": {
    "id": "prod_123",
    "name": "Premium Headphones",
    "price": 299.99
  },
  "meta": {
    "page": 1,
    "limit": 10,
    "total": 1
  }
}
```

### Paginated Response

```json
{
  "success": true,
  "data": [
    {"id": "prod_1", "name": "Product 1"},
    {"id": "prod_2", "name": "Product 2"}
  ],
  "meta": {
    "page": 1,
    "limit": 10,
    "total": 2,
    "totalPages": 1,
    "hasNextPage": false,
    "hasPrevPage": false
  }
}
```

## Error Handling

### Error Response Format

```json
{
  "success": false,
  "error": {
    "code": "RESOURCE_NOT_FOUND",
    "message": "The requested resource was not found",
    "details": {
      "resource": "product",
      "id": "prod_999"
    },
    "validationErrors": [
      {
        "field": "email",
        "message": "Invalid email format"
      }
    ]
  }
}
```

### Common Error Codes

| HTTP Status | Error Code | Description |
|-------------|------------|-------------|
| 400 | BAD_REQUEST | Invalid request parameters |
| 401 | UNAUTHORIZED | Authentication required |
| 403 | FORBIDDEN | Insufficient permissions |
| 404 | NOT_FOUND | Resource not found |
| 409 | CONFLICT | Resource conflict |
| 422 | VALIDATION_ERROR | Validation failed |
| 429 | TOO_MANY_REQUESTS | Rate limit exceeded |
| 500 | INTERNAL_SERVER_ERROR | Server error |

## Pagination

Pagination is available on list endpoints using `page` and `limit` query parameters.

### Example

```http
GET /api/v1/products?page=2&limit=20
```

### Response Headers

| Header | Description |
|--------|-------------|
| `X-Page` | Current page number |
| `X-Per-Page` | Items per page |
| `X-Total` | Total number of items |
| `X-Total-Pages` | Total number of pages |
| `Link` | Pagination links (first, prev, next, last) |

## Filtering

Filter results using the `filter` query parameter:

### Comparison Operators

| Operator | Description | Example |
|----------|-------------|---------|
| `eq` | Equal to | `filter[price][eq]=100` |
| `ne` | Not equal to | `filter[price][ne]=100` |
| `gt` | Greater than | `filter[price][gt]=100` |
| `gte` | Greater than or equal to | `filter[price][gte]=100` |
| `lt` | Less than | `filter[price][lt]=100` |
| `lte` | Less than or equal to | `filter[price][lte]=100` |
| `in` | In array | `filter[category][in]=electronics,audio` |
| `nin` | Not in array | `filter[category][nin]=clothing` |
| `like` | Case-insensitive contains | `filter[name][like]=phone` |
| `nlike` | Case-insensitive not contains | `filter[name][nlike]=test` |
| `between` | Between two values | `filter[price][between]=100,200` |
| `isNull` | Is null or not null | `filter[deletedAt][isNull]=true` |

### Logical Operators

```
filter[or][0][price][lt]=100&filter[or][1][category][eq]=sale
```

## Sorting

Sort results using the `sort` parameter:

```
GET /api/v1/products?sort=-createdAt,price
```

- Prefix with `-` for descending order
- Multiple fields can be specified, separated by commas

## Field Selection

Select specific fields to return using the `fields` parameter:

```
GET /api/v1/products?fields=id,name,price
```

## Rate Limiting

- **Public API**: 100 requests per minute per IP
- **Authenticated API**: 1000 requests per minute per user
- **Admin API**: 5000 requests per minute per user

### Rate Limit Headers

| Header | Description |
|--------|-------------|
| `X-RateLimit-Limit` | Request limit per time window |
| `X-RateLimit-Remaining` | Remaining requests in current window |
| `X-RateLimit-Reset` | Timestamp when the limit resets |
| `Retry-After` | Seconds to wait before retrying (when rate limited) |

## API Endpoints

### Authentication

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/auth/register` | Register a new user |
| `POST` | `/auth/login` | User login |
| `POST` | `/auth/refresh-token` | Refresh access token |
| `POST` | `/auth/forgot-password` | Request password reset |
| `POST` | `/auth/reset-password` | Reset password |
| `POST` | `/auth/logout` | Logout user |
| `POST` | `/auth/verify-email` | Verify email address |

### Users

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/users/me` | Get current user profile |
| `PATCH` | `/users/me` | Update profile |
| `POST` | `/users/me/change-password` | Change password |
| `GET` | `/users/me/addresses` | List addresses |
| `POST` | `/users/me/addresses` | Add address |
| `PATCH` | `/users/me/addresses/:id` | Update address |
| `DELETE` | `/users/me/addresses/:id` | Delete address |

### Products

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/products` | List products |
| `POST` | `/products` | Create product (admin) |
| `GET` | `/products/:id` | Get product by ID |
| `PATCH` | `/products/:id` | Update product (admin) |
| `DELETE` | `/products/:id` | Delete product (admin) |
| `GET` | `/products/:id/reviews` | Get product reviews |
| `POST` | `/products/:id/reviews` | Add review |

### Categories

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/categories` | List categories |
| `POST` | `/categories` | Create category (admin) |
| `GET` | `/categories/:id` | Get category by ID |
| `PATCH` | `/categories/:id` | Update category (admin) |
| `DELETE` | `/categories/:id` | Delete category (admin) |
| `GET` | `/categories/:id/products` | Get products in category |

### Cart

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/cart` | Get cart |
| `POST` | `/cart/items` | Add item to cart |
| `PATCH` | `/cart/items/:id` | Update cart item |
| `DELETE` | `/cart/items/:id` | Remove item from cart |
| `DELETE` | `/cart/items` | Clear cart |
| `POST` | `/cart/checkout` | Checkout |

### Orders

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/orders` | List orders |
| `POST` | `/orders` | Create order |
| `GET` | `/orders/:id` | Get order by ID |
| `PATCH` | `/orders/:id/status` | Update order status |
| `POST` | `/orders/:id/cancel` | Cancel order |
| `GET` | `/orders/:id/items` | List order items |

## Webhooks

Arnold Commerce can send webhook notifications for various events. Configure webhook endpoints in the dashboard.

### Events

- `order.created`
- `order.updated`
- `order.paid`
- `order.shipped`
- `order.delivered`
- `order.cancelled`
- `payment.succeeded`
- `payment.failed`
- `customer.created`
- `customer.updated`

### Webhook Payload

```json
{
  "event": "order.created",
  "createdAt": "2023-10-21T12:00:00Z",
  "data": {
    "id": "order_123",
    "status": "pending",
    "amount": 9999,
    "currency": "USD"
  }
}
```

### Security

Webhook requests include a signature in the `X-Signature` header. Verify the signature using your webhook secret.

## Changelog

### 1.0.0 (2023-10-21)
- Initial release of the Arnold Commerce API
- Added authentication, products, categories, cart, and orders endpoints
- Implemented pagination, filtering, and sorting
- Added webhook support for order and payment events

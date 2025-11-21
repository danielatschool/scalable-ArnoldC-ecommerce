# API Design

This document outlines the design principles, conventions, and patterns used in the Arnold Commerce API.

## Table of Contents
1. [RESTful Principles](#restful-principles)
2. [Authentication](#authentication)
3. [Request/Response Format](#requestresponse-format)
4. [Error Handling](#error-handling)
5. [Versioning](#versioning)
6. [Rate Limiting](#rate-limiting)
7. [Pagination](#pagination)
8. [Filtering & Sorting](#filtering--sorting)
9. [Field Selection](#field-selection)
10. [Caching](#caching)

## RESTful Principles

### Resource Naming
- Use plural nouns for resources (e.g., `/products`, `/users`)
- Use lowercase with hyphens for multi-word resource names (e.g., `/order-items`)
- Use nouns, not verbs in endpoint paths

### HTTP Methods
- `GET`: Retrieve a resource or collection
- `POST`: Create a new resource
- `PUT`: Replace a resource (full update)
- `PATCH`: Partially update a resource
- `DELETE`: Remove a resource

### Status Codes
- `200 OK`: Successful GET, PUT, PATCH, or DELETE
- `201 Created`: Resource created successfully
- `204 No Content`: Successful DELETE with no response body
- `400 Bad Request`: Invalid request format
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Insufficient permissions
- `404 Not Found`: Resource not found
- `429 Too Many Requests`: Rate limit exceeded
- `500 Internal Server Error`: Server-side error

## Authentication

### JWT Authentication
```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "securepassword123"
}
```

Response:
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expiresIn": 3600
}
```

### Protected Routes
Include the JWT in the `Authorization` header:
```
Authorization: Bearer <access_token>
```

## Request/Response Format

### Request Headers
```http
GET /api/v1/products
Accept: application/json
Authorization: Bearer <token>
X-Request-ID: abc123
```

### Response Format
```json
{
  "success": true,
  "data": {
    // Response data
  },
  "meta": {
    "page": 1,
    "limit": 10,
    "total": 100
  }
}
```

## Error Handling

### Error Response Format
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": [
      {
        "field": "email",
        "message": "Invalid email format"
      }
    ]
  }
}
```

### Common Error Codes
- `VALIDATION_ERROR`: Request validation failed
- `AUTH_REQUIRED`: Authentication required
- `FORBIDDEN`: Insufficient permissions
- `NOT_FOUND`: Resource not found
- `RATE_LIMIT_EXCEEDED`: Too many requests
- `INTERNAL_SERVER_ERROR`: Server error

## Versioning

API versioning is done through the URL path:
```
/api/v1/resource
```

## Rate Limiting
- 100 requests per minute per IP for public endpoints
- 1000 requests per minute per user for authenticated endpoints

## Pagination

### Request
```
GET /api/v1/products?page=2&limit=20
```

### Response
```json
{
  "success": true,
  "data": [
    // Array of products
  ],
  "meta": {
    "page": 2,
    "limit": 20,
    "total": 150,
    "totalPages": 8
  }
}
```

## Filtering & Sorting

### Filtering
```
GET /api/v1/products?category=electronics&price[gt]=100&price[lt]=500
```

### Sorting
```
GET /api/v1/products?sort=-price,name
```

## Field Selection

### Select Specific Fields
```
GET /api/v1/products?fields=id,name,price
```

### Exclude Fields
```
GET /api/v1/products?exclude=description,specifications
```

## Caching

### Cache-Control Headers
```http
Cache-Control: public, max-age=3600
ETag: "33a64df551425fcc55e4d42a148795d9f25f89d4"
Last-Modified: Wed, 21 Oct 2023 07:28:00 GMT
```

### Conditional Requests
```http
GET /api/v1/products/123
If-None-Match: "33a64df551425fcc55e4d42a148795d9f25f89d4"
```

## Webhooks

### Webhook Payload
```json
{
  "event": "order.created",
  "data": {
    "id": "order_123",
    "status": "pending",
    "amount": 9999,
    "customer": {
      "id": "cus_123",
      "email": "customer@example.com"
    }
  },
  "createdAt": "2023-10-21T10:00:00Z"
}
```

## Best Practices
1. Use HTTPS for all API requests
2. Implement proper CORS policies
3. Validate all input data
4. Sanitize output data
5. Use proper HTTP methods and status codes
6. Implement proper error handling
7. Document all endpoints with OpenAPI/Swagger
8. Monitor API usage and performance

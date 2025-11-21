# Users API

This document describes the user management endpoints for the Arnold Commerce API.

## Table of Contents
1. [Get Current User](#get-current-user)
2. [Update Profile](#update-profile)
3. [Change Password](#change-password)
4. [List Addresses](#list-addresses)
5. [Add Address](#add-address)
6. [Update Address](#update-address)
7. [Delete Address](#delete-address)
8. [Get Order History](#get-order-history)
9. [Get Wishlist](#get-wishlist)
10. [Update Notification Preferences](#update-notification-preferences)

## Get Current User

Retrieve the authenticated user's profile.

```http
GET /api/v1/users/me
Authorization: Bearer <access_token>
```

### Response
```json
{
  "success": true,
  "data": {
    "id": "user_123",
    "email": "john.doe@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "phone": "+12125551234",
    "avatar": "https://example.com/avatars/john.jpg",
    "emailVerified": true,
    "twoFactorEnabled": false,
    "role": "customer",
    "createdAt": "2023-01-15T10:30:00Z",
    "updatedAt": "2023-10-20T14:22:18Z"
  }
}
```

## Update Profile

Update the authenticated user's profile.

```http
PATCH /api/v1/users/me
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "firstName": "John",
  "lastName": "Smith",
  "phone": "+12125556789"
}
```

### Request Body
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| firstName | string | No | User's first name |
| lastName | string | No | User's last name |
| phone | string | No | User's phone number |
| avatar | string | No | URL to user's avatar image |

### Response
```json
{
  "success": true,
  "data": {
    "id": "user_123",
    "firstName": "John",
    "lastName": "Smith",
    "phone": "+12125556789",
    "updatedAt": "2023-10-21T15:30:00Z"
  }
}
```

## Change Password

Change the authenticated user's password.

```http
POST /api/v1/users/me/change-password
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "currentPassword": "oldSecurePassword123",
  "newPassword": "newSecurePassword456",
  "confirmPassword": "newSecurePassword456"
}
```

### Request Body
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| currentPassword | string | Yes | Current password |
| newPassword | string | Yes | New password (min: 8 characters) |
| confirmPassword | string | Yes | Must match newPassword |

### Response
```json
{
  "success": true,
  "message": "Password updated successfully"
}
```

## List Addresses

List all addresses for the authenticated user.

```http
GET /api/v1/users/me/addresses
Authorization: Bearer <access_token>
```

### Response
```json
{
  "success": true,
  "data": [
    {
      "id": "addr_123",
      "type": "shipping",
      "firstName": "John",
      "lastName": "Doe",
      "company": "ACME Inc.",
      "address1": "123 Main St",
      "address2": "Apt 4B",
      "city": "New York",
      "state": "NY",
      "postalCode": "10001",
      "country": "US",
      "phone": "+12125551234",
      "isDefault": true,
      "createdAt": "2023-05-10T08:30:00Z",
      "updatedAt": "2023-05-10T08:30:00Z"
    },
    {
      "id": "addr_124",
      "type": "billing",
      "firstName": "John",
      "lastName": "Doe",
      "company": "ACME Inc.",
      "address1": "456 Billing St",
      "city": "New York",
      "state": "NY",
      "postalCode": "10001",
      "country": "US",
      "phone": "+12125556789",
      "isDefault": true,
      "createdAt": "2023-05-15T14:20:00Z",
      "updatedAt": "2023-10-18T09:15:00Z"
    }
  ]
}
```

## Add Address

Add a new address for the authenticated user.

```http
POST /api/v1/users/me/addresses
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "type": "shipping",
  "firstName": "John",
  "lastName": "Doe",
  "company": "Home Office",
  "address1": "789 Park Ave",
  "city": "New York",
  "state": "NY",
  "postalCode": "10022",
  "country": "US",
  "phone": "+12125559876",
  "isDefault": false
}
```

### Request Body
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| type | string | Yes | Address type (shipping, billing, or both) |
| firstName | string | Yes | First name |
| lastName | string | Yes | Last name |
| company | string | No | Company name |
| address1 | string | Yes | Street address line 1 |
| address2 | string | No | Street address line 2 |
| city | string | Yes | City |
| state | string | Yes | State/province/region |
| postalCode | string | Yes | ZIP/postal code |
| country | string | Yes | ISO 2-letter country code |
| phone | string | No | Phone number |
| isDefault | boolean | No | Set as default address for its type |

### Response
```json
{
  "success": true,
  "data": {
    "id": "addr_125",
    "type": "shipping",
    "firstName": "John",
    "lastName": "Doe",
    "company": "Home Office",
    "address1": "789 Park Ave",
    "city": "New York",
    "state": "NY",
    "postalCode": "10022",
    "country": "US",
    "phone": "+12125559876",
    "isDefault": false,
    "createdAt": "2023-10-21T16:45:00Z",
    "updatedAt": "2023-10-21T16:45:00Z"
  }
}
```

## Update Address

Update an existing address.

```http
PATCH /api/v1/users/me/addresses/addr_123
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "company": "ACME Corp",
  "isDefault": true
}
```

### Path Parameters
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| addressId | string | Yes | ID of the address to update |

### Request Body
Same fields as [Add Address](#add-address), all optional.

### Response
```json
{
  "success": true,
  "data": {
    "id": "addr_123",
    "company": "ACME Corp",
    "isDefault": true,
    "updatedAt": "2023-10-21T17:00:00Z"
  }
}
```

## Delete Address

Delete a user's address.

```http
DELETE /api/v1/users/me/addresses/addr_125
Authorization: Bearer <access_token>
```

### Path Parameters
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| addressId | string | Yes | ID of the address to delete |

### Response
```json
{
  "success": true,
  "message": "Address deleted successfully"
}
```

## Get Order History

Get the authenticated user's order history.

```http
GET /api/v1/users/me/orders?status=completed&limit=5
Authorization: Bearer <access_token>
```

### Query Parameters
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| status | string | No | Filter by order status |
| limit | integer | No | Number of orders to return (default: 10, max: 50) |
| offset | integer | No | Offset for pagination (default: 0) |
| sort | string | No | Sort field with - prefix for desc (e.g., -createdAt) |

### Response
```json
{
  "success": true,
  "data": [
    {
      "id": "order_123",
      "orderNumber": "ORD-20231021-456",
      "status": "completed",
      "total": 1085.95,
      "itemCount": 3,
      "createdAt": "2023-10-21T14:30:00Z",
      "deliveredAt": "2023-10-24T10:15:00Z"
    },
    {
      "id": "order_122",
      "orderNumber": "ORD-20231015-123",
      "status": "completed",
      "total": 249.99,
      "itemCount": 1,
      "createdAt": "2023-10-15T09:15:00Z",
      "deliveredAt": "2023-10-18T14:30:00Z"
    }
  ],
  "meta": {
    "total": 12,
    "limit": 5,
    "offset": 0,
    "hasMore": true
  }
}
```

## Get Wishlist

Get the authenticated user's wishlist.

```http
GET /api/v1/users/me/wishlist
Authorization: Bearer <access_token>
```

### Response
```json
{
  "success": true,
  "data": [
    {
      "id": "wish_123",
      "product": {
        "id": "prod_456",
        "name": "Wireless Earbuds Pro",
        "slug": "wireless-earbuds-pro",
        "price": 179.99,
        "originalPrice": 199.99,
        "image": "https://example.com/images/earbuds-pro.jpg",
        "inStock": true,
        "rating": 4.8
      },
      "addedAt": "2023-10-10T11:20:00Z"
    },
    {
      "id": "wish_124",
      "product": {
        "id": "prod_789",
        "name": "Smart Watch X",
        "slug": "smart-watch-x",
        "price": 249.99,
        "image": "https://example.com/images/smart-watch-x.jpg",
        "inStock": false,
        "rating": 4.5
      },
      "addedAt": "2023-10-05T15:45:00Z"
    }
  ]
}
```

## Update Notification Preferences

Update the user's notification preferences.

```http
PATCH /api/v1/users/me/notifications
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "email": {
    "orderConfirmation": true,
    "shippingUpdates": true,
    "promotions": false,
    "newsletter": true
  },
  "push": {
    "orderStatus": true,
    "promotions": false,
    "priceDrop": true
  },
  "sms": {
    "orderUpdates": true,
    "promotions": false
  }
}
```

### Request Body
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| email | object | No | Email notification preferences |
| push | object | No | Push notification preferences |
| sms | object | No | SMS notification preferences |

### Response
```json
{
  "success": true,
  "data": {
    "notifications": {
      "email": {
        "orderConfirmation": true,
        "shippingUpdates": true,
        "promotions": false,
        "newsletter": true
      },
      "push": {
        "orderStatus": true,
        "promotions": false,
        "priceDrop": true
      },
      "sms": {
        "orderUpdates": true,
        "promotions": false
      }
    },
    "updatedAt": "2023-10-21T18:30:00Z"
  }
}
```

## Error Responses

### Invalid Input
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
      },
      {
        "field": "password",
        "message": "Password must be at least 8 characters"
      }
    ]
  }
}
```

### Address Not Found
```json
{
  "success": false,
  "error": {
    "code": "ADDRESS_NOT_FOUND",
    "message": "The specified address does not exist or does not belong to you"
  }
}
```

### Cannot Remove Default Address
```json
{
  "success": false,
  "error": {
    "code": "DEFAULT_ADDRESS",
    "message": "Cannot delete default address. Please set another address as default first."
  }
}
```

## Best Practices
1. Always validate user input on the server side
2. Implement proper error handling and meaningful error messages
3. Use proper HTTP status codes
4. Implement rate limiting to prevent abuse
5. Cache user data that doesn't change frequently
6. Use transactions for critical operations
7. Implement proper logging for security-sensitive actions
8. Follow the principle of least privilege for user permissions

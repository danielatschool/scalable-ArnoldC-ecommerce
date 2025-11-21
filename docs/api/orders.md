# Orders API

This document describes the order management endpoints for the Arnold Commerce API.

## Table of Contents
1. [Create Order](#create-order)
2. [List Orders](#list-orders)
3. [Get Order](#get-order)
4. [Update Order Status](#update-order-status)
5. [Cancel Order](#cancel-order)
6. [List Order Items](#list-order-items)
7. [Get Order Item](#get-order-item)
8. [Request Return](#request-return)
9. [Track Order](#track-order)
10. [Order Invoices](#order-invoices)

## Create Order

Create a new order from the current cart.

```http
POST /api/v1/orders
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "shippingAddressId": "addr_123",
  "billingAddressId": "addr_124",
  "shippingMethodId": "express",
  "paymentMethod": {
    "type": "credit_card",
    "card": {
      "token": "pm_123456789"
    }
  },
  "notes": "Please ring the doorbell"
}
```

### Request Body
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| shippingAddressId | string | Yes | ID of the shipping address |
| billingAddressId | string | No | ID of the billing address (if different from shipping) |
| shippingMethodId | string | Yes | ID of the selected shipping method |
| paymentMethod | object | Yes | Payment method details |
| notes | string | No | Order notes |

### Response
```json
{
  "success": true,
  "data": {
    "id": "order_123",
    "orderNumber": "ORD-20231021-456",
    "status": "processing",
    "paymentStatus": "succeeded",
    "subtotal": 899.97,
    "shipping": 9.99,
    "tax": 95.99,
    "discount": 179.99,
    "total": 1085.95,
    "items": [
      {
        "id": "item_123",
        "productId": "prod_123",
        "name": "Premium Headphones",
        "quantity": 3,
        "price": 299.99,
        "total": 899.97
      }
    ],
    "shippingAddress": {
      "id": "addr_123",
      "firstName": "John",
      "lastName": "Doe",
      "address1": "123 Main St",
      "address2": "Apt 4B",
      "city": "New York",
      "state": "NY",
      "postalCode": "10001",
      "country": "US",
      "phone": "+12125551234"
    },
    "billingAddress": {
      "id": "addr_124",
      "firstName": "John",
      "lastName": "Doe",
      "address1": "456 Billing St",
      "city": "New York",
      "state": "NY",
      "postalCode": "10001",
      "country": "US"
    },
    "shippingMethod": {
      "id": "express",
      "name": "Express Shipping",
      "price": 9.99,
      "estimatedDelivery": "2023-10-24"
    },
    "paymentMethod": {
      "type": "credit_card",
      "last4": "4242",
      "brand": "visa",
      "expMonth": 12,
      "expYear": 2025
    },
    "createdAt": "2023-10-21T14:30:00Z",
    "updatedAt": "2023-10-21T14:30:00Z"
  }
}
```

## List Orders

Retrieve a paginated list of orders for the authenticated user.

```http
GET /api/v1/orders?page=1&limit=10&status=completed
```

### Query Parameters
| Parameter | Type    | Required | Description                          |
|-----------|---------|----------|--------------------------------------|
| page      | integer | No       | Page number (default: 1)             |
| limit     | integer | No       | Items per page (default: 10, max: 50)|
| status    | string  | No       | Filter by order status               |
| sort      | string  | No       | Sort field with - prefix for desc    |
| startDate | string  | No       | Filter by order date (ISO format)    |
| endDate   | string  | No       | Filter by order date (ISO format)    |

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
      "orderNumber": "ORD-20231020-123",
      "status": "shipped",
      "total": 249.99,
      "itemCount": 1,
      "createdAt": "2023-10-20T09:15:00Z",
      "estimatedDelivery": "2023-10-25"
    }
  ],
  "meta": {
    "page": 1,
    "limit": 10,
    "total": 2,
    "totalPages": 1
  }
}
```

## Get Order

Retrieve details of a specific order.

```http
GET /api/v1/orders/order_123
Authorization: Bearer <access_token>
```

### Path Parameters
| Parameter | Type   | Required | Description  |
|-----------|--------|----------|--------------|
| orderId   | string | Yes      | Order ID     |

### Response
```json
{
  "success": true,
  "data": {
    "id": "order_123",
    "orderNumber": "ORD-20231021-456",
    "status": "completed",
    "paymentStatus": "succeeded",
    "subtotal": 899.97,
    "shipping": 9.99,
    "tax": 95.99,
    "discount": 179.99,
    "total": 1085.95,
    "items": [
      {
        "id": "item_123",
        "productId": "prod_123",
        "name": "Premium Headphones",
        "slug": "premium-headphones",
        "image": "https://example.com/images/headphones.jpg",
        "quantity": 3,
        "price": 299.99,
        "total": 899.97
      }
    ],
    "shippingAddress": {
      "id": "addr_123",
      "firstName": "John",
      "lastName": "Doe",
      "address1": "123 Main St",
      "address2": "Apt 4B",
      "city": "New York",
      "state": "NY",
      "postalCode": "10001",
      "country": "US",
      "phone": "+12125551234"
    },
    "billingAddress": {
      "id": "addr_124",
      "firstName": "John",
      "lastName": "Doe",
      "address1": "456 Billing St",
      "city": "New York",
      "state": "NY",
      "postalCode": "10001",
      "country": "US"
    },
    "shippingMethod": {
      "id": "express",
      "name": "Express Shipping",
      "price": 9.99,
      "trackingNumber": "1Z999AA1234567890",
      "trackingUrl": "https://example-tracking.com/1Z999AA1234567890",
      "carrier": "UPS"
    },
    "paymentMethod": {
      "type": "credit_card",
      "last4": "4242",
      "brand": "visa",
      "expMonth": 12,
      "expYear": 2025
    },
    "coupon": {
      "code": "SUMMER20",
      "discountType": "percentage",
      "discountValue": 20,
      "discountAmount": 179.99
    },
    "timeline": [
      {
        "status": "pending",
        "timestamp": "2023-10-21T14:30:00Z"
      },
      {
        "status": "processing",
        "timestamp": "2023-10-21T14:32:15Z"
      },
      {
        "status": "shipped",
        "timestamp": "2023-10-22T09:45:30Z",
        "details": "Shipped via UPS"
      },
      {
        "status": "delivered",
        "timestamp": "2023-10-24T10:15:00Z",
        "details": "Delivered to customer"
      }
    ],
    "notes": "Leave at the front door",
    "createdAt": "2023-10-21T14:30:00Z",
    "updatedAt": "2023-10-24T10:15:00Z"
  }
}
```

## Update Order Status

Update the status of an order (admin only).

```http
PATCH /api/v1/orders/order_123/status
Authorization: Bearer <admin_token>
Content-Type: application/json

{
  "status": "shipped",
  "trackingNumber": "1Z999AA1234567890",
  "trackingUrl": "https://example-tracking.com/1Z999AA1234567890",
  "carrier": "UPS",
  "notes": "Package shipped via UPS"
}
```

### Path Parameters
| Parameter | Type   | Required | Description  |
|-----------|--------|----------|--------------|
| orderId   | string | Yes      | Order ID     |

### Request Body
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| status | string | Yes | New status (pending, processing, shipped, delivered, cancelled, refunded) |
| trackingNumber | string | No | Tracking number |
| trackingUrl | string | No | Tracking URL |
| carrier | string | No | Shipping carrier |
| notes | string | No | Internal notes |

### Response
```json
{
  "success": true,
  "data": {
    "id": "order_123",
    "status": "shipped",
    "trackingNumber": "1Z999AA1234567890",
    "trackingUrl": "https://example-tracking.com/1Z999AA1234567890",
    "carrier": "UPS",
    "updatedAt": "2023-10-22T09:45:30Z"
  }
}
```

## Cancel Order

Cancel an order (if allowed).

```http
POST /api/v1/orders/order_123/cancel
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "reason": "Changed my mind",
  "refund": true
}
```

### Path Parameters
| Parameter | Type   | Required | Description  |
|-----------|--------|----------|--------------|
| orderId   | string | Yes      | Order ID     |

### Request Body
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| reason | string | No | Reason for cancellation |
| refund | boolean | No | Whether to issue a refund (default: true) |

### Response
```json
{
  "success": true,
  "data": {
    "id": "order_123",
    "status": "cancelled",
    "refundId": "re_123456789",
    "refundAmount": 1085.95,
    "cancelledAt": "2023-10-22T10:30:00Z"
  }
}
```

## List Order Items

List all items in an order.

```http
GET /api/v1/orders/order_123/items
Authorization: Bearer <access_token>
```

### Path Parameters
| Parameter | Type   | Required | Description  |
|-----------|--------|----------|--------------|
| orderId   | string | Yes      | Order ID     |

### Response
```json
{
  "success": true,
  "data": [
    {
      "id": "item_123",
      "productId": "prod_123",
      "name": "Premium Headphones",
      "slug": "premium-headphones",
      "image": "https://example.com/images/headphones.jpg",
      "quantity": 3,
      "price": 299.99,
      "total": 899.97,
      "returnEligible": true,
      "returnDeadline": "2023-11-21T23:59:59Z"
    }
  ]
}
```

## Get Order Item

Get details of a specific order item.

```http
GET /api/v1/orders/order_123/items/item_123
Authorization: Bearer <access_token>
```

### Path Parameters
| Parameter | Type   | Required | Description  |
|-----------|--------|----------|--------------|
| orderId   | string | Yes      | Order ID     |
| itemId    | string | Yes      | Order item ID |

### Response
```json
{
  "success": true,
  "data": {
    "id": "item_123",
    "orderId": "order_123",
    "productId": "prod_123",
    "name": "Premium Headphones",
    "slug": "premium-headphones",
    "description": "High-quality wireless headphones with noise cancellation",
    "image": "https://example.com/images/headphones.jpg",
    "sku": "HD-001-BLK",
    "quantity": 3,
    "price": 299.99,
    "discount": 59.99,
    "total": 899.97,
    "tax": 95.99,
    "returnEligible": true,
    "returnDeadline": "2023-11-21T23:59:59Z",
    "warrantyUntil": "2024-10-21T23:59:59Z"
  }
}
```

## Request Return

Request a return for an order item.

```http
POST /api/v1/orders/order_123/items/item_123/return
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "reason": "Defective product",
  "quantity": 1,
  "action": "refund",
  "comments": "The right earpiece is not working",
  "images": [
    "https://example.com/returns/defect1.jpg"
  ]
}
```

### Path Parameters
| Parameter | Type   | Required | Description  |
|-----------|--------|----------|--------------|
| orderId   | string | Yes      | Order ID     |
| itemId    | string | Yes      | Order item ID |

### Request Body
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| reason | string | Yes | Reason for return |
| quantity | integer | Yes | Number of items to return (max: original quantity) |
| action | string | Yes | Desired action (refund, exchange, store_credit) |
| exchangeProductId | string | No | Required if action is 'exchange' |
| comments | string | No | Additional information |
| images | string[] | No | Array of image URLs showing the issue |

### Response
```json
{
  "success": true,
  "data": {
    "returnId": "ret_123",
    "status": "requested",
    "requestedAt": "2023-10-25T14:30:00Z",
    "estimatedRefund": 299.99,
    "returnLabel": {
      "url": "https://example.com/returns/label.pdf",
      "expiresAt": "2023-11-01T23:59:59Z"
    },
    "instructions": "Please pack the item securely and attach the return label. Drop off at any authorized shipping location."
  }
}
```

## Track Order

Track the shipping status of an order.

```http
GET /api/v1/orders/order_123/tracking
Authorization: Bearer <access_token>
```

### Path Parameters
| Parameter | Type   | Required | Description  |
|-----------|--------|----------|--------------|
| orderId   | string | Yes      | Order ID     |

### Response
```json
{
  "success": true,
  "data": {
    "orderId": "order_123",
    "status": "in_transit",
    "carrier": "UPS",
    "trackingNumber": "1Z999AA1234567890",
    "trackingUrl": "https://www.ups.com/track?tracknum=1Z999AA1234567890",
    "estimatedDelivery": "2023-10-24",
    "events": [
      {
        "date": "2023-10-22T09:45:30Z",
        "status": "shipped",
        "location": "New York, NY",
        "description": "Picked up by carrier"
      },
      {
        "date": "2023-10-23T15:20:10Z",
        "status": "in_transit",
        "location": "Philadelphia, PA",
        "description": "In transit to destination"
      }
    ]
  }
}
```

## Order Invoices

### Get Invoice

Retrieve an order invoice as PDF.

```http
GET /api/v1/orders/order_123/invoice
Authorization: Bearer <access_token>
Accept: application/pdf
```

### Path Parameters
| Parameter | Type   | Required | Description  |
|-----------|--------|----------|--------------|
| orderId   | string | Yes      | Order ID     |

### Response
Returns the invoice as a PDF file.

### Email Invoice

Request an invoice to be emailed.

```http
POST /api/v1/orders/order_123/invoice/email
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "email": "customer@example.com"
}
```

### Path Parameters
| Parameter | Type   | Required | Description  |
|-----------|--------|----------|--------------|
| orderId   | string | Yes      | Order ID     |

### Request Body
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| email | string | Yes | Email address to send the invoice to |

### Response
```json
{
  "success": true,
  "message": "Invoice has been sent to customer@example.com"
}
```

## Error Responses

### Order Not Found
```json
{
  "success": false,
  "error": {
    "code": "ORDER_NOT_FOUND",
    "message": "Order not found"
  }
}
```

### Order Not Eligible for Cancellation
```json
{
  "success": false,
  "error": {
    "code": "CANCELLATION_NOT_ALLOWED",
    "message": "Order cannot be cancelled as it has already been shipped"
  }
}
```

### Return Not Eligible
```json
{
  "success": false,
  "error": {
    "code": "RETURN_NOT_ELIGIBLE",
    "message": "This item is not eligible for return",
    "details": "Return must be requested within 30 days of delivery"
  }
}
```

## Best Practices
1. Implement proper order status validation for state transitions
2. Send email notifications for important order status changes
3. Log all order modifications for audit purposes
4. Implement proper inventory management when orders are cancelled or returned
5. Use transactions for order updates to maintain data consistency
6. Implement proper security checks to ensure users can only access their own orders
7. Cache order data that doesn't change frequently (e.g., product details)
8. Implement rate limiting to prevent abuse of the API

# Cart API

This document describes the shopping cart endpoints for the Arnold Commerce API.

## Table of Contents
1. [Get Cart](#get-cart)
2. [Add Item to Cart](#add-item-to-cart)
3. [Update Cart Item](#update-cart-item)
4. [Remove Item from Cart](#remove-item-from-cart)
5. [Clear Cart](#clear-cart)
6. [Apply Coupon](#apply-coupon)
7. [Remove Coupon](#remove-coupon)
8. [Get Shipping Methods](#get-shipping-methods)
9. [Select Shipping Method](#select-shipping-method)
10. [Checkout](#checkout)

## Get Cart

Retrieve the current user's shopping cart.

```http
GET /api/v1/cart
Authorization: Bearer <access_token>
```

### Response
```json
{
  "success": true,
  "data": {
    "id": "cart_123",
    "items": [
      {
        "id": "item_123",
        "product": {
          "id": "prod_123",
          "name": "Premium Headphones",
          "slug": "premium-headphones",
          "price": 299.99,
          "image": "https://example.com/images/headphones.jpg",
          "stock": 50
        },
        "quantity": 2,
        "price": 599.98,
        "discount": 0,
        "total": 599.98
      }
    ],
    "subtotal": 599.98,
    "discount": 0,
    "shipping": 0,
    "tax": 71.99,
    "total": 671.97,
    "coupon": null,
    "shippingMethod": null,
    "createdAt": "2023-10-21T10:00:00Z",
    "updatedAt": "2023-10-21T10:15:00Z"
  }
}
```

## Add Item to Cart

Add a product to the shopping cart.

```http
POST /api/v1/cart/items
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "productId": "prod_123",
  "quantity": 1
}
```

### Request Body
| Field     | Type    | Required | Description          |
|-----------|---------|----------|----------------------|
| productId | string  | Yes      | ID of the product to add |
| quantity  | integer | Yes      | Quantity to add (min: 1) |

### Response
```json
{
  "success": true,
  "data": {
    "id": "item_124",
    "product": {
      "id": "prod_123",
      "name": "Premium Headphones",
      "slug": "premium-headphones",
      "price": 299.99,
      "image": "https://example.com/images/headphones.jpg"
    },
    "quantity": 1,
    "price": 299.99,
    "total": 299.99
  }
}
```

## Update Cart Item

Update the quantity of an item in the cart.

```http
PATCH /api/v1/cart/items/item_123
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "quantity": 3
}
```

### Path Parameters
| Parameter | Type   | Required | Description        |
|-----------|--------|----------|--------------------|
| itemId    | string | Yes      | ID of the cart item |

### Request Body
| Field    | Type    | Required | Description          |
|----------|---------|----------|----------------------|
| quantity | integer | Yes      | New quantity (min: 1) |

### Response
```json
{
  "success": true,
  "data": {
    "id": "item_123",
    "quantity": 3,
    "price": 299.99,
    "total": 899.97
  }
}
```

## Remove Item from Cart

Remove an item from the shopping cart.

```http
DELETE /api/v1/cart/items/item_123
Authorization: Bearer <access_token>
```

### Path Parameters
| Parameter | Type   | Required | Description        |
|-----------|--------|----------|--------------------|
| itemId    | string | Yes      | ID of the cart item |

### Response
```json
{
  "success": true,
  "message": "Item removed from cart"
}
```

## Clear Cart

Remove all items from the shopping cart.

```http
DELETE /api/v1/cart/items
Authorization: Bearer <access_token>
```

### Response
```json
{
  "success": true,
  "message": "Cart cleared"
}
```

## Apply Coupon

Apply a discount coupon to the cart.

```http
POST /api/v1/cart/coupon
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "code": "SUMMER20"
}
```

### Request Body
| Field | Type   | Required | Description  |
|-------|--------|----------|--------------|
| code  | string | Yes      | Coupon code  |

### Response
```json
{
  "success": true,
  "data": {
    "coupon": {
      "code": "SUMMER20",
      "discountType": "percentage",
      "discountValue": 20,
      "discountAmount": 179.99
    },
    "subtotal": 899.97,
    "discount": 179.99,
    "total": 791.78
  }
}
```

## Remove Coupon

Remove the applied coupon from the cart.

```http
DELETE /api/v1/cart/coupon
Authorization: Bearer <access_token>
```

### Response
```json
{
  "success": true,
  "message": "Coupon removed",
  "data": {
    "subtotal": 899.97,
    "discount": 0,
    "total": 1079.96
  }
}
```

## Get Shipping Methods

Get available shipping methods for the current cart.

```http
GET /api/v1/cart/shipping-methods
Authorization: Bearer <access_token>
```

### Response
```json
{
  "success": true,
  "data": [
    {
      "id": "standard",
      "name": "Standard Shipping",
      "description": "3-5 business days",
      "price": 4.99,
      "estimatedDelivery": "Oct 25 - Oct 28"
    },
    {
      "id": "express",
      "name": "Express Shipping",
      "description": "1-2 business days",
      "price": 9.99,
      "estimatedDelivery": "Oct 23 - Oct 24"
    },
    {
      "id": "overnight",
      "name": "Overnight Shipping",
      "description": "Next business day",
      "price": 24.99,
      "estimatedDelivery": "Oct 22"
    }
  ]
}
```

## Select Shipping Method

Select a shipping method for the cart.

```http
POST /api/v1/cart/shipping
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "shippingMethodId": "express"
}
```

### Request Body
| Field           | Type   | Required | Description          |
|-----------------|--------|----------|----------------------|
| shippingMethodId| string | Yes      | ID of shipping method|

### Response
```json
{
  "success": true,
  "data": {
    "shippingMethod": {
      "id": "express",
      "name": "Express Shipping",
      "price": 9.99
    },
    "shipping": 9.99,
    "tax": 95.99,
    "total": 1085.95
  }
}
```

## Checkout

Proceed to checkout and create an order from the cart.

```http
POST /api/v1/cart/checkout
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "shippingAddress": {
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
  "billingAddressSameAsShipping": true,
  "paymentMethod": {
    "type": "credit_card",
    "card": {
      "number": "4242424242424242",
      "expMonth": 12,
      "expYear": 2025,
      "cvc": "123"
    }
  },
  "notes": "Leave at the front door"
}
```

### Request Body
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| shippingAddress | object | Yes | Shipping address details |
| billingAddressSameAsShipping | boolean | No | Whether to use shipping address for billing (default: true) |
| billingAddress | object | No | Billing address details (if different from shipping) |
| paymentMethod | object | Yes | Payment method details |
| notes | string | No | Order notes |

### Response
```json
{
  "success": true,
  "data": {
    "orderId": "order_123",
    "orderNumber": "ORD-20231021-123",
    "status": "processing",
    "total": 1085.95,
    "paymentStatus": "succeeded",
    "estimatedDelivery": "2023-10-24"
  }
}
```

## Error Responses

### Cart Empty
```json
{
  "success": false,
  "error": {
    "code": "CART_EMPTY",
    "message": "Cannot checkout with an empty cart"
  }
}
```

### Insufficient Stock
```json
{
  "success": false,
  "error": {
    "code": "INSUFFICIENT_STOCK",
    "message": "Not enough stock available for product 'Premium Headphones'",
    "productId": "prod_123",
    "available": 2,
    "requested": 3
  }
}
```

### Invalid Coupon
```json
{
  "success": false,
  "error": {
    "code": "INVALID_COUPON",
    "message": "The coupon code is invalid or has expired"
  }
}
```

### Shipping Required
```json
{
  "success": false,
  "error": {
    "code": "SHIPPING_REQUIRED",
    "message": "Please select a shipping method before checkout"
  }
}
```

## Best Practices
1. Always validate cart contents before checkout
2. Implement proper inventory management
3. Cache cart data with appropriate TTL
4. Implement proper error handling for out-of-stock items
5. Use transactions for cart updates to prevent race conditions
6. Implement proper security measures for payment processing
7. Log all cart activities for analytics and debugging

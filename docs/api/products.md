# Products API

This document describes the product-related endpoints for the Arnold Commerce API.

## Table of Contents
1. [List Products](#list-products)
2. [Get Product](#get-product)
3. [Create Product](#create-product)
4. [Update Product](#update-product)
5. [Delete Product](#delete-product)
6. [Search Products](#search-products)
7. [Product Categories](#product-categories)
8. [Product Reviews](#product-reviews)
9. [Product Images](#product-images)
10. [Inventory Management](#inventory-management)

## List Products

Retrieve a paginated list of products with optional filtering and sorting.

```http
GET /api/v1/products?page=1&limit=10&category=electronics&sort=-price
```

### Query Parameters
| Parameter | Type    | Required | Description                          |
|-----------|---------|----------|--------------------------------------|
| page      | integer | No       | Page number (default: 1)             |
| limit     | integer | No       | Items per page (default: 10, max: 100)|
| category  | string  | No       | Filter by category slug              |
| sort      | string  | No       | Sort field with optional - prefix for descending |
| inStock   | boolean | No       | Filter by in-stock status            |
| minPrice  | number  | No       | Minimum price filter                 |
| maxPrice  | number  | No       | Maximum price filter                 |
| q         | string  | No       | Search query                         |

### Response
```json
{
  "success": true,
  "data": [
    {
      "id": "prod_123",
      "name": "Premium Headphones",
      "slug": "premium-headphones",
      "description": "High-quality wireless headphones with noise cancellation",
      "price": 299.99,
      "originalPrice": 349.99,
      "discount": 50.00,
      "stock": 50,
      "images": [
        "https://example.com/images/headphones-1.jpg",
        "https://example.com/images/headphones-2.jpg"
      ],
      "category": {
        "id": "cat_123",
        "name": "Electronics",
        "slug": "electronics"
      },
      "rating": 4.5,
      "reviewCount": 128,
      "specifications": {
        "brand": "AudioPro",
        "color": "Black",
        "wireless": true,
        "batteryLife": "30 hours"
      },
      "createdAt": "2023-10-20T12:00:00Z",
      "updatedAt": "2023-10-20T12:00:00Z"
    }
  ],
  "meta": {
    "page": 1,
    "limit": 10,
    "total": 150,
    "totalPages": 15
  }
}
```

## Get Product

Retrieve a single product by ID or slug.

```http
GET /api/v1/products/prod_123
```

### Path Parameters
| Parameter | Type   | Required | Description          |
|-----------|--------|----------|----------------------|
| id        | string | Yes      | Product ID or slug   |

### Response
```json
{
  "success": true,
  "data": {
    "id": "prod_123",
    "name": "Premium Headphones",
    "slug": "premium-headphones",
    "description": "High-quality wireless headphones with noise cancellation",
    "price": 299.99,
    "originalPrice": 349.99,
    "discount": 50.00,
    "stock": 50,
    "images": [
      "https://example.com/images/headphones-1.jpg",
      "https://example.com/images/headphones-2.jpg"
    ],
    "category": {
      "id": "cat_123",
      "name": "Electronics",
      "slug": "electronics"
    },
    "relatedProducts": [
      {
        "id": "prod_124",
        "name": "Wireless Earbuds",
        "slug": "wireless-earbuds",
        "price": 149.99,
        "image": "https://example.com/images/earbuds.jpg"
      }
    ],
    "reviews": {
      "averageRating": 4.5,
      "count": 128,
      "ratings": {
        "5": 85,
        "4": 30,
        "3": 10,
        "2": 2,
        "1": 1
      }
    },
    "specifications": {
      "brand": "AudioPro",
      "color": "Black",
      "wireless": true,
      "batteryLife": "30 hours",
      "connectivity": "Bluetooth 5.0",
      "noiseCancellation": true,
      "weight": "250g"
    },
    "createdAt": "2023-10-20T12:00:00Z",
    "updatedAt": "2023-10-20T12:00:00Z"
  }
}
```

## Create Product

Create a new product. Requires admin privileges.

```http
POST /api/v1/products
Authorization: Bearer <admin_token>
Content-Type: application/json

{
  "name": "New Wireless Earbuds",
  "slug": "new-wireless-earbuds",
  "description": "Latest wireless earbuds with noise cancellation",
  "price": 199.99,
  "originalPrice": 249.99,
  "stock": 100,
  "categoryId": "cat_123",
  "specifications": {
    "brand": "AudioPro",
    "color": "White",
    "wireless": true,
    "batteryLife": "24 hours",
    "waterResistant": true
  }
}
```

### Request Body
| Field          | Type    | Required | Description                          |
|----------------|---------|----------|--------------------------------------|
| name           | string  | Yes      | Product name                         |
| slug           | string  | No       | URL-friendly slug (auto-generated if not provided) |
| description    | string  | Yes      | Product description                  |
| price          | number  | Yes      | Current selling price                |
| originalPrice  | number  | No       | Original price (for showing discounts) |
| stock          | integer | Yes      | Available quantity                   |
| categoryId     | string  | Yes      | ID of the product category           |
| specifications | object  | No       | Product specifications               |
| isActive       | boolean | No       | Whether the product is active (default: true) |

### Response
```json
{
  "success": true,
  "data": {
    "id": "prod_124",
    "name": "New Wireless Earbuds",
    "slug": "new-wireless-earbuds",
    "description": "Latest wireless earbuds with noise cancellation",
    "price": 199.99,
    "originalPrice": 249.99,
    "stock": 100,
    "categoryId": "cat_123",
    "isActive": true,
    "createdAt": "2023-10-21T10:00:00Z",
    "updatedAt": "2023-10-21T10:00:00Z"
  }
}
```

## Update Product

Update an existing product. Requires admin privileges.

```http
PATCH /api/v1/products/prod_124
Authorization: Bearer <admin_token>
Content-Type: application/json

{
  "price": 179.99,
  "stock": 85
}
```

### Path Parameters
| Parameter | Type   | Required | Description        |
|-----------|--------|----------|--------------------|
| id        | string | Yes      | Product ID or slug |

### Request Body
All fields are optional. Only included fields will be updated.

### Response
```json
{
  "success": true,
  "data": {
    "id": "prod_124",
    "name": "New Wireless Earbuds",
    "price": 179.99,
    "stock": 85,
    "updatedAt": "2023-10-21T11:30:00Z"
  }
}
```

## Delete Product

Delete a product. Requires admin privileges.

```http
DELETE /api/v1/products/prod_124
Authorization: Bearer <admin_token>
```

### Path Parameters
| Parameter | Type   | Required | Description        |
|-----------|--------|----------|--------------------|
| id        | string | Yes      | Product ID or slug |

### Response
```json
{
  "success": true,
  "message": "Product deleted successfully"
}
```

## Search Products

Search for products with full-text search.

```http
GET /api/v1/products/search?q=wireless+headphones&page=1&limit=10
```

### Query Parameters
| Parameter | Type    | Required | Description                          |
|-----------|---------|----------|--------------------------------------|
| q         | string  | Yes      | Search query                         |
| page      | integer | No       | Page number (default: 1)             |
| limit     | integer | No       | Items per page (default: 10, max: 50)|

### Response
Same format as [List Products](#list-products)

## Product Categories

### List Categories
```http
GET /api/v1/categories
```

### Get Category
```http
GET /api/v1/categories/electronics
```

### Create Category (Admin)
```http
POST /api/v1/categories
Authorization: Bearer <admin_token>
Content-Type: application/json

{
  "name": "Accessories",
  "description": "Phone and device accessories",
  "parentId": "cat_123"
}
```

## Product Reviews

### List Reviews
```http
GET /api/v1/products/prod_123/reviews
```

### Create Review
```http
POST /api/v1/products/prod_123/reviews
Authorization: Bearer <user_token>
Content-Type: application/json

{
  "rating": 5,
  "title": "Amazing product!",
  "comment": "These headphones are worth every penny. The sound quality is exceptional.",
  "images": ["https://example.com/review1.jpg"]
}
```

## Product Images

### Upload Image
```http
POST /api/v1/products/prod_123/images
Authorization: Bearer <admin_token>
Content-Type: multipart/form-data

// Form data with file upload
```

### Reorder Images
```http
PATCH /api/v1/products/prod_123/images/order
Authorization: Bearer <admin_token>
Content-Type: application/json

{
  "imageIds": ["img_2", "img_1", "img_3"]
}
```

## Inventory Management

### Update Stock
```http
PATCH /api/v1/products/prod_123/stock
Authorization: Bearer <admin_token>
Content-Type: application/json

{
  "quantity": 10,
  "operation": "increment" // or "decrement", "set"
}
```

### Get Inventory History
```http
GET /api/v1/products/prod_123/inventory-history
Authorization: Bearer <admin_token>
```

## Error Responses

### Product Not Found
```json
{
  "success": false,
  "error": {
    "code": "PRODUCT_NOT_FOUND",
    "message": "Product not found"
  }
}
```

### Insufficient Stock
```json
{
  "success": false,
  "error": {
    "code": "INSUFFICIENT_STOCK",
    "message": "Not enough stock available",
    "available": 5,
    "requested": 10
  }
}
```

### Validation Error
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": [
      {
        "field": "price",
        "message": "Price must be a positive number"
      },
      {
        "field": "categoryId",
        "message": "Category does not exist"
      }
    ]
  }
}
```

## Best Practices
1. Use pagination for large product catalogs
2. Cache product listings with appropriate TTL
3. Implement proper input validation
4. Use proper HTTP status codes
5. Implement rate limiting
6. Use proper indexing for search and filter operations
7. Implement proper error handling and logging

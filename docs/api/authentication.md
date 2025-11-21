# Authentication API

This document describes the authentication endpoints for the Arnold Commerce API.

## Table of Contents
1. [Login](#login)
2. [Register](#register)
3. [Refresh Token](#refresh-token)
4. [Logout](#logout)
5. [Forgot Password](#forgot-password)
6. [Reset Password](#reset-password)
7. [Email Verification](#email-verification)
8. [Social Authentication](#social-authentication)
9. [Two-Factor Authentication](#two-factor-authentication)
10. [API Keys](#api-keys)

## Login

Authenticate a user and retrieve access and refresh tokens.

```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "securepassword123"
}
```

### Request Body
| Field    | Type   | Required | Description          |
|----------|--------|----------|----------------------|
| email    | string | Yes      | User's email address |
| password | string | Yes      | User's password      |

### Response
```json
{
  "success": true,
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresIn": 3600,
    "user": {
      "id": "user_123",
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "role": "CUSTOMER"
    }
  }
}
```

## Register

Create a new user account.

```http
POST /api/v1/auth/register
Content-Type: application/json

{
  "email": "newuser@example.com",
  "password": "securepassword123",
  "firstName": "John",
  "lastName": "Doe"
}
```

### Request Body
| Field     | Type   | Required | Description              |
|-----------|--------|----------|--------------------------|
| email     | string | Yes      | User's email address     |
| password  | string | Yes      | User's password          |
| firstName | string | Yes      | User's first name        |
| lastName  | string | Yes      | User's last name         |

### Response
```json
{
  "success": true,
  "data": {
    "id": "user_123",
    "email": "newuser@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "emailVerified": false
  }
}
```

## Refresh Token

Refresh an expired access token using a refresh token.

```http
POST /api/v1/auth/refresh-token
Content-Type: application/json

{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### Request Body
| Field        | Type   | Required | Description           |
|--------------|--------|----------|-----------------------|
| refreshToken | string | Yes      | Valid refresh token   |

### Response
```json
{
  "success": true,
  "data": {
    "accessToken": "new_access_token_here",
    "refreshToken": "new_refresh_token_here",
    "expiresIn": 3600
  }
}
```

## Logout

Invalidate the current user's session.

```http
POST /api/v1/auth/logout
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### Request Body
| Field        | Type   | Required | Description           |
|--------------|--------|----------|-----------------------|
| refreshToken | string | Yes      | Refresh token to revoke |

### Response
```json
{
  "success": true
}
```

## Forgot Password

Request a password reset email.

```http
POST /api/v1/auth/forgot-password
Content-Type: application/json

{
  "email": "user@example.com"
}
```

### Request Body
| Field | Type   | Required | Description          |
|-------|--------|----------|----------------------|
| email | string | Yes      | User's email address |

### Response
```json
{
  "success": true,
  "message": "Password reset email sent"
}
```

## Reset Password

Reset user's password using a token from the reset email.

```http
POST /api/v1/auth/reset-password
Content-Type: application/json

{
  "token": "reset_token_here",
  "password": "new_secure_password",
  "confirmPassword": "new_secure_password"
}
```

### Request Body
| Field          | Type   | Required | Description                |
|----------------|--------|----------|----------------------------|
| token          | string | Yes      | Password reset token        |
| password       | string | Yes      | New password               |
| confirmPassword| string | Yes      | Confirm new password        |

### Response
```json
{
  "success": true,
  "message": "Password reset successful"
}
```

## Email Verification

Verify user's email address.

```http
GET /api/v1/auth/verify-email?token=verification_token_here
```

### Query Parameters
| Parameter | Type   | Required | Description          |
|-----------|--------|----------|----------------------|
| token     | string | Yes      | Email verification token |

### Response
```json
{
  "success": true,
  "message": "Email verified successfully"
}
```

## Social Authentication

Authenticate using social providers (OAuth 2.0).

### Available Providers
- Google
- Facebook
- GitHub
- Apple

```http
GET /api/v1/auth/{provider}
```

### Response
Redirects to the provider's authentication page.

## Two-Factor Authentication

Enable, disable, or verify two-factor authentication.

### Enable 2FA
```http
POST /api/v1/auth/two-factor/setup
Authorization: Bearer <access_token>
```

### Verify 2FA Setup
```http
POST /api/v1/auth/two-factor/verify
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "code": "123456"
}
```

### Login with 2FA
```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "securepassword123",
  "code": "123456"
}
```

## API Keys

Manage API keys for programmatic access.

### Create API Key
```http
POST /api/v1/auth/api-keys
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "name": "Production Key",
  "permissions": ["read:products", "write:products"]
}
```

### List API Keys
```http
GET /api/v1/auth/api-keys
Authorization: Bearer <access_token>
```

### Revoke API Key
```http
DELETE /api/v1/auth/api-keys/{keyId}
Authorization: Bearer <access_token>
```

## Error Responses

### Invalid Credentials
```json
{
  "success": false,
  "error": {
    "code": "INVALID_CREDENTIALS",
    "message": "Invalid email or password"
  }
}
```

### Token Expired
```json
{
  "success": false,
  "error": {
    "code": "TOKEN_EXPIRED",
    "message": "Token has expired"
  }
}
```

### Rate Limited
```json
{
  "success": false,
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Too many requests, please try again later"
  }
}
```

## Security Considerations

- All authentication endpoints use HTTPS
- Passwords are hashed using bcrypt
- Access tokens expire after 1 hour
- Refresh tokens are single-use and rotated on each refresh
- Rate limiting is enforced on all authentication endpoints
- Failed login attempts are rate-limited to prevent brute force attacks

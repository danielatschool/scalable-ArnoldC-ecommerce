# Authentication Guide

This guide explains how authentication works in Arnold Commerce and how to implement it in your application.

## Table of Contents
1. [Authentication Flow](#authentication-flow)
2. [JWT Authentication](#jwt-authentication)
3. [Social Authentication](#social-authentication)
4. [Two-Factor Authentication](#two-factor-authentication)
5. [Password Reset](#password-reset)
6. [Email Verification](#email-verification)
7. [API Authentication](#api-authentication)
8. [Session Management](#session-management)
9. [Security Best Practices](#security-best-practices)
10. [Troubleshooting](#troubleshooting)

## Authentication Flow

Arnold Commerce uses a JWT (JSON Web Token) based authentication system. Here's the typical flow:

1. User submits login credentials (email/password or social provider)
2. Server validates credentials
3. If valid, server issues a JWT access token and refresh token
4. Client stores tokens securely (HTTP-only cookie recommended)
5. Client includes the access token in subsequent requests
6. Server verifies the token on protected routes
7. When access token expires, client uses refresh token to get a new one

## JWT Authentication

### Login

```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "securePassword123"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "user_123",
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "role": "customer"
    },
    "tokens": {
      "access": {
        "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
        "expires": "2023-11-21T12:00:00.000Z"
      },
      "refresh": {
        "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
        "expires": "2023-12-21T12:00:00.000Z"
      }
    }
  }
}
```

### Token Refresh

```http
POST /api/v1/auth/refresh-token
Content-Type: application/json

{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "access": {
      "token": "new_access_token_here",
      "expires": "2023-11-21T14:00:00.000Z"
    }
  }
}
```

## Social Authentication

Arnold Commerce supports authentication with various social providers:

- Google
- Facebook
- GitHub
- Apple

### Initiating Social Login

1. Redirect user to the provider's authentication page:
   ```
   GET /api/v1/auth/google
   GET /api/v1/auth/facebook
   GET /api/v1/auth/github
   GET /api/v1/auth/apple
   ```

2. After successful authentication, the provider will redirect back to your callback URL with an authorization code

3. Exchange the code for tokens:
   ```
   POST /api/v1/auth/{provider}/callback
   ```

### Social Login Configuration

1. **Google**
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project
   - Enable Google+ API
   - Create OAuth 2.0 credentials
   - Add authorized redirect URIs

2. **Facebook**
   - Go to [Facebook Developers](https://developers.facebook.com/)
   - Create a new app
   - Enable Facebook Login
   - Configure Valid OAuth Redirect URIs

3. **GitHub**
   - Go to [GitHub Developer Settings](https://github.com/settings/developers)
   - Create a new OAuth App
   - Set Authorization callback URL

4. **Apple**
   - Go to [Apple Developer](https://developer.apple.com/)
   - Create a new App ID
   - Enable Sign In with Apple
   - Configure return URLs

## Two-Factor Authentication

### Enabling 2FA

1. Generate a secret:
   ```http
   POST /api/v1/auth/2fa/setup
   Authorization: Bearer <access_token>
   ```

   **Response:**
   ```json
   {
     "secret": "JBSWY3DPEHPK3PXP",
     "otpauthUrl": "otpauth://totp/Arnold%20Commerce:user%40example.com?secret=JBSWY3DPEHPK3PXP&issuer=Arnold%20Commerce"
   }
   ```

2. User scans the QR code with an authenticator app

3. Verify the setup:
   ```http
   POST /api/v1/auth/2fa/verify
   Authorization: Bearer <access_token>
   Content-Type: application/json

   {
     "token": "123456"
   }
   ```

### Logging in with 2FA

1. Submit regular credentials
2. If 2FA is enabled, you'll receive a `requires2FA: true` response
3. Submit the 2FA token:
   ```http
   POST /api/v1/auth/2fa/login
   Content-Type: application/json

   {
     "email": "user@example.com",
     "password": "securePassword123",
     "token": "123456"
   }
   ```

## Password Reset

### Request Password Reset

```http
POST /api/v1/auth/forgot-password
Content-Type: application/json

{
  "email": "user@example.com"
}
```

### Reset Password

```http
POST /api/v1/auth/reset-password
Content-Type: application/json

{
  "token": "reset_token_from_email",
  "password": "newSecurePassword123",
  "confirmPassword": "newSecurePassword123"
}
```

## Email Verification

### Send Verification Email

```http
POST /api/v1/auth/send-verification-email
Authorization: Bearer <access_token>
```

### Verify Email

```http
POST /api/v1/auth/verify-email
Content-Type: application/json

{
  "token": "verification_token_from_email"
}
```

## API Authentication

### Making Authenticated Requests

Include the access token in the `Authorization` header:

```http
GET /api/v1/users/me
Authorization: Bearer <access_token>
```

### Required Headers

For API requests that include a body (POST, PUT, PATCH), include:

```
Content-Type: application/json
Accept: application/json
```

## Session Management

### Active Sessions

View and manage active sessions:

```http
GET /api/v1/auth/sessions
Authorization: Bearer <access_token>
```

### Revoke Session

```http
DELETE /api/v1/auth/sessions/:sessionId
Authorization: Bearer <access_token>
```

### Logout

```http
POST /api/v1/auth/logout
Authorization: Bearer <access_token>
```

## Security Best Practices

1. **Password Security**
   - Use strong, unique passwords
   - Enforce password complexity requirements
   - Implement password hashing (bcrypt recommended)
   - Enforce password rotation policies

2. **Token Security**
   - Use short-lived access tokens (15-30 minutes)
   - Use secure, HTTP-only cookies for token storage
   - Implement proper CORS policies
   - Use secure and same-site cookie attributes

3. **Rate Limiting**
   ```javascript
   // Example rate limiting configuration
   const rateLimit = require('express-rate-limit');

   const authLimiter = rateLimit({
     windowMs: 15 * 60 * 1000, // 15 minutes
     max: 10, // limit each IP to 10 requests per windowMs
     message: 'Too many login attempts, please try again later.'
   });

   app.use('/api/v1/auth/login', authLimiter);
   ```

4. **Security Headers**
   - Implement Content Security Policy (CSP)
   - Use HSTS
   - Enable XSS protection
   - Prevent MIME type sniffing
   - Frame options to prevent clickjacking

## Troubleshooting

### Common Issues

1. **Invalid Token**
   - Check if the token is expired
   - Verify the token signature
   - Ensure the token is being sent correctly in the header

2. **CSRF Token Mismatch**
   - Ensure CSRF tokens are being generated and validated
   - Check if the token is being sent in the correct header

3. **CORS Issues**
   - Verify CORS configuration
   - Check allowed origins, methods, and headers

4. **Rate Limiting**
   - Check if you've exceeded the rate limit
   - Implement exponential backoff for retries

### Getting Help

If you encounter any issues with authentication:

1. Check the API documentation for the specific endpoint
2. Verify your implementation against the examples
3. Check the server logs for error messages
4. Contact support with the following information:
   - Request/response details
   - Error messages
   - Steps to reproduce the issue
   - Environment details (browser, OS, etc.)

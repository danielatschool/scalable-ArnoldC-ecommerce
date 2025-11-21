# Getting Started with Arnold Commerce

Welcome to Arnold Commerce! This guide will help you set up and start using the e-commerce platform.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Configuration](#configuration)
4. [Running the Application](#running-the-application)
5. [Development Workflow](#development-workflow)
6. [Testing](#testing)
7. [Deployment](#deployment)
8. [Troubleshooting](#troubleshooting)
9. [Next Steps](#next-steps)

## Prerequisites

Before you begin, ensure you have the following installed:

- Node.js 18.0.0 or later
- npm 9.0.0 or later (comes with Node.js)
- PostgreSQL 14.0 or later
- Redis 6.0 or later (for caching and sessions)
- Git (for version control)

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-org/arnold-commerce.git
   cd arnold-commerce
   ```

2. **Install dependencies**:
   ```bash
   # Install root dependencies
   npm install
   
   # Install frontend dependencies
   cd frontend
   npm install
   
   # Install backend dependencies
   cd ../backend
   npm install
   ```

3. **Set up environment variables**:
   ```bash
   # Create .env files from examples
   cp .env.example .env
   cd frontend && cp .env.example .env && cd ..
   cd backend && cp .env.example .env && cd ..
   ```

## Configuration

### Backend Configuration
Edit `backend/.env` with your configuration:

```env
# Server
NODE_ENV=development
PORT=5000

# Database
DATABASE_URL=postgresql://username:password@localhost:5432/arnold_commerce

# JWT
JWT_SECRET=your_jwt_secret
JWT_EXPIRES_IN=1d

# Redis
REDIS_URL=redis://localhost:6379

# Email (SMTP)
SMTP_HOST=smtp.example.com
SMTP_PORT=587
SMTP_USER=your_email@example.com
SMTP_PASS=your_email_password
SMTP_FROM="Arnold Commerce <noreply@arnoldcommerce.com>"

# Storage (AWS S3)
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
AWS_REGION=us-east-1
AWS_BUCKET_NAME=arnold-commerce

# Payment Gateway (Stripe)
STRIPE_SECRET_KEY=your_stripe_secret_key
STRIPE_WEBHOOK_SECRET=your_stripe_webhook_secret

# Frontend URL (for CORS and email links)
FRONTEND_URL=http://localhost:3000
```

### Frontend Configuration
Edit `frontend/.env` with your configuration:

```env
NEXT_PUBLIC_API_URL=http://localhost:5000/api
NEXT_PUBLIC_GA_MEASUREMENT_ID=G-XXXXXXXXXX
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_xxxxxxxxxxxxxxxxxxxxxxxx
```

### Database Setup

1. Create a new PostgreSQL database:
   ```bash
   createdb arnold_commerce
   ```

2. Run database migrations:
   ```bash
   cd backend
   npx prisma migrate dev --name init
   ```

3. Seed the database with initial data (optional):
   ```bash
   npx prisma db seed
   ```

## Running the Application

### Development Mode

1. Start the backend server:
   ```bash
   cd backend
   npm run dev
   ```

2. Start the frontend development server (in a new terminal):
   ```bash
   cd frontend
   npm run dev
   ```

3. Access the application at [http://localhost:3000](http://localhost:3000)

### Production Mode

1. Build the application:
   ```bash
   # Build frontend
   cd frontend
   npm run build
   
   # Build backend
   cd ../backend
   npm run build
   ```

2. Start the production server:
   ```bash
   cd backend
   npm start
   ```

## Development Workflow

### Git Workflow

1. Create a new branch for your feature or bugfix:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes and commit them:
   ```bash
   git add .
   git commit -m "Add your commit message here"
   ```

3. Push your changes to the remote repository:
   ```bash
   git push origin feature/your-feature-name
   ```

4. Create a pull request on GitHub

### Code Style

We use ESLint and Prettier for code formatting. Run the following commands to ensure your code follows our style guide:

```bash
# Check for linting errors
npm run lint

# Automatically fix linting issues
npm run lint:fix

# Format code with Prettier
npm run format
```

## Testing

### Running Tests

```bash
# Run all tests
npm test

# Run unit tests
npm run test:unit

# Run integration tests
npm run test:integration

# Run end-to-end tests
npm run test:e2e

# Generate test coverage report
npm run test:coverage
```

### Writing Tests

- Unit tests should be placed in the `__tests__` directory next to the code they test
- Test files should be named `*.test.js` or `*.spec.js`
- Use `describe` and `it` blocks to organize your tests
- Follow the AAA pattern (Arrange, Act, Assert)

## Deployment

### Prerequisites

- Docker and Docker Compose
- A server with at least 2GB RAM
- Domain name with SSL certificate (recommended)

### Docker Deployment

1. Build and start the containers:
   ```bash
   docker-compose -f docker-compose.prod.yml up --build -d
   ```

2. Run database migrations:
   ```bash
   docker-compose -f docker-compose.prod.yml exec backend npx prisma migrate deploy
   ```

3. Check the logs:
   ```bash
   docker-compose -f docker-compose.prod.yml logs -f
   ```

### Manual Deployment

1. Set up a reverse proxy (Nginx or Apache)
2. Configure environment variables
3. Build the application
4. Use PM2 to run the Node.js process:
   ```bash
   npm install -g pm2
   pm2 start dist/main.js --name "arnold-commerce"
   pm2 save
   pm2 startup
   ```

## Troubleshooting

### Common Issues

1. **Database connection issues**
   - Verify your database credentials in `.env`
   - Ensure PostgreSQL is running
   - Check if the database exists and is accessible

2. **Port already in use**
   - Change the port in `.env`
   - Or kill the process using the port:
     ```bash
     lsof -i :3000
     kill -9 <PID>
     ```

3. **Missing environment variables**
   - Ensure all required environment variables are set
   - Check `.env.example` for reference

### Getting Help

If you encounter any issues, please:
1. Check the [GitHub Issues](https://github.com/your-org/arnold-commerce/issues) for similar problems
2. Search the [documentation](https://docs.arnoldcommerce.com)
3. Join our [community forum](https://community.arnoldcommerce.com)
4. Contact support at support@arnoldcommerce.com

## Next Steps

- [API Documentation](/api)
- [Architecture Overview](/architecture)
- [Contribution Guidelines](/CONTRIBUTING.md)
- [Changelog](/CHANGELOG.md)

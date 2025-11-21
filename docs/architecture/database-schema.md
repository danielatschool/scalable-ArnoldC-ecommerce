# Database Schema

This document outlines the database schema for Arnold Commerce, including all tables, relationships, and key constraints.

## Core Tables

### 1. Users
```prisma
model User {
  id                String    @id @default(uuid())
  email             String    @unique
  passwordHash      String
  firstName         String
  lastName          String
  role              UserRole  @default(CUSTOMER)
  emailVerified     Boolean   @default(false)
  verificationToken String?
  resetToken        String?
  resetTokenExpiry  DateTime?
  createdAt         DateTime  @default(now())
  updatedAt         DateTime  @updatedAt
  
  // Relations
  addresses        Address[]
  orders           Order[]
  reviews          Review[]
  cart             Cart?
}

enum UserRole {
  ADMIN
  CUSTOMER
  MANAGER
}
```

### 2. Products
```prisma
model Product {
  id          String     @id @default(uuid())
  name        String
  slug        String     @unique
  description String     @db.Text
  price       Decimal    @db.Decimal(10, 2)
  sku         String     @unique
  stock       Int        @default(0)
  isActive    Boolean    @default(true)
  images      String[]
  categoryId  String
  category    Category   @relation(fields: [categoryId], references: [id])
  attributes  Json?      // For product variations
  
  // Relations
  reviews     Review[]
  cartItems   CartItem[]
  orderItems  OrderItem[]
  
  // Timestamps
  createdAt   DateTime   @default(now())
  updatedAt   DateTime   @updatedAt
}
```

### 3. Categories
```prisma
model Category {
  id          String    @id @default(uuid())
  name        String    @unique
  slug        String    @unique
  description String?
  parentId    String?
  parent      Category? @relation("CategoryToCategory", fields: [parentId], references: [id])
  children    Category[] @relation("CategoryToCategory")
  products    Product[]
  
  // Timestamps
  createdAt   DateTime  @default(now())
  updatedAt   DateTime  @updatedAt
}
```

### 4. Cart
```prisma
model Cart {
  id        String    @id @default(uuid())
  userId    String    @unique
  user      User      @relation(fields: [userId], references: [id])
  items     CartItem[]
  
  // Timestamps
  createdAt DateTime  @default(now())
  updatedAt DateTime  @updatedAt
}

model CartItem {
  id        String   @id @default(uuid())
  cartId    String
  cart      Cart     @relation(fields: [cartId], references: [id])
  productId String
  product   Product  @relation(fields: [productId], references: [id])
  quantity  Int      @default(1)
  
  // Timestamps
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}
```

### 5. Orders
```prisma
model Order {
  id           String      @id @default(uuid())
  orderNumber  String      @unique
  userId       String
  user         User        @relation(fields: [userId], references: [id])
  status       OrderStatus @default(PENDING)
  total        Decimal     @db.Decimal(10, 2)
  subtotal     Decimal     @db.Decimal(10, 2)
  tax          Decimal     @db.Decimal(10, 2)
  shipping     Decimal     @db.Decimal(10, 2)
  
  // Billing/Shipping info
  shippingAddress  Json
  billingAddress   Json
  
  // Relations
  items       OrderItem[]
  
  // Timestamps
  createdAt   DateTime    @default(now())
  updatedAt   DateTime    @updatedAt
}

model OrderItem {
  id          String   @id @default(uuid())
  orderId     String
  order       Order    @relation(fields: [orderId], references: [id])
  productId   String
  productName String
  product     Product  @relation(fields: [productId], references: [id])
  price       Decimal  @db.Decimal(10, 2)
  quantity    Int
  
  // Timestamps
  createdAt   DateTime @default(now())
}

enum OrderStatus {
  PENDING
  PROCESSING
  SHIPPED
  DELIVERED
  CANCELLED
  REFUNDED
}
```

## Indexes

```prisma
// User indexes
@@index([email])

// Product indexes
@@index([name])
@@index([categoryId])
@@index([price])

// Order indexes
@@index([userId])
@@index([status])
@@index([createdAt])
```

## Database Migrations

To create and apply migrations:

```bash
# Generate a new migration
npx prisma migrate dev --name init

# Apply pending migrations
npx prisma migrate deploy
```

## Seeding the Database

To seed the database with initial data:

```bash
npx ts-node prisma/seed.ts
```

## Backup and Recovery

### Backup
```bash
pg_dump -U username -d database_name > backup.sql
```

### Restore
```bash
psql -U username -d database_name < backup.sql
```

## Performance Considerations

1. **Indexing**: All foreign keys and frequently queried columns are indexed
2. **Partitioning**: Large tables like orders can be partitioned by date
3. **Connection Pooling**: Using Prisma's built-in connection pooling
4. **Caching**: Heavily used data is cached in Redis

-- SQL Migration for Supabase
-- Run this in your Supabase SQL Editor

-- Create enum for Issue status
CREATE TYPE "Status" AS ENUM ('OPEN', 'IN_PROGRESS', 'CLOSED');

-- Create User table
CREATE TABLE "User" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    name TEXT,
    email TEXT UNIQUE,
    "emailVerified" TIMESTAMP(3),
    image TEXT
);

-- Create Account table (NextAuth)
CREATE TABLE "Account" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    "userId" TEXT NOT NULL,
    type TEXT NOT NULL,
    provider TEXT NOT NULL,
    "providerAccountId" TEXT NOT NULL,
    refresh_token TEXT,
    access_token TEXT,
    expires_at INTEGER,
    token_type TEXT,
    scope TEXT,
    id_token TEXT,
    session_state TEXT,
    CONSTRAINT "Account_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"(id) ON DELETE CASCADE
);

-- Create Session table (NextAuth)
CREATE TABLE "Session" (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    "sessionToken" TEXT UNIQUE NOT NULL,
    "userId" TEXT NOT NULL,
    expires TIMESTAMP(3) NOT NULL,
    CONSTRAINT "Session_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"(id) ON DELETE CASCADE
);

-- Create VerificationToken table (NextAuth)
CREATE TABLE "VerificationToken" (
    identifier TEXT NOT NULL,
    token TEXT UNIQUE NOT NULL,
    expires TIMESTAMP(3) NOT NULL
);

-- Create Issue table
CREATE TABLE "Issue" (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    status "Status" NOT NULL DEFAULT 'OPEN',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "assignedToUserId" VARCHAR(255),
    CONSTRAINT "Issue_assignedToUserId_fkey" FOREIGN KEY ("assignedToUserId") REFERENCES "User"(id)
);

-- Create unique constraints
CREATE UNIQUE INDEX "Account_provider_providerAccountId_key" ON "Account"(provider, "providerAccountId");
CREATE UNIQUE INDEX "VerificationToken_identifier_token_key" ON "VerificationToken"(identifier, token);

-- Create function to update updatedAt timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW."updatedAt" = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for Issue table
CREATE TRIGGER update_issue_updated_at
    BEFORE UPDATE ON "Issue"
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

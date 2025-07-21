# 💊 Supplement Tracker

A modern web application to track and manage daily supplement intake with reminders, progress tracking, and analytics.

## 🏗️ Architecture

This is a **monorepo** built with modern TypeScript technologies:

- **Frontend**: Next.js 15 with App Router, React 19, TypeScript
- **Backend**: Fastify API with TypeScript
- **Database**: PostgreSQL with Prisma ORM
- **Styling**: TailwindCSS v4 + shadcn/ui components
- **Package Manager**: pnpm with workspaces
- **Build System**: Turborepo

## 📁 Project Structure

```
supplement-tracker/
├── apps/
│   ├── web/          # Next.js frontend application
│   └── api/          # Fastify backend API
├── packages/
│   └── db/           # Shared database package
├── package.json      # Root workspace configuration
├── pnpm-workspace.yaml
└── turbo.json        # Turborepo configuration
```

## 🚀 Getting Started

### Prerequisites

- **Node.js** >= 18.17
- **pnpm** >= 9.15.1
- **PostgreSQL** database

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd supplement-tracker
   ```

2. **Install dependencies**

   ```bash
   pnpm install
   ```

3. **Set up environment variables**

   ```bash
   # In packages/db/.env
   DATABASE_URL="postgresql://username:password@localhost:5432/supplement_tracker"
   ```

4. **Set up the database**

   ```bash
   cd packages/db
   npx prisma migrate dev
   npx prisma generate
   ```

5. **Start the development servers**
   ```bash
   # From root directory - starts both web and api
   pnpm dev
   ```

The applications will be available at:

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:3001

## 🛠️ Development

### Available Scripts

| Command            | Description                                |
| ------------------ | ------------------------------------------ |
| `pnpm dev`         | Start all applications in development mode |
| `pnpm build`       | Build all applications for production      |
| `pnpm check-types` | Run TypeScript type checking               |

### Individual App Commands

**Web App** (`apps/web/`):

```bash
pnpm dev          # Start Next.js dev server (with Turbopack)
pnpm build        # Build for production
pnpm start        # Start production server
pnpm lint         # Run ESLint
pnpm check-types  # TypeScript type checking
```

**API** (`apps/api/`):

```bash
pnpm dev     # Start Fastify dev server with tsx watch
pnpm build   # Compile TypeScript
pnpm start   # Start production server
```

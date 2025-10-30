@echo off
setlocal

echo ========================================
echo Starting NOF1.AI Application
@echo off
setlocal

echo ========================================
echo Starting NOF1.AI Application
echo ========================================
echo.

REM Check if .env.local exists
if not exist .env.local (
    echo [ERROR] .env.local file not found!
    echo Please create .env.local file. See env-setup.txt for details.
    echo.
    pause
    exit /b 1
)

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo [WARNING] Docker is not running!
    echo Please start Docker Desktop first.
    echo.
    echo After starting Docker, run this script again.
    echo.
    pause
    exit /b 1
)

REM Start PostgreSQL database
echo [1/5] Starting PostgreSQL database...
docker compose up -d postgres
if errorlevel 1 (
    echo [ERROR] Failed to start PostgreSQL!
    pause
    exit /b 1
)

REM Wait for database to be ready
echo [2/5] Waiting for database to be ready...
timeout /t 15 /nobreak >nul

REM Generate Prisma Client
echo [3/5] Generating Prisma Client...
call npm run db:generate
if errorlevel 1 (
    echo [ERROR] Failed to generate Prisma Client!
    pause
    exit /b 1
)

REM Push database schema
echo [4/5] Pushing database schema...
call npm run devb:push
if errorlevel 1 (
    echo [ERROR] Failed to push database schema!
    pause
    exit /b 1
)

echo.
echo [5/5] Starting Next.js application...
echo ========================================
echo Application will start at http://localhost:3000
echo ========================================
echo.
call npm run dev

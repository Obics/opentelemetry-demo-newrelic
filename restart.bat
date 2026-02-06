@echo off
REM -----------------------------------------------------------------------------
REM restart.bat
REM
REM Purpose:
REM   Stops all containers and then restarts the OpenTelemetry Demo using Docker Compose.
REM
REM How to run:
REM   restart.bat
REM   (Run from the project root directory)
REM
REM Dependencies:
REM   - Docker Desktop
REM   - Docker Compose v2+
REM   - .env and .env.override files in the project root
REM   - NEW_RELIC_LICENSE_KEY (set in .env file)
REM -----------------------------------------------------------------------------

echo Restarting OpenTelemetry Demo...
echo.

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo Error: Docker is not running or not installed.
    echo Please start Docker Desktop and try again.
    exit /b 1
)

echo Stopping all containers...
docker compose --env-file .env --env-file .env.override --file newrelic/docker/docker-compose.yml down

if errorlevel 1 (
    echo.
    echo Error: Failed to stop containers.
    exit /b 1
)

echo.
echo Containers stopped successfully!
echo.
echo Starting containers...
echo.

REM Run docker compose
docker compose --env-file .env --env-file .env.override --file newrelic/docker/docker-compose.yml up --force-recreate --remove-orphans --detach

if errorlevel 1 (
    echo.
    echo Error: Docker Compose deployment failed.
    echo Possible reasons:
    echo   - Environment files not found
    echo   - Docker Compose configuration issue
    echo   - Insufficient permissions
    echo   - Docker daemon not running
    exit /b 1
)

echo.
echo Docker Compose restart successful!
echo.

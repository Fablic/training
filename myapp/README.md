# MyApp

This README documents the steps necessary to get the application up and running.

## Ruby Version

- Ruby 2.6.10

## System Dependencies

- Docker
- Docker Compose

## Configuration

1. **Navigate to the working directory**
    ```sh
    cd myapp
    ```

2. **Add your name to `.env`**
    ```yml
    COMPOSE_PROJECT_NAME=xxx-training
    ```

## Database Creation

- The database will be created automatically during the Docker setup process. Ensure the following settings are included in your `config/database.yml` file:
    ```yml
    default: &default
      adapter: mysql2
      encoding: utf8mb4
      charset: utf8mb4
      collation: utf8mb4_general_ci
      pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
      database: <%= ENV['DB_NAME'] %>
      username: <%= ENV['DB_USER'] %>
      password: <%= ENV['DB_PASSWORD'] %>
      host: <%= ENV['DB_HOST'] %>
    ```

## Database Initialization

1. **Build and start the application with Docker**
    ```sh
    docker-compose up --build
    ```

2. **Migrate the database**
    ```sh
    docker-compose run api rails db:create db:migrate
    ```

## How to Run the Test Suite

- Run the tests with RSpec (if RSpec is configured)
    ```sh
    docker-compose run api rspec
    ```

## Services (job queues, cache servers, search engines, etc.)

- None configured at this time.

## Deployment Instructions

- Ensure Docker is installed on the deployment server.
- Follow the same steps for configuration and initialization as mentioned above.

## Additional Notes

- Access the application at `http://localhost:3001`.
- Ensure all environment variables are set in the `.env` file for a successful setup.
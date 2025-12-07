# Flyway PostgreSQL PoC

This project is a proof-of-concept (PoC) demonstrating how to use [Flyway](https://flywaydb.org/) to manage and version a PostgreSQL database schema.

It uses Docker to run a PostgreSQL container and a `Makefile` to simplify common tasks.

## What's in the box?

- `docker-compose.yml`: Defines the PostgreSQL service.
- `flyway.conf`: Configuration file for Flyway.
- `Makefile`: Provides commands to manage the database lifecycle.
- `sql/`: Contains the SQL migration scripts.

## Prerequisites

- [Docker](https://docs.docker.com/engine/install/ubuntu/#prerequisites)
- [Flyway](https://www.red-gate.com/products/flyway/community/download/)


## Getting Started

1.  **Create a `.env` file** with the following content:

    ```env
    POSTGRES_USER=flywayuser
    POSTGRES_PASSWORD=flywaypass
    POSTGRES_DB=flyway_poc
    PGHOST=localhost
    PGPORT=5431
    PGDATABASE=flyway_poc
    PGUSER=flywayuser
    PGPASSWORD=flywaypass
    ```

2.  **Start the PostgreSQL container:**

    ```sh
    make up
    ```

3.  **Run the database migrations:**

    ```sh
    make migrate
    ```

## Usage

The `Makefile` provides several commands to interact with the database:

| Command | Description |
| :--- | :--- |
| `make up` | Start the PostgreSQL container. |
| `make down` | Stop the container (data is preserved). |
| `make reset` | **Destroy the container and all data.** |
| `make migrate` | Apply pending database migrations. |
| `make history` | Show the Flyway schema history. |
| `make inspect` | Inspect the database objects created by the migrations. |
| `make test` | Run a quick functional test. |
| `make reset-users` | Call a stored procedure to delete all users. |
| `make psql` | Open an interactive `psql` shell. |

## Database Schema

The migrations in the `sql/` directory will create the following database objects in the `app` schema:

- **`users` table:** Stores user information.
- **`users_id_seq` sequence:** Generates unique IDs for the `users` table.
- **`get_user_by_id(p_id BIGINT)` function:** Returns a user by their ID.
- **`set_updated_at()` trigger function:** Updates the `updated_at` timestamp on row updates.
- **`trg_users_set_updated_at` trigger:** Applies the `set_updated_at()` function to the `users` table.
- **`reset_users()` stored procedure:** Deletes all records from the `users` table.

.PHONY: up down reset migrate history inspect test psql reset-users

# Load .env file
include .env

# export all keys from .env into the environment for subprocesses
# (this exports only variable NAMES, make expands them normally)
export $(shell sed -n 's/=.*//p' .env)

# psql automatically reads PGHOST, PGPORT, PGDATABASE, PGUSER, PGPASSWORD from the environment
PSQL = psql

# -------------------------------
# Start Postgres container
# -------------------------------
up:
	@docker compose up -d
	@echo "Postgres is starting..."

# -------------------------------
# Stop container (keeps database)
# -------------------------------
down:
	@docker compose down
	@echo "Container stopped (volume kept)."

# -------------------------------
# Destroy container + data volume
# Use only for POC/testing
# -------------------------------
reset:
	@docker compose down -v
	@docker compose up -d
	@echo "Postgres restarted with a clean empty database."

# -------------------------------
# Run Flyway migrations
# -------------------------------
migrate:
	@flyway -configFiles=flyway.conf migrate

# -------------------------------
# Show Flyway schema history table
# -------------------------------
history:
	@$(PSQL) -c "SELECT installed_rank, version, description, type, success, installed_on FROM flyway_schema_history ORDER BY installed_rank;"

# -------------------------------
# Inspect objects created by POC
# -------------------------------
inspect:
	@$(PSQL) -c "SELECT table_schema, table_name FROM information_schema.tables WHERE table_schema='app';"
	@$(PSQL) -c "SELECT sequence_schema, sequence_name FROM information_schema.sequences WHERE sequence_schema='app';"
	@$(PSQL) -c "SELECT n.nspname AS schema, proname AS function FROM pg_proc JOIN pg_namespace n ON pg_proc.pronamespace=n.oid WHERE n.nspname='app';"
	@$(PSQL) -c "SELECT trigger_name, event_object_table FROM information_schema.triggers WHERE trigger_schema='app';"

# -------------------------------
# Quick functional test
# -------------------------------
test:
	@$(PSQL) -c "INSERT INTO app.users (username) VALUES ('alice') RETURNING id;"
	@$(PSQL) -c "SELECT * FROM app.get_user_by_id(1);"

# -------------------------------
# Call the stored procedure to reset users
# -------------------------------
reset-users:
	@$(PSQL) -c "CALL app.reset_users();"
	@echo "All users have been deleted by app.reset_users();"
	@$(PSQL) -c "SELECT * FROM app.users;"

# -------------------------------
# Open interactive psql shell
# -------------------------------
psql:
	@$(PSQL)

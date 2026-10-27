.PHONY: setup test lint format check init-env rebuild

init-env:
	if [ ! -f ".env" ]; then \
			if [ ! -f ".env.example" ]; then \
				echo -e "Error: .env.example not found.\n" >&2; \
				exit 1; \
			else \
				cp .env.example .env; \
				echo -e ".env.example copied successfully.\n"; \
			fi; \
	fi

setup: init-env

	docker compose up -d --build --wait
	docker compose exec -T dev uv sync --locked
	docker compose exec -T dev uv run python ./scripts/verify_python_environment.py
	docker compose exec -T dev uv run python ./scripts/verify_postgres_adapter.py
	docker compose stop

test:
	docker compose up -d --wait
	docker compose exec -T dev uv sync --locked
	docker compose exec -T dev uv run pytest
	docker compose stop

lint:
	docker compose up -d --wait
	docker compose exec -T dev uv sync --locked
	docker compose exec -T dev uv run ruff check .
	docker compose stop
	

format:
	docker compose up -d --wait
	docker compose exec -T dev uv sync --locked
	docker compose exec -T dev uv run ruff format .
	docker compose stop

check:
	docker compose up -d --wait
	docker compose exec -T dev uv sync --locked
	docker compose exec -T dev uv run ruff format --check .
	docker compose exec -T dev uv run pytest
	docker compose stop

rebuild:
	docker compose up -d --build --wait
	docker compose exec -T dev uv sync --locked
	docker compose exec -T dev uv run python ./scripts/verify_python_environment.py
	docker compose exec -T dev uv run python ./scripts/verify_postgres_adapter.py
	docker compose exec -T dev uv run ruff format --check .
	docker compose exec -T dev uv run pytest
	docker compose stop
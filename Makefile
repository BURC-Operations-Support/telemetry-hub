.PHONY: setup test lint format check init-env reset-environment verify-build

init-env:
	@if [ ! -f ".env" ]; then \
			if [ ! -f ".env.example" ]; then \
				echo -e "Error: .env.example not found.\n" >&2; \
				exit 1; \
			else \
				cp .env.example .env; \
				echo -e ".env.example copied successfully.\n"; \
			fi; \
	fi

setup: init-env
	@docker compose up -d --build --wait
	@docker compose exec -T dev uv sync --locked
	@docker compose exec -T dev uv run python ./scripts/verify_postgres_adapter.py
	@docker compose exec -T dev uv run ruff check .
	@docker compose exec -T dev uv run pyright
	@docker compose stop
	@echo "\033[0;32m[SUCCESS]\033[0m Setup and verification complete."

test:
	@docker compose up -d --wait
	@docker compose exec -T dev uv sync --locked
	@docker compose exec -T dev uv run pytest
	@docker compose stop

lint:
	@docker compose up -d --wait
	@docker compose exec -T dev uv sync --locked
	@docker compose exec -T dev uv run ruff check .
	@docker compose stop
	

format:
	@docker compose up -d --wait
	@docker compose exec -T dev uv sync --locked
	@docker compose exec -T dev uv run ruff format .
	@docker compose stop

check:
	@docker compose up -d --wait
	@docker compose exec -T dev uv sync --locked
	@docker compose exec -T dev uv run ruff format --check .
	@docker compose exec -T dev uv run ruff check .
	@docker compose exec -T dev uv run pyright
	@docker compose exec -T dev uv run pytest
	@docker compose stop

reset-environment:
	@docker compose up -d --build --wait
	@docker compose exec -T dev uv sync --locked
	@docker compose exec -T dev uv run python ./scripts/verify_postgres_adapter.py
	@docker compose exec -T dev uv run ruff format --check .
	@docker compose exec -T dev uv run pytest
	@docker compose exec -T dev uv run ruff check .
	@docker compose exec -T dev uv run pyright
	@docker compose stop

verify-build:
	@docker compose up -d --wait
	@docker compose exec -T dev uv sync --locked
	@docker compose exec -T dev rm -rf dist /tmp/whl-test
	@docker compose exec -T dev uv venv /tmp/whl-test
	@docker compose exec -T dev uv build
	@docker compose exec -T dev sh -c \
		'uv pip install --python /tmp/whl-test/bin/python dist/*.whl'
	@docker compose exec -T -w /tmp dev \
		/tmp/whl-test/bin/python -c "import telemetryhub"
	@docker compose exec -T -w /tmp dev \
		/tmp/whl-test/bin/telemetryhub
	@docker compose exec -T dev rm -rf /tmp/whl-test
	@docker compose stop
.PHONY: setup test lint format check

setup:
	uv sync

test:
	uv run pytest

lint:
	uv run ruff check .

format:
	uv run ruff format .

check: test lint
	uv run ruff format --check .
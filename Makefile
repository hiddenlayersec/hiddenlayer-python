.PHONY: all create-virtualenv install-requirements check-security lint-flake8 lint-black check-types run-tests all-checks

PYTHON_CMD ?= python

requirements.txt: requirements.in
	pip-compile --no-emit-index-url --output-file=requirements.txt requirements.in

requirements-dev.txt: requirements-dev.in
	pip-compile --no-emit-index-url --output-file=requirements-dev.txt requirements-dev.in

create-virtualenv:
	python3.9 -m venv ./venv
	venv/bin/python -m pip install --upgrade pip setuptools wheel
	venv/bin/pip install -r requirements-dev.txt -r requirements.txt --no-dependencies

install-requirements:
	${PYTHON_CMD} -m pip install -r requirements.txt
	${PYTHON_CMD} -m pip install -r requirements-dev.txt

check-security:
	${PYTHON_CMD} -m bandit -r hiddenlayer

lint-flake8:
	${PYTHON_CMD} -m flake8 --exclude=venv .

lint-black:
	${PYTHON_CMD} -m black --check --diff .

check-types:
	${PYTHON_CMD} -m mypy --ignore-missing-imports --follow-imports=silent --strict --allow-any-generics hiddenlayer

run-tests:
	${PYTHON_CMD} -m pytest -v --cov=hiddenlayer --cov-report=term-missing tests

all-checks: lint-black lint-flake8 check-types check-security run-tests
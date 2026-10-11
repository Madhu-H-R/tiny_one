#!/bin/bash
set -e

echo "Starting backend server..."

# Search for uvicorn in all possible locations on Render and Linux
if [ -f "/opt/render/project/src/.venv/bin/uvicorn" ]; then
    exec /opt/render/project/src/.venv/bin/uvicorn app.main:app --host 0.0.0.0 --port "$PORT"
elif [ -f "/opt/render/project/src/backend/.venv/bin/uvicorn" ]; then
    exec /opt/render/project/src/backend/.venv/bin/uvicorn app.main:app --host 0.0.0.0 --port "$PORT"
elif [ -f "./.venv/bin/uvicorn" ]; then
    exec ./.venv/bin/uvicorn app.main:app --host 0.0.0.0 --port "$PORT"
elif command -v uvicorn >/dev/null 2>&1; then
    exec uvicorn app.main:app --host 0.0.0.0 --port "$PORT"
elif command -v python3 >/dev/null 2>&1; then
    exec python3 -m uvicorn app.main:app --host 0.0.0.0 --port "$PORT"
elif command -v python >/dev/null 2>&1; then
    exec python -m uvicorn app.main:app --host 0.0.0.0 --port "$PORT"
else
    echo "Fatal: Could not find uvicorn or python executable."
    exit 1
fi

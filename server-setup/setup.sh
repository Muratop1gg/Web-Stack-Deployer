#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Запуск CLI менеджера
"$SCRIPT_DIR/cli.sh" "$@"
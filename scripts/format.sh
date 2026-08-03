#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

for llvm_bin in /opt/homebrew/opt/llvm/bin /usr/local/opt/llvm/bin; do
    if [[ -d "$llvm_bin" ]]; then
        PATH="$llvm_bin:$PATH"
        break
    fi
done

cpp_files=()
while IFS= read -r -d '' file; do
    cpp_files+=("$file")
done < <(git ls-files --cached --others --exclude-standard -z -- \
    '*.c' '*.cc' '*.cpp' '*.cxx' '*.h' '*.hh' '*.hpp' '*.hxx')

if ((${#cpp_files[@]} > 0)); then
    command -v clang-format >/dev/null 2>&1 || {
        echo "clang-format is required to format C++ files." >&2
        exit 1
    }
    clang-format -i --style=file "${cpp_files[@]}"
fi

if [[ -f sources/ml/pyproject.toml ]] && command -v ruff >/dev/null 2>&1; then
    ruff format sources/ml
    ruff check --fix sources/ml
fi

if [[ -f sources/dashboard/package.json ]] && npm --prefix sources/dashboard run | grep -qE '^  format$'; then
    npm --prefix sources/dashboard run format
fi

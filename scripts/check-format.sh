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

if ! git diff --check --cached; then
    echo "Staged files contain whitespace errors." >&2
    exit 1
fi

cpp_files=()
while IFS= read -r -d '' file; do
    cpp_files+=("$file")
done < <(git ls-files --cached --others --exclude-standard -z -- \
    '*.c' '*.cc' '*.cpp' '*.cxx' '*.h' '*.hh' '*.hpp' '*.hxx')

if ((${#cpp_files[@]} > 0)); then
    if ! command -v clang-format >/dev/null 2>&1; then
        echo "clang-format is required to validate C++ formatting." >&2
        exit 1
    fi

    format_failed=0
    for file in "${cpp_files[@]}"; do
        if ! diff -u "$file" <(clang-format --style=file "$file"); then
            format_failed=1
        fi
    done

    if ((format_failed != 0)); then
        echo "C++ formatting does not match .clang-format. Run scripts/format.sh." >&2
        exit 1
    fi
fi

if [[ -f sources/ml/pyproject.toml ]] && command -v ruff >/dev/null 2>&1; then
    ruff format --check sources/ml
    ruff check sources/ml
fi

if [[ -f sources/dashboard/package.json ]] && npm --prefix sources/dashboard run | grep -qE '^  format:check$'; then
    npm --prefix sources/dashboard run format:check
fi

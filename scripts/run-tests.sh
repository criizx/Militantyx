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

if [[ -f CMakeLists.txt ]]; then
    cmake -S . -B .build/checks \
        -DCMAKE_BUILD_TYPE=Debug \
        -DBUILD_TESTING=ON \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    cmake --build .build/checks --parallel
    ctest --test-dir .build/checks --output-on-failure

    if command -v clang-tidy >/dev/null 2>&1; then
        cpp_sources=()
        while IFS= read -r -d '' file; do
            cpp_sources+=("$file")
        done < <(git ls-files --cached --others --exclude-standard -z -- \
            'sources/core/src/*.cc' 'sources/core/src/*.cpp' 'sources/core/src/*.cxx' \
            'sources/core/tests/*.cc' 'sources/core/tests/*.cpp' 'sources/core/tests/*.cxx')

        if ((${#cpp_sources[@]} > 0)); then
            clang_tidy_extra_args=()
            if [[ "$(uname -s)" == "Darwin" ]]; then
                clang_tidy_extra_args+=(
                    --extra-arg=-isysroot
                    "--extra-arg=$(xcrun --show-sdk-path)"
                )
            fi

            clang-tidy -p .build/checks "${cpp_sources[@]}" \
                --warnings-as-errors='bugprone-*,clang-analyzer-*,performance-*' \
                "${clang_tidy_extra_args[@]}"
        fi
    fi
fi

if [[ -f sources/ml/pyproject.toml ]]; then
    python3 -m pytest sources/ml
fi

if [[ -f sources/dashboard/package.json ]]; then
    npm --prefix sources/dashboard run lint --if-present
    npm --prefix sources/dashboard run typecheck --if-present
    npm --prefix sources/dashboard run test:ci --if-present
    npm --prefix sources/dashboard run build --if-present
fi

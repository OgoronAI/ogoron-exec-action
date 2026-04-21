#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${INPUT_COMMANDS:-}" ]]; then
  echo "commands input is required" >&2
  exit 2
fi

runtime_dir="$(dirname "${OGORON_BIN}")"
export PATH="${runtime_dir}:${PATH}"

script_path="${RUNNER_TEMP}/ogoron-exec-commands.sh"
cat > "${script_path}" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
EOF
printf '%s\n' "${INPUT_COMMANDS}" >> "${script_path}"
chmod +x "${script_path}"

"${script_path}"

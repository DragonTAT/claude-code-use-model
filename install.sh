#!/usr/bin/env zsh
set -euo pipefail

SCRIPT_DIR="${0:A:h}"
TARGET_DIR="${CLAUDE_MIMO_INSTALL_DIR:-${HOME}/.local/bin}"
TARGET="${TARGET_DIR}/claude-mimo"
SHELL_RC="${HOME}/.zshrc"
BACKUP=""

mkdir -p "${HOME}"
mkdir -p "${TARGET_DIR}"

if [[ -f "${TARGET}" ]] && ! cmp -s "${SCRIPT_DIR}/bin/claude-mimo" "${TARGET}"; then
  BACKUP="${TARGET}.bak.$(date +%Y%m%d%H%M%S)"
  cp "${TARGET}" "${BACKUP}"
fi

cp "${SCRIPT_DIR}/bin/claude-mimo" "${TARGET}"
chmod +x "${TARGET}"

if [[ ":${PATH}:" != *":${TARGET_DIR}:"* ]]; then
  touch "${SHELL_RC}"
  if ! grep -F 'claude-code-use-model' "${SHELL_RC}" >/dev/null 2>&1; then
    {
      print -r -- ""
      print -r -- "# claude-code-use-model"
      print -r -- "export PATH=\"${TARGET_DIR}:\$PATH\""
    } >> "${SHELL_RC}"
  fi
fi

print -r -- "Installed: ${TARGET}"
if [[ -n "${BACKUP}" ]]; then
  print -r -- "Backup:    ${BACKUP}"
fi
print -r -- ""
print -r -- "Next:"
print -r -- "  source ${SHELL_RC}"
print -r -- "  claude-mimo config"

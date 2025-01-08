# Install & Update UV for more better Python environments
# https://docs.astral.sh/uv/getting-started/installation/#standalone-installer
# Then activate new environment just in place

# Install & Update UV for more better Python environments
@uv-i-install:
    if ! command -v rustup &> /dev/null; then \
        curl -LsSf https://astral.sh/uv/install.sh | sh; \
    else \
        uv self update; \
    fi

# Install UV completions for bash. If needed.
# https://docs.astral.sh/uv/getting-started/installation/#shell-autocompletion
# Warning: Not idempotent. For now, do manually.

# Install UV completions for bash. If needed.
@uv-i-install-i-completions-i-bash:
    used_shell='bash' && \
    \
    command='eval "$(uv generate-shell-completion '"${used_shell}"')"' && \
    file="${HOME}/.${used_shell}rc" && \
    \
    grep --quiet --line-regexp --fixed-strings "${command}" "${file}" || \
    echo "${command}" >> "${file}"

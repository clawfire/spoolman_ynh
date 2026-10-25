#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

# Spoolman wants its base path without a trailing slash, and empty at the domain root
# (a bare "/" would make it mount the API on "//api/v1")
_spoolman_base_path() {
    if [ "$path" = "/" ]; then
        echo ""
    else
        echo "${path%/}"
    fi
}

# Build the Python virtualenv from upstream's uv.lock, so the exact dependency
# versions tested by upstream are installed.
# uv itself lives in a throwaway venv and is removed afterwards.
_spoolman_build_venv() {
    local uv_venv="$install_dir/.uv-build"
    local uv_cache="$install_dir/.uv-cache"

    ynh_safe_rm "$install_dir/.venv"
    ynh_safe_rm "$uv_venv"

    ynh_exec_as_app python3 -m venv "$uv_venv"
    ynh_hide_warnings ynh_exec_as_app "$uv_venv/bin/pip" install --quiet --no-cache-dir uv

    ynh_hide_warnings ynh_exec_as_app env \
        UV_PYTHON_DOWNLOADS=never \
        UV_PYTHON=/usr/bin/python3 \
        UV_CACHE_DIR="$uv_cache" \
        UV_PROJECT_ENVIRONMENT="$install_dir/.venv" \
        UV_COMPILE_BYTECODE=1 \
        UV_NO_PROGRESS=1 \
        "$uv_venv/bin/uv" sync --locked --no-dev --directory "$install_dir"

    ynh_safe_rm "$uv_venv"
    ynh_safe_rm "$uv_cache"
}

# Ask the running Spoolman for a consistent SQLite snapshot (written to $data_dir/backups)
_spoolman_snapshot_db() {
    curl --silent --fail --max-time 60 --request POST \
        "http://127.0.0.1:$port$(_spoolman_base_path)/api/v1/backup" >/dev/null
}

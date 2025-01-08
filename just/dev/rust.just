# Install Rust
# https://www.rust-lang.org/tools/install

# Install Rust
@rust-i-install:
    if ! command -v rustup &> /dev/null; then \
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y; \
    else \
        rustup update; \
    fi

# Install updater for installed rust executables
# https://crates.io/crates/cargo-update

# Install updater for installed rust executables
@rust-i-install-i-upgrade:
    cargo install cargo-update &&\
    cargo install-update cargo-update &&\
    cargo install-update --version

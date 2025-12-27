FROM debian:bookworm-slim

RUN apt update && apt install -y \
    curl \
    vim \
    unar


COPY --from=helper_scripts install_vscode_server.sh /install_vscode_server.sh
RUN chmod +x /install_vscode_server.sh

RUN groupadd --system devgroup && useradd --create-home --system --gid devgroup devuser

USER devuser

RUN /install_vscode_server.sh debian arm64
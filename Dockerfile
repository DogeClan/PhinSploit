# Use the Debian Bookworm slim image
FROM debian:bookworm-slim

# Set environment variables for non-interactive apt operations
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies and tools
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    cmake \
    python3 \
    python3-pip \
    libqt6core5a \
    libqt6gui6 \
    libqt6widgets6 \
    qt6-qmake \
    qt6-base-dev \
    qt6-tools-dev \
    qt6-webengine-dev \
    qt6script5 \
    qt6declarative5 \
    qt6svg5 \
    ninja-build \
    pkg-config \
    clang \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install http-server via npm
RUN npm install -g http-server

# Clone the Dolphin emulator repository
RUN git clone --recurse-submodules https://github.com/dolphin-emu/dolphin.git /dolphin

# Set the working directory
WORKDIR /dolphin

# Build the Dolphin core for WASM/JS
RUN mkdir -p build && cd build \
    && cmake .. -D CMAKE_BUILD_TYPE=Release -D CMAKE_TOOLCHAIN_FILE=wasm_toolchain_path_here \
    && make

# Expose the port for the http server
EXPOSE 8080

# Start the http-server to serve the built files
CMD ["http-server", "build/web", "-p", "8080", "-a", "0.0.0.0"]

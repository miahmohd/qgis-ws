# Cloud-Native Reference Architecture for QGIS Web Services

This repository contains a cloud-native reference architecture for deploying QGIS Web Services. It provides a containerized setup of QGIS Server behind an Nginx reverse proxy, capable of serving OGC-compliant web map services (WMS).

## Repository Structure

```
qgis-ws/
├── docker-compose.yaml          # Defines and orchestrates all services
├── Makefile                     # Convenience commands for Docker operations
├── qgis-server/
│   ├── Dockerfile               # Builds the QGIS Server image (Debian bookworm)
│   ├── nginx.conf               # Nginx config (FastCGI reverse proxy)
│   └── cmd.sh                   # Entrypoint script for QGIS Server
└── example-projects/
    └── osm.qgs                  # Sample QGIS project (OpenStreetMap WMS layer)
```

## Architecture

```
 Client (browser)
       │
       │ HTTP :8080
       ▼
 ┌────────────┐      FastCGI :5555      ┌──────────────┐
 │   nginx    │ ─────────────────────▶  │  qgis-server │
 │  (alpine)  │                         │  (QGIS FCGI) │
 └────────────┘                         └──────────────┘
                                               │
                                               │ reads (ro)
                                               ▼
                                         /data/osm.qgs
                                     (example-projects/)
```

- **nginx** listens on port 8080 and forwards requests at `/qgis-server` via FastCGI to the QGIS Server container.
- **qgis-server** runs the QGIS FastCGI binary inside a virtual framebuffer (`xvfb`), serving OGC WMS requests for the configured project.

## Prerequisites

- **Docker** and **Docker Compose** must be installed on your machine.

### Installing Docker

| Platform | Instructions                                                                                   |
| -------- | ---------------------------------------------------------------------------------------------- |
| Linux    | [Install Docker Engine](https://docs.docker.com/engine/install/)                               |
| macOS    | [Install Docker Desktop for Mac](https://docs.docker.com/desktop/install/mac-install/)         |
| Windows  | [Install Docker Desktop for Windows](https://docs.docker.com/desktop/install/windows-install/) |

Docker Compose is included with Docker Desktop. On Linux, follow the [Compose plugin install guide](https://docs.docker.com/compose/install/linux/) if it is not already available.

## Quick Start

1. **Clone the repository**

   ```sh
   git clone git@github.com:miahmohd/qgis-ws.git
   cd qgis-ws
   ```

2. **Build the images**

   ```sh
   make build
   ```

3. **Start the services**

   ```sh
   make up
   ```

4. **Verify the server is running**

   Open the following URL in your browser to retrieve the WMS capabilities document:

   ```
   http://localhost:8080/qgis-server?SERVICE=WMS&REQUEST=GetCapabilities
   ```

5. **Stop the services**

   ```sh
   make down
   ```

Run `make` with no arguments to see all available commands.

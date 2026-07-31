# PAiCore Technology SMSC – Free Basic Version

## Overview

The **PAiCore SMSC** is a high-performance, multi-protocol Short Message Service Center designed for MNOs, MVNOs, aggregators, and enterprise platforms requiring robust routing and high-throughput A2P/P2A/P2P messaging.

Supported messaging flows:

- HTTP ↔ SMPP  
- HTTP ↔ SS7/SIGTRAN  
- SMPP ↔ SS7/SIGTRAN  
- HTTP-based custom applications  

---

## Key Features – Free Basic (Open Source)

- Open-source core for extensibility and community-driven improvements.  
- Up to **12,000 TPS per instance** (hardware-dependent).  
- Support for **SMPP / Http**.  
- Compatible with Kafka, ScyllaDB, Redis Cluster, PostgreSQL.  

---

## Documentation (For Manual Deployment Requests Only)

Full architecture and deployment documentation is **not publicly included here**.  
If you need manual deployment instructions (Docker), you must request access:

👉 https://paicore.tech/smsc/

We will provide the appropriate technical documentation.

---

# Installation (Recommended) – Using the Installer

The recommended method for deploying the Free Basic Version is the installer distributed via GitHub Releases(https://github.com/paicbd/smsc/releases).

The `.tar.gz` package includes:  
- Environment files  
- Module definitions  
- Installer and validation scripts  
- Directory structure  
- **A README inside the package with full step-by-step instructions**  

---

## 1. Download Installer

👉 https://github.com/paicbd/smsc/releases/latest

Download the file:

```
SMSC_Installer_FreeBasic_build-XX.tar.gz
```

---

## 2. Extract the Installer

```bash
tar -xzvf SMSC_Installer_FreeBasic_build-XX.tar.gz
cd SMSC_installer/
```

Inside the extracted folder you will find:

```
README.md  (full installation guide)
installer.sh
scripts/
```

---

## 3. Run Installer

```bash
sudo ./installer.sh
```

The installer performs:

- OS validation (Ubuntu 22.04 / 24.04)  
- Installation of Docker and prerequisites  
- Deployment of:  
  - Kafka  
  - ScyllaDB  
  - Redis Cluster  
  - PostgreSQL/Citus  
- Deployment of all SMSC Free Basic modules  


# Manual Deployment

Manual deployments are **not included** in this public README.

If you require a manual deployment (Docker):

**Please contact us to request access to the internal technical documentation.**

👉 https://paicore.tech/resources/

---

# Source Code

Clone all open-source SMSC repositories:

```bash
chmod +x fork-and-clone-smsc-repos.sh
./fork-and-clone-smsc-repos.sh "<destination_directory>"
```

---

# Support & Licensing

For licensing, support, or integration services visit us:

👉 https://paicore.tech/smsc/

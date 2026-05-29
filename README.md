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
- License folder  
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

## 3. License Requirement

A valid license file is required to run the SMSC.

To request a license for the Free Basic Version, **you must contact us directly** via:

👉 https://paicore.tech/smsc/

Once you receive the license file, place it here:

```bash
sudo cp /path/to/license.txt ./smsc/data/license/license_paic.txt
```

---

## 4. Run Installer

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

---

# Docker Images – Free Basic Version

### SMSC Modules

```
paicbusinessdev/free-basic-db-insert-data:3.1.0-5
paicbusinessdev/free-basic-http-client-module:3.1.0-4
paicbusinessdev/free-basic-http-server-module:3.1.0-4
paicbusinessdev/free-basic-retries-module:3.1.0-4
paicbusinessdev/free-basic-smpp-client-module:3.1.0-5
paicbusinessdev/free-basic-smpp-server-module:3.1.0-6
paicbusinessdev/free-basic-smsc-management-be:3.1.0-1
paicbusinessdev/free-basic-smsc-management-fe:3.1.0-2
paicbusinessdev/free-basic-smsc-routing-module:3.1.0-6
paicbusinessdev/kafka:4.0.0
paicbusinessdev/scylla:5.2.0
paicbusinessdev/pg-partman
provectuslabs/kafka-ui:latest

```

---

# Manual Deployment

Manual deployments are **not included** in this public README.

If you require a manual deployment (Docker):

**Please contact us to request access to the internal technical documentation.**

👉 https://paicore.tech/smsc/

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

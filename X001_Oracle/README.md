Oracle Database layer:
- Schema design
- Indexing
- RMAN backup
- Security & roles


# X001_Oracle - Oracle Database Layer

## Overview

This section documents the complete Oracle Database infrastructure for the GREEN-IT Data Platform project. It encompasses database configuration, data ingestion, monitoring, backup strategies, and security implementations.

The Oracle layer serves as the foundational data tier in our multi-layer architecture: **Oracle → Databricks → Power BI**

---

## Architecture Components

### 1. Database Configuration (O_01_database configuration)
**Purpose**: Establish the foundational environment and database structure

**Key Implementations**:
- Virtual Machine setup with Oracle Linux
- Container Database (CDB) and Pluggable Database (PDB) architecture
- Dedicated PDB: `GREEN_IT_PDB` for project isolation
- Network configuration and TNS setup
- IDE integration (VS Code + Oracle SQL Developer)

**Outcomes**:
- Stable host-to-VM connectivity
- Isolated database environment for Green IT metrics
- Development and administration tooling configured

---

### 2. Database Creation (O_02_Database_creation)
**Purpose**: Create and initialize the database schema and objects

**Key Implementations**:
- Star schema design for analytics
- Fact and dimension tables creation
- Primary and foreign key constraints
- Index strategy for query optimization

**Outcomes**:
- Optimized schema for analytical workloads
- Data integrity through constraint enforcement
- Performance-tuned table structures

---

### 3. Data Ingestion (O_03_LOAD_CSV_DATA)
**Purpose**: Automated CSV data loading using SQL*Loader

**Key Implementations**:
- SQL*Loader control file (`green_it_load.ctl`)
- Bash orchestration script (`run_ingestion.sh`)
- Direct Path loading for performance
- Post-load verification queries
- ETL pipeline with Parquet export to GitHub

**Technical Details**:
- **Data Volume**: 1,000 records of energy and performance metrics
- **Load Time**: ~26 seconds
- **Success Rate**: 100% (0 rejected records)
- **Service Name**: `green_it_pdb.local`

**Error Resolution**:
- ORA-12514: TNS configuration fixed
- ORA-01950: Tablespace quotas allocated
- ORA-01722: Data type validation implemented

---

### 4. Storage Monitoring (O_04_Proactive_Storage_Monitoring)
**Purpose**: Proactive monitoring of tablespace and storage usage

**Key Implementations**:
- Automated storage monitoring scripts
- Threshold-based alerts (Warning: 80%, Critical: 95%)
- Disk usage tracking for PDB
- Preventive capacity planning using DBMS_SERVER_ALERT

**Outcomes**:
- Real-time visibility into storage consumption
- Proactive alerts before space exhaustion
- Optimized storage allocation

---

### 5. Backup Strategy (O_05_Backup_Rman)
**Purpose**: Enterprise-grade backup and recovery using RMAN

**Key Implementations**:
- ARCHIVELOG mode enabled for point-in-time recovery
- Level 0 (full) backups - Monthly (day 1-7)
- Level 1 (incremental) backups - Weekly
- Block Change Tracking for optimization
- Automated backup scripts (`run_rman.sh`)
- UNDO tablespace optimization

**Technical Specifications**:
- **Environment**: Oracle 19c on Oracle Linux VM
- **Target**: CDB (`ORCLCDB`) + PDB (`GREEN_IT_PDB`)
- **Backup Location**: `/home/oracle/backup/rman`
- **Automation**: Cron-based scheduling (Sundays at midnight)

**Outcomes**:
- Zero data loss potential through ARCHIVELOG
- Efficient incremental backups with Block Change Tracking
- Automated recovery point management

---

### 6. Database Auditing (O_06_Targeted_Database_Audit)
**Purpose**: Implement Unified Audit for compliance and security

**Key Implementations**:
- Unified Audit framework activated
- Custom audit policies for DML operations (INSERT, UPDATE, DELETE)
- Object-level audit on fact tables
- Audit trail monitoring and retention

**Outcomes**:
- Full traceability of database operations
- Security event detection
- Regulatory compliance support
- Data integrity validation

---

### 7. Security - TDE (O_07_TDE_Security_Audit)
**Purpose**: Transparent Data Encryption for data-at-rest protection

**Key Implementations**:
- TDE configuration for sensitive columns
- Wallet management for encryption keys
- Performance impact assessment
- Security audit validation

**Outcomes**:
- Encrypted data at rest
- Protection against physical media theft
- Compliance with data protection regulations

---

## Security & Access Control

### User Management Hierarchy
| Role | Privileges | Purpose |
|------|-----------|---------|
| **SYS** / **SYSTEM** | SYSDBA | Full administrative control |
| **GREEN_IT_PDB_ADMIN** | PDB Admin | Environment-level administration |
| **GREEN_IT_OWNER** | Developer | Schema owner with DDL/DML rights |
| **GREEN_IT_DB_READER** | Read-Only | Query and reporting access |

### Security Layers
1. **Network**: Firewall rules + TNS encryption
2. **Authentication**: Role-Based Access Control (RBAC)
3. **Authorization**: Principle of least privilege
4. **Data**: Transparent Data Encryption (TDE)
5. **Audit**: Unified Audit + Custom policies

---

## Storage Architecture

### Tablespace Strategy
| Tablespace | Purpose | Management |
|-----------|---------|------------|
| **TS_GREEN_STAGING** | Raw data ingestion | AUTOEXTEND enabled |
| **TS_GREEN_FACT** | Fact table storage | LOCAL MANAGEMENT |
| **TS_GREEN_DIM** | Dimension tables | Optimized for reads |
| **SYSTEM** / **SYSAUX** | System metadata | Monitored for capacity |
| **UNDO** | Transaction management | Dedicated for GREEN_IT_PDB |

### Performance Optimizations

**Indexing Strategy**:
- Primary key indexes on all dimension tables
- Foreign key indexes on fact tables
- Composite indexes for common query patterns
- Bitmap indexes for low-cardinality columns

**Storage Optimization**:
- Automatic Segment Space Management (ASSM)
- User-level tablespace quotas
- Block Change Tracking for faster backups
- UNDO retention tuning for long transactions

**Query Performance**:
- Star schema design for efficient joins
- Partitioning strategy for large fact tables
- Query result caching where applicable

---

## Data Flow Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    External Sources                      │
│                  (CSV Files, APIs, etc.)                 │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│              SQL*Loader (Data Ingestion)                 │
│              • Control File Mapping                      │
│              • Direct Path Loading                       │
│              • Validation & Error Handling               │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│            Oracle Database (GREEN_IT_PDB)                │
│                                                          │
│  ┌──────────────────────────────────────────────┐       │
│  │         Star Schema (Analytics Layer)         │       │
│  │  • Fact Tables (Metrics)                     │       │
│  │  • Dimension Tables (Context)                │       │
│  └──────────────────────────────────────────────┘       │
│                                                          │
│  Parallel Infrastructure:                               │
│  • RMAN Backup (Level 0 + Level 1)                     │
│  • Storage Monitoring (Alerts)                         │
│  • Unified Audit (Compliance)                          │
│  • TDE Encryption (Security)                           │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│              Export to Parquet Format                    │
│              (Integration with Databricks)               │
└─────────────────────────────────────────────────────────┘
```

---

## Implementation Summary

### Completed Components

| Component | Status | Key Metrics |
|-----------|--------|-------------|
| **Database Environment** | Complete | CDB + PDB architecture, network configured |
| **Schema Design** | Complete | Star schema with fact/dimension tables |
| **Data Ingestion** | Complete | 1,000 records loaded in 26s, 0 errors |
| **Backup Strategy** | Complete | Automated RMAN (monthly L0 + weekly L1) |
| **Storage Monitoring** | Complete | Proactive alerts and capacity planning |
| **Security - Audit** | Complete | Unified Audit policies active |
| **Security - TDE** | Complete | Data-at-rest encryption enabled |

---

## Project Outcomes

### Technical Achievements
- **Robust Infrastructure**: Enterprise-grade Oracle 19c setup with high availability
- **Automated Operations**: Data loading, backups, and monitoring fully scripted
- **Security Compliance**: Multi-layer security with audit trails and encryption
- **Performance Optimized**: Star schema, indexing, and Block Change Tracking
- **Disaster Recovery**: ARCHIVELOG mode + RMAN backups ensure data protection

### Operational Benefits
- **Zero Data Loss**: Point-in-time recovery capability
- **Audit Trail**: Full traceability for compliance
- **Scalability**: PDB architecture allows easy isolation and cloning
- **Efficiency**: Direct Path loading achieves optimal ingestion speed
- **Integration Ready**: Parquet exports seamlessly connect to Databricks

---

## Integration with Data Platform

This Oracle layer feeds into the broader GREEN-IT Data Platform:

### Downstream Flow
1. **X001_Oracle** (Current Layer) - Structured data in star schema
2. **X002_Databricks** - Medallion architecture (Bronze/Silver/Gold)
3. **X003_PowerBI** - Executive dashboards and analytics

### Future Enhancements
- Automated data refresh to Databricks
- Real-time change data capture (CDC)
- Advanced partitioning for historical data
- Machine learning model deployment in Oracle

---

## Documentation Structure

```
X001_Oracle/
├── README.md                          # This comprehensive overview
├── O_01_database configuration/       # Environment setup docs
├── O_02_Database_creation/            # Schema creation scripts
├── O_03_LOAD_CSV_DATA/                # Data ingestion pipeline
│   └── L_02_ETL_Logic/E_02_Export/   # Parquet export automation
├── O_04_Proactive_Storage_Monitoring/ # Monitoring scripts
├── O_05_Backup_Rman/                  # RMAN backup automation
├── O_06_Targeted_Database_Audit/      # Unified Audit configuration
└── O_07_TDE_Security_Audit/           # TDE security implementation
```

---

## Related Resources

- **Main Project**: [GREEN-IT-DATA-PLATFORM](../README.md)
- **Architecture Document**: [docs/architecture.md](../docs/architecture.md)
<<<<<<< HEAD
- **Lakehouse Layer**: [X002_lakehouse](../X002_lakehouse/README.md)
=======
- **Databricks Layer**: [X002_Databricks](../X002_Databricks/README.md)
>>>>>>> origin/main
- **Power BI Layer**: [X003_PowerBI](../X003_PowerBI/README.md)

---

## Contributors

**Team**: GREEN IT Oracle Data Engineering  
**Database Administrator**: SANBATI-YAHYA  
**Last Updated**: 2026-02-12

---

## License & Usage

This documentation is part of the GREEN-IT Data Platform project. All implementations follow Oracle best practices and industry standards for data engineering.

For questions or contributions, please open an issue in the main repository.

---

<<<<<<< HEAD
**Building Sustainable Data Infrastructure**
=======
**Building Sustainable Data Infrastructure**
>>>>>>> origin/main

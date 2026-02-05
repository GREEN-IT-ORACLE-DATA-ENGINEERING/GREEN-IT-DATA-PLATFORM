# 🏗️ Technical Documentation: Automated Data Ingestion Pipeline

## 1. Overview of the Ingestion Architecture
The ingestion process was designed as an automated pipeline to move **"Green IT"** workload data from raw CSV format into a structured Oracle 19c Staging Table (`STG_GREEN_WORKLOAD`). This pipeline ensures data integrity, proper type casting, and network-efficient loading using **Direct Path Load**.



---

## 2. Core Components of the Pipeline

| Component | Description | Role in the Project |
| :--- | :--- | :--- |
| **Source Data** | `green_it_data.csv` | Raw dataset containing 1,000 records of energy and performance metrics. |
| **Orchestration Script** | `run_ingestion.sh` | A Bash script that automates the environment setup and executes SQL*Loader. |
| **Control File** | `green_it_load.ctl` | The "brain" of the operation; defines how CSV fields map to SQL columns. |
| **File Transfer** | **WinSCP** | Used as the SFTP bridge to transfer scripts and data from the local machine to the Oracle Linux VM. |

---

## 3. Pipeline Configuration Details

### 📄 The Bash Script (`run_ingestion.sh`)
This script centralizes credentials and connection strings. It was optimized to use the verified service name:
* **Service Name**: `green_it_pdb.local`
* **Utility**: `sqlldr` (SQL*Loader)
* **Automation**: Includes a post-load verification step using `sqlplus` to count the records actually present in the table.

### 🛠️ The Control File (`green_it_load.ctl`)
The configuration was refined to handle real-world data issues:
* **`OPTIONS (SKIP=1)`**: Skips the CSV header row.
* **`TRAILING NULLCOLS`**: Prevents errors if a record is missing the final columns.
* **`TERMINATED BY WHITESPACE`**: Applied to the last column (`PERFORMANCE_METRIC`) to clean invisible Windows-style line endings (`^M`).

---

## 4. Troubleshooting & Error Resolution (The "Lessons Learned")
The loading process faced several critical blockers that were systematically resolved:

####  Network & Service Resolution (`ORA-12514`)
* **Problem**: The PDB `green_it_pdb` was not registered in the listener.
* **Fix**: Performed `ALTER SYSTEM REGISTER` and identified the FQSN `green_it_pdb.local`.

####  Permission & Storage (`ORA-01950`)
* **Problem**: `GREEN_IT_OWNER` had no quota on the staging tablespace.
* **Fix**: Granted `UNLIMITED QUOTA` on `TS_GREEN_STAGING`.

####  Data Integrity (`ORA-01722: invalid number`)
* **Problem**: Invisible carriage return characters (`\r`) from Windows were being read as part of the numeric data.
* **Fix**: Used `sed -i 's/\r$//'` to sanitize the CSV and adjusted the Control File to handle trailing whitespace.



---

## 5. Final Result
* **Execution Time**: ~26 seconds for a full Direct Path load.
* **Status**: **Success**.
* **Total Rows Processed**: 1,000 records.
* **Rejected/Discarded**: 0 records.S
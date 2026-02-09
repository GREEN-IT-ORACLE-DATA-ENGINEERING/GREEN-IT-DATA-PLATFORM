# 🌱 Green IT – Unified Audit Implementation

## 📘 Overview
This document describes the implementation of a **Unified Object-Level Audit** strategy designed to secure and track data manipulation operations on energy consumption data within the Green IT project.  
The goal is to ensure full traceability of **DML operations (INSERT, UPDATE, DELETE)** on critical fact tables, guaranteeing data integrity and reliable Green IT reporting.

---

## 🎯 Objective
The main objective of this audit implementation is to:
- Track all data modifications on the fact table
- Ensure data integrity and transparency
- Strengthen database security and governance
- Support reliable Green IT analytics and reporting

---

## ⚙️ Unified Audit Configuration

A unified audit policy is created to monitor **INSERT, UPDATE, and DELETE** operations on the fact table `FACT_GREEN_WORKLOAD` owned by the `GREEN_IT_OWNER` schema.  
The policy is then enabled for all database users.

```sql
CREATE AUDIT POLICY data_green_audit
ACTIONS INSERT, UPDATE, DELETE
ON GREEN_IT_OWNER.FACT_GREEN_WORKLOAD;

AUDIT POLICY data_green_audit;

# 🌱 Green IT Data Platform

## Automated Oracle → Parquet ETL Pipeline

Ce dépôt implémente un **pipeline ETL industriel** dédié à la collecte, la structuration et l’archivage des métriques **Green IT** issues d’une base de données **Oracle 19c**.

L’objectif principal est de fournir des jeux de données **optimisés pour l’analytics et les plateformes Cloud / Lakehouse (Spark, Databricks)**, tout en garantissant :

- la **traçabilité** des données,
- l’**automatisation complète** du pipeline,
- la **conformité aux bonnes pratiques** du Data Engineering.

---

## 🎯 Objectifs du Pipeline

- Extraire les métriques Green IT depuis un **Star Schema Oracle**
- Transformer les données en **format Parquet compressé**
- Versionner automatiquement les exports dans **GitHub**
- Préparer les données pour une consommation **Big Data / Lakehouse**

---

## 🏗️ Architecture

La structure respecte une séparation claire entre **logique métier**, **orchestration** et **données finales**.

### 📁 Description des composants

- **`export_to_parquet.py`**
  Script Python ETL chargé de :
  - l’extraction des données Oracle,
  - les jointures SQL,
  - la transformation,
  - l’export des données en fichiers Parquet.

- **`sync_to_github.sh`**
  Script Bash d’orchestration assurant :
  - l’exécution du pipeline ETL,
  - la gestion des erreurs,
  - l’automatisation Git (commit et push).

- **`E_03_Data_Output/`**
  Répertoire contenant exclusivement les **fichiers Parquet générés**, prêts pour l’analyse.

---

## ⚙️ Détails Techniques

### 1️⃣ Extraction & Transformation (Python)

Le script `export_to_parquet.py` réalise les opérations suivantes :

- Connexion sécurisée à **Oracle 19c**
- Jointure de la table de faits :
  - `FACT_GREEN_WORKLOAD`

- Avec les dimensions :
  - `DIM_WORKLOAD`
  - `DIM_ENERGY`
  - `DIM_SECURITY`
  - `DIM_SCENARIO`

- Chargement des données via **Pandas**
- Export en **Parquet (pyarrow)** avec :
  - compression `snappy`,
  - format optimisé pour **Spark / Databricks**.

---

### 2️⃣ Orchestration & Versioning (Bash)

Le script `sync_to_github.sh` automatise l’ensemble du processus :

- Exécution du script Python ETL
- Vérification du code de retour (sécurité d’exécution)
- Synchronisation Git ciblée :
  - `git add` uniquement sur les fichiers Parquet
  - `git commit` horodaté
  - `git push` vers la branche dédiée **`data-pipeline-branch`**

✅ Cette approche garantit que **le code reste stable** et que **seules les données sont versionnées**.

---

## 🔐 Sécurité & Bonnes Pratiques

- Credentials Oracle stockés dans des **variables d’environnement**
- Aucun mot de passe présent dans le code
- Utilisation de **chemins absolus** pour éviter les erreurs d’environnement
- Branche Git dédiée aux exports (séparation stricte **Code / Data**)

---

## 🚀 Exécution du Pipeline

### ▶️ Exécution Manuelle

```bash
./X001_Oracle/O_03_LOAD_CSV_DATA/L_02_ETL_Logic/E_02_Export/sync_to_github.sh
```

---

## 🤖 Automatisation et Orchestration (Crontab)

Afin de garantir la **fraîcheur des données** et d’éliminer toute intervention manuelle, le pipeline Green IT est entièrement **automatisé via Crontab** sous Linux.

Cette automatisation transforme un traitement ponctuel en un **Data Flow autonome, fiable et reproductible**, conforme aux standards industriels du Data Engineering.

---

## 🛠️ Commandes d’Exécution et de Validation

### 1️⃣ Attribution des droits d’exécution

```bash
chmod +x /home/oracle/green_it/X001_Oracle/O_03_LOAD_CSV_DATA/L_02_ETL_Logic/E_02_Export/sync_to_github.sh
```

---

### 2️⃣ Configuration de la tâche Crontab

Accès à l’éditeur Crontab :

```bash
crontab -e
```

Planification du pipeline (exécution **le 1er de chaque mois à 00h00**) :

```bash
00 00 1 * * /home/oracle/green_it/X001_Oracle/O_03_LOAD_CSV_DATA/L_02_ETL_Logic/E_02_Export/sync_to_github.sh >> /home/oracle/green_it/etl_cron_log.log 2>&1
```

📄 **Gestion des logs** :

- Toutes les sorties standards et erreurs sont redirigées vers `etl_cron_log.log`
- Permet un **monitoring précis** et une traçabilité complète des exécutions

---

## 🎯 Conclusion

Ce projet illustre la mise en place réussie d’une **infrastructure de données End-to-End performante et industrialisée**.

En transformant des données complexes issues d’**Oracle 19c** en fichiers **Parquet versionnés**, cette architecture :

- garantit **fiabilité, intégrité et disponibilité** des métriques Green IT,
- fournit une base solide pour l’**analyse décisionnelle**,
- facilite le **reporting environnemental**,
- et s’intègre naturellement dans une architecture **Lakehouse / Big Data**.

# X002_Databricks - Module Databricks Lakehouse

## 📋 Vue d'ensemble

Ce module implémente une architecture Medallion (Bronze-Silver-Gold) dans Databricks pour le traitement et l'analyse des données Green IT. Il orchestre la transformation des données brutes issues d'Oracle vers un modèle en étoile optimisé pour l'analyse BI.

## 🏗️ Architecture

### Architecture Medallion (Bronze → Silver → Gold)

L'architecture Medallion est une approche de conception de lakehouse qui organise les données en trois couches progressives :

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   BRONZE    │────▶│   SILVER    │────▶│    GOLD     │
│ Données     │     │  Données    │     │  Modèle     │
│  Brutes     │     │  Nettoyées  │     │  Analytique │
└─────────────┘     └─────────────┘     └─────────────┘
```

#### 🟤 Couche Bronze (Raw Data)
- **Rôle** : Stockage des données brutes sans transformation
- **Format** : Parquet avec compression Snappy
- **Source** : Exports depuis Oracle Database
- **Caractéristiques** : Append-only, schéma source préservé

#### ⚪ Couche Silver (Cleaned Data)
- **Rôle** : Nettoyage, validation et enrichissement
- **Transformations** :
  - Standardisation des textes (lowercase, trim)
  - Conversion des types de données
  - Gestion des valeurs NULL
  - Calcul d'indicateurs (intensité carbone, efficacité énergétique)
  - Suppression des doublons
- **Qualité** : Validation des règles métier

#### 🟡 Couche Gold (Analytics-Ready)
- **Rôle** : Modèle en étoile pour l'analyse BI
- **Structure** : Star Schema optimisé
- **Consommateurs** : Power BI, Tableau, outils analytiques

## 📁 Structure des dossiers et fichiers

### Racine du module
```
X002_Databricks/
├── config.py                    # Configuration centralisée
├── D_00.5_STRUCTURE.ipynb       # Documentation de la structure
├── README.MD                    # Ce fichier
├── D_01_notebooks/              # Notebooks de traitement
└── D_02_Medallion/              # Couches de données
```

### 📄 Fichiers principaux

#### `config.py`
**Rôle** : Fichier de configuration centralisée pour tous les notebooks
- Définit les chemins des couches Bronze, Silver et Gold
- Configure les chemins des fichiers Parquet
- Gère les métadonnées du projet (propriétaire, environnement)
- Facilite la maintenance et la réutilisation du code

**Importance** : Centralise la configuration pour éviter la duplication et simplifier les migrations d'environnement.

#### `D_00.5_STRUCTURE.ipynb`
**Rôle** : Notebook de documentation et setup de la structure
- Génère automatiquement la structure des dossiers
- Crée les fichiers README pour chaque couche
- Documente l'architecture complète
- Génère le fichier de configuration

**Importance** : Automatise la création et la documentation de l'infrastructure du projet.

### 📓 D_01_notebooks/ - Notebooks de traitement

#### `01_bronze_ingestion.ipynb`
**Objectif** : Ingestion des données brutes depuis Oracle vers la couche Bronze

**Processus** :
1. Charge les données Parquet exportées depuis Oracle
2. Valide la structure des données source
3. Sauvegarde en format Parquet dans la couche Bronze
4. Conserve le schéma original sans modification

**Technologies** :
- PySpark pour le traitement distribué
- Format Parquet pour performances optimales

#### `02_silver_transformation.ipynb`
**Objectif** : Transformation et nettoyage des données Bronze vers Silver

**Processus** :
1. **Nettoyage** :
   - Standardisation des textes (lowercase, trim)
   - Conversion des types de données
   - Gestion des NULL et valeurs aberrantes

2. **Enrichissement** :
   - Calcul de l'intensité carbone (Carbon_Footprint_kg / Energy_Consumption_MWh)
   - Catégorisation de l'efficacité énergétique
   - Flag pour sources d'énergie renouvelable
   - Ajout de métadonnées (timestamp de traitement)

3. **Validation** :
   - Suppression des doublons
   - Vérification des règles métier
   - Contrôles de qualité

**Technologies** :
- PySpark SQL pour transformations complexes
- UDFs (User Defined Functions) pour logique métier

#### `03_gold_star_schema.ipynb`
**Objectif** : Création du modèle en étoile (Star Schema) pour l'analyse BI

**Processus** :
1. **Création des tables de dimension** :
   - DIM_WORKLOAD : Types de workload et caractéristiques
   - DIM_ENERGY : Sources d'énergie et part renouvelable
   - DIM_SECURITY : Niveaux de sécurité et statut PQC
   - DIM_SCENARIO : Scénarios de workload

2. **Création de la table de faits** :
   - FACT_GREEN_WORKLOAD : Métriques principales
   - Clés étrangères vers les dimensions
   - Mesures : Énergie, Carbone, Coût, Performance

3. **Optimisations** :
   - Génération de clés de substitution (surrogate keys)
   - Relations Fact-Dimension
   - Partitionnement pour performances

**Technologies** :
- Modélisation dimensionnelle (Kimball)
- PySpark pour génération de clés et jointures

### 📊 D_02_Medallion/ - Couches de données

#### M_01_Bronze/
**Contenu** : Données brutes
- `green_workload_bronze.parquet` : Dataset principal non transformé
- `README.md` : Documentation de la couche Bronze

**Caractéristiques** :
- Format : Parquet avec compression Snappy
- Mise à jour : Append-only (historisation complète)
- Schéma : Identique à la source

#### M_02_Silver/
**Contenu** : Données nettoyées et enrichies
- `green_workload_silver.parquet` : Dataset transformé
- `README.md` : Documentation des transformations

**Caractéristiques** :
- Données validées et standardisées
- Colonnes calculées ajoutées
- Prêt pour analyse exploratoire

#### M_03_Gold/
**Contenu** : Modèle en étoile
- `DIM_WORKLOAD.parquet` : Dimension Workload
- `DIM_ENERGY.parquet` : Dimension Energy
- `DIM_SECURITY.parquet` : Dimension Security
- `DIM_SCENARIO.parquet` : Dimension Scenario
- `FACT_GREEN_WORKLOAD.parquet` : Table de faits principale
- `README.md` : Documentation du Star Schema

**Caractéristiques** :
- Optimisé pour requêtes BI
- Relations Fact-Dimension établies
- Prêt pour connexion Power BI/Tableau

## 🔧 Technologies utilisées et leur importance

### 1. **Databricks**
**Importance** : 
- Plateforme unifiée pour le lakehouse analytique
- Gestion collaborative des notebooks
- Intégration native avec Spark
- Scalabilité horizontale automatique

**Usage** : Environnement principal d'exécution et de développement

### 2. **Apache Spark (PySpark)**
**Importance** :
- Traitement distribué de grandes volumétries de données
- Performance optimale pour transformations complexes
- API Python intuitive (PySpark DataFrame)
- Support natif du format Parquet

**Usage** : Moteur de traitement pour toutes les transformations Bronze→Silver→Gold

### 3. **Format Parquet**
**Importance** :
- Format colonnaire optimisé pour l'analyse
- Compression efficace (réduction de 70-90% vs CSV)
- Support des schémas complexes et imbriqués
- Lecture sélective des colonnes (predicate pushdown)

**Usage** : Format de stockage pour toutes les couches (Bronze, Silver, Gold)

### 4. **Architecture Medallion**
**Importance** :
- Séparation claire des responsabilités (SoC)
- Traçabilité et auditabilité des transformations
- Possibilité de retraitement à chaque couche
- Optimisation progressive de la qualité des données

**Usage** : Patron architectural du module

### 5. **Star Schema (Modélisation Kimball)**
**Importance** :
- Performance optimale pour requêtes BI
- Simplicité pour utilisateurs métier
- Dénormalisation contrôlée
- Facilite les agrégations et le drill-down

**Usage** : Modèle de données de la couche Gold

## 🔄 Flux de données

```
┌─────────────────────────────────────────────────────────────────┐
│                     GREEN-IT-DATA-PLATFORM                      │
└─────────────────────────────────────────────────────────────────┘

1. EXTRACTION (Oracle)
   X001_Oracle/O_03_LOAD_CSV_DATA/
   │
   ├─▶ ETL Oracle (SP_ETL_LOAD_STAR_SCHEMA.sql)
   └─▶ Export Parquet (export_to_parquet.py)
        │
        └─▶ green_it_metrics.parquet
             │
             ▼

2. BRONZE INGESTION (Databricks)
   01_bronze_ingestion.ipynb
   │
   └─▶ M_01_Bronze/green_workload_bronze.parquet
        │
        ▼

3. SILVER TRANSFORMATION (Databricks)
   02_silver_transformation.ipynb
   │
   ├─▶ Cleaning (standardisation, type conversion)
   ├─▶ Enrichment (carbon intensity, efficiency flags)
   └─▶ Validation (duplicates, quality checks)
        │
        └─▶ M_02_Silver/green_workload_silver.parquet
             │
             ▼

4. GOLD MODELING (Databricks)
   03_gold_star_schema.ipynb
   │
   ├─▶ Dimensions (Workload, Energy, Security, Scenario)
   ├─▶ Fact (Green Workload metrics)
   └─▶ M_03_Gold/
        ├─ DIM_WORKLOAD.parquet
        ├─ DIM_ENERGY.parquet
        ├─ DIM_SECURITY.parquet
        ├─ DIM_SCENARIO.parquet
        └─ FACT_GREEN_WORKLOAD.parquet
             │
             ▼

5. VISUALISATION (Power BI)
   X003_Powerbi/
   │
   └─▶ Dashboards et rapports Green IT
```

## 🚀 Utilisation

### Prérequis
- Workspace Databricks configuré
- Accès aux données exportées depuis Oracle
- Python 3.8+ avec PySpark

### Exécution séquentielle

1. **Configuration**
   ```python
   # Vérifier config.py et ajuster les chemins si nécessaire
   ```

2. **Bronze - Ingestion**
   ```python
   # Exécuter 01_bronze_ingestion.ipynb
   # Charge les données brutes depuis Oracle exports
   ```

3. **Silver - Transformation**
   ```python
   # Exécuter 02_silver_transformation.ipynb
   # Nettoie et enrichit les données
   ```

4. **Gold - Modélisation**
   ```python
   # Exécuter 03_gold_star_schema.ipynb
   # Crée le modèle en étoile pour BI
   ```

### Vérification
Chaque notebook inclut des cellules de validation :
- Comptage des enregistrements
- Affichage d'échantillons
- Vérification des schémas
- Statistiques descriptives

## 📊 Modèle de données Gold (Star Schema)

### Tables de dimension

#### DIM_WORKLOAD
- Workload_ID (PK)
- Workload_Type
- Workload_Scenario
- Workload_Strategy

#### DIM_ENERGY
- Energy_ID (PK)
- Energy_Source
- Renewable_Share_Percent

#### DIM_SECURITY
- Security_ID (PK)
- Security_Level
- PQC_Status

#### DIM_SCENARIO
- Scenario_ID (PK)
- Workload_Scenario
- Scenario_Description

### Table de faits

#### FACT_GREEN_WORKLOAD
- Fact_ID (PK)
- Workload_ID (FK)
- Energy_ID (FK)
- Security_ID (FK)
- Scenario_ID (FK)
- **Métriques** :
  - Energy_Consumption_MWh
  - Carbon_Footprint_kg
  - Cost_per_Unit
  - Performance_TPM
  - Carbon_Intensity

## 🔐 Sécurité et gouvernance

- **Données sensibles** : Aucune donnée personnelle stockée
- **Accès** : Contrôlé via Databricks Workspace permissions
- **Audit** : Logs d'exécution des notebooks
- **Versioning** : Historique des modifications via Git

## 📈 Avantages de l'architecture

1. **Scalabilité** : Architecture distribuée Spark
2. **Performance** : Format Parquet colonnaire et compression
3. **Qualité** : Validation progressive à chaque couche
4. **Maintenabilité** : Séparation claire des responsabilités
5. **Traçabilité** : Historisation complète (Bronze)
6. **Flexibilité** : Retraitement possible à chaque niveau
7. **BI-Ready** : Modèle en étoile optimisé pour analyses

## 🔗 Intégrations

- **En amont** : X001_Oracle (source de données)
- **En aval** : X003_Powerbi (visualisation)
- **Parallèle** : X002_lakehouse (architecture alternative)

## 📝 Notes

- Les notebooks sont conçus pour être exécutés dans l'ordre (01 → 02 → 03)
- La configuration centralisée facilite la migration entre environnements
- L'architecture Medallion permet le retraitement incrémental si nécessaire
- Le modèle en étoile est optimisé pour les requêtes BI typiques

## 🎯 Objectif final

Fournir une plateforme analytique performante et évolutive pour l'analyse des métriques Green IT, permettant :
- La visualisation des consommations énergétiques
- L'analyse de l'empreinte carbone
- L'optimisation des coûts
- L'évaluation de l'efficacité des workloads

---

**Projet** : GREEN-IT-DATA-PLATFORM  
**Module** : X002_Databricks  
**Architecture** : Medallion (Bronze-Silver-Gold)  
**Environnement** : Databricks Lakehouse  

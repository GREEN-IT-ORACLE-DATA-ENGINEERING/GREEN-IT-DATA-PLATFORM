# 🚀 Green IT Data Platform

## Documentation Oracle – ETL

## ![alt text](image-1.png)

## 🎯 Résumé

Ce document décrit le **moteur ETL Oracle** du projet **Green IT Data Platform**.  
Il couvre :

- 🛠️ Une **procédure PL/SQL optimisée**
- 📊 Le **passage du Staging vers un schéma en étoile**
- ✅ La **vérification de l’intégrité et de la cohérence**
- ⚡ Les **optimisations de performance** (TRUNCATE, jointures indexées)

> **Objectif** : Transformer des données brutes issues d’un fichier CSV en un **modèle décisionnel robuste**, prêt pour l’analyse dans **Power BI** et les traitements analytiques.

## 📖 Introduction technique

Ce document détaille la logique de transformation (ETL) située dans le répertoire :
`X001_Oracle/ETL_Logic`

Les données sources proviennent du fichier :
`green_quantum_data_centers_2.csv`

Ce fichier contient des informations détaillées sur :

- La charge de travail des data centers
- La consommation énergétique
- L’impact environnemental (CO₂)
- La performance
- La sécurité

L’objectif de cette phase Oracle est de **normaliser les données**, supprimer les redondances textuelles et produire un **modèle décisionnel fiable** destiné à l’analyse.

---

## 📌 Architecture du Flux ETL

Le processus ETL suit une architecture séquentielle garantissant la qualité et la traçabilité des données.

### 🔹 Extraction

- Chargement des données brutes dans la table : `STG_GREEN_WORKLOAD`
- Les données sont importées via **SQL\*Loader**.

### 🔹 Transformation

- Identification des valeurs uniques pour les dimensions.
- Nettoyage et standardisation des attributs.
- Calcul des indicateurs dérivés (ex : indicateurs d’énergie renouvelable).
- Préparation des clés de jointure.

### 🔹 Chargement

- Alimentation des tables de dimensions (`DIM_*`).
- Alimentation de la table de faits (`FACT_GREEN_WORKLOAD`).
- Respect strict des clés primaires et étrangères.

---

## 🧱 Modèle de Données – Schéma en Étoile

### 📊 Table de Faits

**`FACT_GREEN_WORKLOAD`**

- Mesures numériques (consommation, coûts, performance)
- Clés étrangères vers les dimensions
- Une ligne = un enregistrement de data center

### 📐 Dimensions Principales

- `DIM_WORKLOAD` : Type de charge de travail
- `DIM_ENERGY` : Source et caractéristiques énergétiques
- `DIM_SECURITY` : Niveau de sécurité et PQC
- `DIM_SCENARIO` : Scénarios opérationnels et stratégies

Ce modèle garantit :

- Une base légère
- Des performances analytiques élevées
- Une compatibilité optimale avec Power BI

---

## 🔍 Détails de la Procédure ETL

Fichier : `SP_ETL_LOAD_STAR_SCHEMA.sql`

### 1️⃣ Réinitialisation des Tables

La procédure commence par la suppression des données existantes :

- La table de faits est vidée en premier
- Les tables de dimensions sont vidées ensuite
- Utilisation de `TRUNCATE` pour :
  - Rapidité
  - Réduction des logs
  - Meilleure performance globale

---

### 2️⃣ Gestion des Dimensions

Afin d’éviter toute duplication :

- Utilisation de `SELECT DISTINCT`
- Insertion unique des valeurs dimensionnelles

**Exemple :**
Pour la dimension énergie :

- 1000 lignes en staging
- Seulement **4 sources d’énergie uniques**
  - Solar
  - Wind
  - Grid
  - Hybrid

---

### 3️⃣ Construction de la Table de Faits

- Aucun champ textuel stocké
- Jointures `INNER JOIN` avec les dimensions
- Récupération des identifiants numériques uniquement

**Avantages :**

- Meilleure performance
- Moins d’espace disque
- Modèle décisionnel conforme aux standards BI

---

## 🚀 Guide d’Exécution

Script principal : `RUN_ETL.sql`

### Étape 1️⃣ – Préparation

Avant exécution :

- Les tables doivent être créées via : `C04_CREATE_TABLES.sql`
- Les données CSV doivent être chargées dans le staging.

---

### Étape 2️⃣ – Exécution du Flux ETL

Dans **SQL\*Plus** ou **SQL Developer** :

```sql
@X001_Oracle/D05_ETL_Logic/RUN_ETL.sql
```

Ce que fait le script :

- Active `SERVEROUTPUT`
- Compile la procédure ETL
- Lance le chargement des dimensions et des faits
- Affiche un rapport final de contrôle

---

## ✅ Audit et Validation des Données

À la fin de l’exécution, un audit automatique est réalisé.

📊 Résultats attendus (dataset de 1000 lignes)

| Table        | Lignes attendues | Description            |
| ------------ | ---------------- | ---------------------- |
| DIM_WORKLOAD | 1000             | Un ID par centre       |
| DIM_ENERGY   | 4                | Sources d’énergie      |
| DIM_SECURITY | 8                | Sécurité + PQC         |
| DIM_SCENARIO | 25               | Scénarios × stratégies |
| FACT_GREEN   | 1000             | Faits chargés          |

## 🏁 Conclusion

Cette phase Oracle finalise la structuration des données Green IT.

Les données sont désormais :

✅ Intègres

✅ Normalisées

✅ Optimisées pour l’analyse

Elles sont prêtes pour :

📊 Visualisation avec Power BI

⚙️ Traitement Big Data avec Databricks

🌍 Analyse de performance environnementale

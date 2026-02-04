# 📐 Data Modeling — Green IT Data Platform

## 📌 Objectif de la modélisation

Cette modélisation de données a pour objectif de structurer les informations issues d’un dataset Green IT afin de permettre :

- l’analyse de l’impact environnemental des workloads,
- l’évaluation de la consommation énergétique et des émissions carbone,
- la comparaison des stratégies opérationnelles et de sécurité.

Le modèle est conçu pour être :
- cohérent avec une base **Oracle**,
- exploitable dans un contexte **décisionnel**,
- évolutif pour des usages analytiques (BI).

---

## 🧠 Choix de la modélisation

Nous avons choisi une **modélisation dimensionnelle**, basée sur un **schéma en étoile (Star Schema)**.

### Raisons du choix
- Lisibilité métier
- Simplicité des jointures
- Bonnes performances pour l’analyse
- Compatibilité avec les outils de Business Intelligence

Ce type de modélisation est particulièrement adapté aux cas d’usage analytiques et au calcul de KPI.

---

## 🧱 Vue d’ensemble du modèle

Le modèle est composé de :
- **1 table de faits centrale**
- **4 tables de dimensions**

La table de faits contient les mesures quantitatives, tandis que les dimensions décrivent le contexte d’analyse.

---

## 🟩 Table de faits

### `FACT_GREEN_WORKLOAD`

**Rôle**  
Chaque enregistrement représente un **scénario d’exécution d’un workload** dans un data center.

**Clés**
- `fact_id` : clé primaire technique
- `workload_id` : clé étrangère vers DIM_WORKLOAD
- `energy_id` : clé étrangère vers DIM_ENERGY
- `security_id` : clé étrangère vers DIM_SECURITY
- `scenario_id` : clé étrangère vers DIM_SCENARIO

**Mesures principales**
- consommation énergétique
- émissions carbone
- coût opérationnel
- demandes en ressources (compute, storage, network)
- indicateurs de performance et d’efficacité
- scores liés à la sécurité et à l’optimisation

Ces mesures servent de base au calcul des indicateurs Green IT.

---

## 🟦 Tables de dimensions

### `DIM_WORKLOAD`
Décrit le type de workload informatique et ses besoins en ressources.

Attributs principaux :
- type de workload
- demande en calcul
- demande en stockage
- demande réseau

---

### `DIM_ENERGY`
Décrit la source d’énergie utilisée par le data center.

Attributs principaux :
- type de source d’énergie
- indicateur d’énergie renouvelable

---

### `DIM_SECURITY`
Décrit le niveau de sécurité appliqué au workload.

Attributs principaux :
- niveau de sécurité
- activation de la cryptographie post-quantique (PQC)

---

### `DIM_SCENARIO`
Décrit le contexte et la stratégie opérationnelle.

Attributs principaux :
- **workload_scenario** : contexte global d’exécution (faible charge, forte charge, économie d’énergie, etc.)
- **scenario_strategy** : stratégie appliquée (orientée performance, coût, sécurité ou Green IT)

---

## 🔗 Relations entre les tables

- Chaque dimension est reliée à la table de faits par une relation **1 → N**
- La table de faits centralise les mesures
- Les dimensions apportent le contexte analytique

Cette structure garantit une bonne intégrité des données et facilite l’analyse décisionnelle.

---

## 📈 Avantages du modèle

- Modèle clair et compréhensible
- Facile à maintenir et à faire évoluer
- Adapté aux analyses Green IT
- Compatible avec une architecture analytique moderne

---

## 📌 Évolutions possibles

- Ajout d’une dimension Temps détaillée
- Ajout d’une dimension Localisation ou Data Center
- Extension du modèle pour des analyses multi-sites

---

## 🧾 Conclusion

Ce modèle de données constitue une base solide pour analyser les enjeux Green IT à travers une approche décisionnelle structurée, en respectant les bonnes pratiques de la modélisation dimensionnelle.
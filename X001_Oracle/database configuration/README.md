# Rapport Technique : Configuration de l'Environnement et Socle de Données

## 🎯 Objectif
L'objectif principal de cette mission était d'établir un environnement de base de données performant, sécurisé et isolé pour héberger les données de charge de travail **"Green IT"**. L'implémentation repose sur deux piliers : l'**Isolation Physique** et le **Contrôle d'Accès Basé sur les Rôles (RBAC)**.

---

## 🌐 Connectivité et Infrastructure de l'Environnement
Afin d'assurer un flux de travail stable, un pont de connexion robuste a été mis en place :

* **Pont Hôte-VM :** Configuration d'une machine virtuelle **Oracle Linux** servant de serveur de base de données.
* **Intégration IDE :** * **VS Code :** Utilisé pour le versioning des scripts SQL et le développement.
    * **Oracle SQL Developer :** Connecté via des **configurations TNS** pour les tâches d'administration (DBA).
* **Conteneurisation :** Initialisation d'une base de données enfichable dédiée `GREEN_IT_PDB` afin de garantir l'indépendance du projet par rapport au conteneur racine (CDB).

---

## 💾 Couche de Stockage Physique
En suivant les meilleures pratiques DBA, j'ai implémenté une stratégie **« Un Tablespace par Table »** pour optimiser les E/S disque et faciliter la maintenance.

| Composant | Stratégie |
| :--- | :--- |
| **Tablespaces Dédiés** | Création de 8 tablespaces distincts (incluant l'Undo et l'Archivage) pour éviter que la croissance de la table de Faits n'impacte les performances des Dimensions. |
| **Optimisation du Stockage** | Configuration en `AUTOEXTEND` et `LOCAL MANAGEMENT` pour permettre une ingestion massive et évolutive des données. |

---

## 🔐 Sécurisation et Gestion des Utilisateurs
Un modèle de sécurité hiérarchisé a été conçu pour garantir l'intégrité des données et respecter le principe du moindre privilège.

### Profils de Sécurité
Trois profils personnalisés ont été créés pour gérer :
* La complexité des mots de passe.
* La limitation des tentatives de connexion infructueuses.
* Les seuils d'expiration des sessions.

### Contrôle d'Accès Basé sur les Rôles (RBAC)
| Rôle | Niveau d'Accès |
| :--- | :--- |
| **`GREEN_IT_PDB_ADMIN`** | Rôle d'administration de haut niveau pour un contrôle total de l'environnement. |
| **`GREEN_IT_OWNER`** | Rôle développeur avec droits spécifiques sur les opérations `INDEX`, `VIEW` et `CRUD`. |
| **`GREEN_IT_DB_READER`** | Rôle restreint en lecture seule pour les accès analytiques. |

---

## 🏗️ Fondations Architecturales (Schéma en Étoile)
L'environnement est structuré en deux couches distinctes pour un traitement optimal des données :

### 1. Couche de Staging (Atterrissage)
* **Table :** `STG_GREEN_WORKLOAD`
* **Objectif :** Une zone de réception sans contraintes, située dans son propre tablespace, optimisée pour l'ingestion rapide de fichiers CSV bruts.

### 2. Couche Analytique (Schéma en Étoile)
* **Dimensions :** 4 tables utilisant des **clés de substitution** (*Surrogate Keys*) pour assurer la stabilité des données.
* **Table de Faits :** Un référentiel central pour le stockage des métriques d'activité.
* **Optimisation des Performances :** Mise en œuvre d'**Index Bitmap** sur toutes les clés étrangères de la table de faits pour accélérer les requêtes analytiques complexes.

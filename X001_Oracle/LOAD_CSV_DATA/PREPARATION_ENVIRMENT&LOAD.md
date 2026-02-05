# 🏗️ Documentation Technique : Pipeline d'Ingénierie de Données Automatisée
```text
                                    +-----------------------+
                                    |       CDB (root)      |
                                    |-----------------------|
                                    |  PDB$SEED  |  PDBs    |
                                    |            |-----------------┐
                                    |            | green_it_pdb   |
                                    +------------------------------+

                                    +--------------------------------+
                                    |       files_envirement         |
                                    |--------------------------------|
                                    |  green_it_data.csv             |
                                    |  green_it_load.ctl             |
                                    |  run_ingestion.sh              |
                                    |                                |
                                    |  Oracle VM path:               |
                                    |  $ORACLE_HOME/green_it         |
                                    |  (ex: /home/oracle/green_it)   |
                                    +--------------------------------+
``` 
## 1. Vue d'ensemble de l'architecture d'ingestion
Le processus d'ingestion a été conçu comme un pipeline automatisé pour déplacer les données de charge de travail **"Green IT"** du format CSV brut vers une table de staging Oracle 19c structurée (`STG_GREEN_WORKLOAD`). Ce pipeline garantit l'intégrité des données, le bon typage et un chargement efficace en réseau utilisant **Direct Path Load**.



---

## 2. Composants principaux du pipeline

| Composant | Description | Rôle dans le projet |
| :--- | :--- | :--- |
| **Données Source** | `green_it_data.csv` | Ensemble de données brut contenant 1 000 enregistrements de métriques énergétiques et de performance. |
| **Script d'Orchestration** | `run_ingestion.sh` | Un script Bash qui automatise la configuration de l'environnement et exécute SQL*Loader. |
| **Fichier de Contrôle** | `green_it_load.ctl` | Le "cerveau" de l'opération ; définit comment les champs CSV se mappent aux colonnes SQL. |
| **Transfert de Fichiers** | **WinSCP** | Utilisé comme pont SFTP pour transférer des scripts et des données de la machine locale vers la VM Oracle Linux. |

---

## 3. Détails de Configuration du Pipeline

### 📄 Le Script Bash (`run_ingestion.sh`)
Ce script centralise les identifiants et les chaînes de connexion. Il a été optimisé pour utiliser le nom de service vérifié :
* **Nom de Service** : `green_it_pdb.local`
* **Utilitaire** : `sqlldr` (SQL*Loader)
* **Automatisation** : Inclut une étape de vérification post-chargement utilisant `sqlplus` pour compter les enregistrements réellement présents dans la table.

### 🛠️ Le Fichier de Contrôle (`green_it_load.ctl`)
La configuration a été affinée pour gérer les problèmes de données du monde réel :
* **`OPTIONS (SKIP=1)`** : Ignore la ligne d'en-tête CSV.
* **`TRAILING NULLCOLS`** : Empêche les erreurs si un enregistrement manque les colonnes finales.
* **`TERMINATED BY WHITESPACE`** : Appliqué à la dernière colonne (`PERFORMANCE_METRIC`) pour nettoyer les fins de ligne invisibles de style Windows (`^M`).

---

## 4. Dépannage & Résolution d'Erreurs (Les "Leçons Apprises")
Le processus de chargement a rencontré plusieurs obstacles critiques qui ont été résolus systématiquement :

####  Résolution Réseau & Service (`ORA-12514`)
* **Problème** : Le PDB `green_it_pdb` n'était pas enregistré dans l'auditeur.
* **Correction** : Exécuté `ALTER SYSTEM REGISTER` et identifié le FQSN `green_it_pdb.local`.

####  Permission & Stockage (`ORA-01950`)
* **Problème** : `GREEN_IT_OWNER` n'avait pas de quota sur l'espace de tables de staging.
* **Correction** : Accordé `QUOTA ILLIMITÉE` sur `TS_GREEN_STAGING`.

####  Intégrité des Données (`ORA-01722: nombre invalide`)
* **Problème** : Des caractères de retour chariot invisibles (`\r`) de Windows étaient lus comme faisant partie des données numériques.
* **Correction** : Utilisé `sed -i 's/\r$//'` pour assainir le CSV et ajusté le Fichier de Contrôle pour gérer les espaces blancs finaux.



---

## 5. Résultat Final
* **Temps d'Exécution** : ~26 secondes pour un chargement complet en Direct Path.
* **Statut** : **Succès**.
* **Total des Lignes Traitées** : 1 000 enregistrements.
* **Rejeté/Écarté** : 0 enregistrements.
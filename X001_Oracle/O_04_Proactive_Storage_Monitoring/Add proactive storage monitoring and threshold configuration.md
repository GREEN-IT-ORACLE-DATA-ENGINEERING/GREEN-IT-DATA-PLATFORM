# 🛡️ Infrastructure DBA : Surveillance Proactive du Stockage

### 📊 Aperçu
Pour garantir la stabilité de notre **Data Warehouse Green IT**, nous avons mis en place un système d'alerte automatisé. Ce dispositif surveille la capacité de stockage de nos Tablespaces Oracle afin de prévenir toute interruption lors des processus ETL et assurer la haute disponibilité du schéma en étoile.

### ⚙️ Détails de l'Implémentation
Nous utilisons le package `DBMS_SERVER_ALERT` pour définir des seuils dynamiques sur tous les tablespaces du projet (`TS_%`) ainsi que sur les tablespaces critiques du système (`SYSTEM`, `SYSAUX`).

* **Métrique Surveillée** : Pourcentage d'espace utilisé (`TABLESPACE_PCT_FULL`).
* **Stratégie de Seuils** :
    * **Avertissement (80%)** : Déclenche une notification pour permettre à l'administrateur (DBA) de planifier une extension (ajout de fichiers de données ou redimensionnement).
    * **Critique (95%)** : Alerte de haute priorité indiquant un risque immédiat de suspension des transactions.

### 🛠️ Script d'Automatisation
La configuration est gérée par un bloc PL/SQL qui détecte automatiquement les nouveaux tablespaces et applique la politique de surveillance.

> **Note** : Le script complet est disponible dans le fichier : `Implementation_Automated_Threshold_Configuration.sql` présent dans ce dossier.

```sql
-- Configuration dynamique des alertes de stockage
BEGIN
  FOR ts IN (SELECT tablespace_name 
             FROM dba_tablespaces 
             WHERE tablespace_name LIKE 'TS_%' 
                OR tablespace_name IN ('SYSTEM', 'SYSAUX')) 
  LOOP
    DBMS_SERVER_ALERT.SET_THRESHOLD(
      metrics_id              => DBMS_SERVER_ALERT.TABLESPACE_PCT_FULL,
      warning_value           => '80',
      critical_value          => '95',
      observation_period      => 1,
      consecutive_occurrences => 1,
      object_type             => DBMS_SERVER_ALERT.OBJECT_TYPE_TABLESPACE,
      object_name             => ts.tablespace_name
    );
  END LOOP;
END;
/
alter session set container = green_it_pdb;

-- Bloc PL/SQL pour automatiser la surveillance des Tablespaces
BEGIN
  -- Boucle sur tous les tablespaces du projet (TS_%) et les tablespaces système
  FOR ts IN (SELECT tablespace_name 
             FROM dba_tablespaces 
             WHERE tablespace_name LIKE 'TS_%' 
                OR tablespace_name IN ('SYSTEM', 'SYSAUX')) 
  LOOP
    -- Configuration des seuils d'alerte pour chaque tablespace trouvé
    DBMS_SERVER_ALERT.SET_THRESHOLD(
      metrics_id              => DBMS_SERVER_ALERT.TABLESPACE_PCT_FULL, -- Métrique: Pourcentage d'occupation
      warning_operator        => DBMS_SERVER_ALERT.OPERATOR_GE,         -- Opérateur: Supérieur ou égal (>=)
      warning_value           => '80',                                  -- Seuil Warning: 80%
      critical_operator       => DBMS_SERVER_ALERT.OPERATOR_GE,         -- Opérateur: Supérieur ou égal (>=)
      critical_value          => '95',                                  -- Seuil Critique: 95%
      observation_period      => 1,                                     -- Période d'observation (minutes)
      consecutive_occurrences => 1,                                     -- Nombre d'occurrences avant alerte
      instance_name           => NULL,                                  -- Appliquer à l'instance locale
      object_type             => DBMS_SERVER_ALERT.OBJECT_TYPE_TABLESPACE, -- Type d'objet: Tablespace
      object_name             => ts.tablespace_name                     -- Nom du tablespace ciblé
    );
    
    -- Affichage du succès de la configuration pour chaque tablespace
    DBMS_OUTPUT.PUT_LINE('Alerte active pour: ' || ts.tablespace_name);
  END LOOP;
END;
/

-- Commande pour vérifier que les seuils sont bien enregistrés dans le dictionnaire de données
SELECT object_name, warning_value, critical_value 
FROM DBA_THRESHOLDS 
WHERE object_name LIKE 'TS_%';
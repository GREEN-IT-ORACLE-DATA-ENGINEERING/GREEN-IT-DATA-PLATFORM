# 🛡️ Audit de Sécurité Oracle 19c : Transparent Data Encryption (TDE)

Mise en œuvre du chiffrement **Transparent Data Encryption (TDE)** au sein d'une architecture Oracle 19c Multitenant pour le projet Green IT.

## 📋 Points Forts de l'Audit

* **Configuration Système** : Résolution des erreurs de paramètres `WALLET_ROOT` manquants (`ORA-46693`) pour s'aligner sur les standards de sécurité Oracle 19c.
* **Mise en place du Keystore** : Création et gestion réussies d'un keystore logiciel sécurisé par mot de passe (`PASSWORD-based`).
* **Isolation Multitenant** : Activation d'une gestion indépendante et explicite du keystore pour le conteneur applicatif `green_it_pdb`.
* **Preuve de Concept** : Déploiement réussi d'un tablespace entièrement chiffré (`AES256`), garantissant la protection intégrale des données au repos (Data-at-Rest).



## 💎 Valeur Ajoutée

* **Conformité Réglementaire** : Architecture prête pour les audits RGPD et les normes internationales de protection des données sensibles.
* **Sécurité des Données** : Protection contre le vol physique des fichiers de données (`.dbf`) ou des sauvegardes, les rendant illisibles sans la clé maîtresse.
* **Transparence Applicative** : Chiffrement natif au niveau de la couche de stockage, ne nécessitant aucune modification du code SQL ou de la logique métier.
* **Standardisation** : Utilisation de la structure de répertoire `/tde/` conforme aux meilleures pratiques d'Oracle 19c.

## 🛠️ Utilisation

Pour reproduire cette configuration, veuillez vous référer au script `tde_setup.sql` inclus dans ce dossier. Assurez-vous d'avoir les privilèges `SYSDBA` et de vérifier les chemins système avant l'exécution.
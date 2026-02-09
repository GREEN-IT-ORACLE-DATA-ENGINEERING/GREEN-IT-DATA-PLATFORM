# *Rapport Technique : Administration et Sauvegarde de la Base de Données Oracle / Projet GREEN IT*
# *🎯 Objectif*

L'objectif de cette mission était de préparer, sécuriser et sauvegarder la base de données Oracle hébergeant la Pluggable Database GREEN_IT_PDB, dans un environnement machine virtuelle Oracle Linux , en garantissant :

La fiabilité des données
La continuité de service
L'optimisation des performances
L'automatisation des sauvegardes

# *🖥️ Environnement de Travail*

Plateforme : Machine virtuelle Oracle Linux

Base de données : Oracle Database 19c

Mode d'administration : Terminal Oracle (SQLPlus & RMAN)

Architecture : CDB avec Pluggable Database dédiée ( GREEN_IT_PDB)

# *🔌 Préparation et Démarrage de la Base*

Accès à la base de données avec des droits administrateur (SYSDBA) .

Arrêt contrôlé de la base afin d'effectuer des opérations critiques en toute sécurité.

Redémarrage de la base dans un mode de maintenance , nécessaire pour activer certains paramètres structurels.

Activation du mode ARCHIVELOG , indispensable pour :

Les sauvegardes incrémentielles

La restauration point-in-time

La protection contre la perte de données

# *💻 Gestion de la base de données PluggableGREEN_IT_PDB*

Sélection explicite de la PDB GREEN_IT_PDBafin de travailler uniquement sur l'environnement Green IT.

Ouverture de la PDB pour permettre les opérations d'administration et de sauvegarde.

Cette approche garantit une isolation complète des données du projet par rapport au conteneur racine (CDB).

# *🔄 Gestion et Optimisation de l'UNDO*

Basculement vers un tablespace UNDO dédié au projet Green IT.

Vérification que ce tablespace UNDO est bien actif et utilisé par la base.

Configuration de la durée de rétention UNDO afin de :

Garantir la cohérence des lectures longues

Améliorer la gestion des transactions

Réduire les risques d'erreurs liées à l'expiration des données UNDO

# *💾 Stratégie de Sauvegarde RMAN*
Sauvegarde Complète (Niveau 0)

Mise en place d'une sauvegarde complète de la PDBGREEN_IT_PDB .

Cette sauvegarde constitue le point de référence principal pour toutes les restaurations futures.

Identification claire de la sauvegarde via un système de marquage (TAG).

Sauvegarde Incrémentielle (Niveau 1)

Mise en place de sauvegardes incrémentielles ne contenant que les blocs modifiés depuis la dernière sauvegarde.

Cette méthode permet :

Une réduction de l'espace disque

Un temps de sauvegarde plus court

Une meilleure efficacité opérationnelle

# *🔍 Vérification des Sauvegardes et Journaux*

Contrôle de l'ensemble des sauvegardes existantes afin de s'assurer de leur disponibilité.

Vérification de la génération et de l'archivage des journaux de transactions (Archive Logs) .

Ces vérifications garantissent que la base peut être restaurée à tout moment en cas d'incident.

# *🛠️ Automatisation des Sauvegardes*

Création d'un script automatisé dédié aux sauvegardes de la PDB.

Définition des variables d'environnement Oracle nécessaires à une exécution correcte.

Planification du script via le système suivant (cron) :

Exécution automatique chaque dimanche à minuit

Aucune intervention manuelle requise

Cette automatisation assure une sauvegarde régulière et fiable .

# *⚡ Optimisation des Sauvegardes Incrémentielles*

Activation du Block Change Tracking , un mécanisme Oracle permettant d'identifier précisément les blocs modifiés.

Cette optimisation permet :

Une accélération significative des sauvegardes incrémentielles

Une réduction de la charge sur le système

Vérification de l'état du fichier de suivi pour confirmer son bon fonctionnement.

# *✅ Technique Bilan*

Base Oracle préparée et sécurisée dans un environnement virtuel.

Mode ARCHIVELOG activé pour assurer la protection des données.

PDB GREEN_IT_PDBisolé et dédié au projet Green IT.

UNDO tablespace configuré et optimisé pour la gestion des transactions.

Sauvegardes complètes et incrémentielles mises en place avec RMAN.

Sauvegardes automatisées via script et système de planification.

Optimisation des performances grâce au Block Change Tracking.

# *🎓 Conclusion*

Cette mission a permis de mettre en place une architecture de sauvegarde professionnelle , conforme aux bonnes pratiques DBA Oracle , garantissant la sécurité, la performance et la disponibilité des données du projet GREEN IT .

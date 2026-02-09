# Gestion de la base de données enfichable (PDB)

La PDB GREEN_IT_PDBa été ouverte et isolée pour concentrer les opérations de sauvegarde uniquement sur elle, garantissant l'indépendance par rapport à la base racine.

# Sauvegarde de la Base

Mise en place d'une sauvegarde complète (Niveau 0) de la PDB pour disposer d'un point de restauration initial.

Mise en place d'une sauvegarde incrémentielle (Niveau 1) permettant de sauvegarder uniquement les blocs modifiés depuis la dernière sauvegarde complète ou incrémentielle, optimisant ainsi le temps et l'espace disque.

Les sauvegardes ont été taguées et organisées pour faciliter leur suivi et leur restauration si nécessaire.

# Vérification des Sauvegardes

J'ai réalisé une vérification complète des sauvegardes et des journaux archivés pour confirmer que toutes les données nécessaires à la restauration étaient disponibles et intactes.

# Automatisation des Sauvegardes

J'ai créé un script automatisé pour effectuer les sauvegardes complètes de manière hebdomadaire.

La planification via le spécifié de tâches (cron) permet désormais d'exécuter le script automatiquement tous les dimanches à minuit, notamment les interventions manuelles et assurant la régularité des sauvegardes.

# Optimisation des Sauvegardes

Activation d'un système de suivi des blocs modifiés (Block Change Tracking) pour accélérer les sauvegardes incrémentielles et réduire l'impact sur les performances de la base.

Vérification de l'état de ce suivi pour s'assurer de son bon fonctionnement.

# Vérification des Jobs Planifiés

Contrôle des tâches automatisées pour s'assurer que tous les travaux liés aux sauvegardes et à la surveillance de la base sont bien actifs et fonctionnels.

✅ Résumé 

Préparation de la base pour les opérations de critiques dans un environnement virtuel sécurisé.

Ouverture et isolation de la PDB GREEN_IT_PDBpour la sauvegarde.

Mise en place de sauvegardes complètes et incrémentielles fiables.

Automatisation des sauvegardes hebdomadaires pour assurer la continuité sans intervention humaine.

Optimisation grâce au suivi des blocs modifiés pour accélérer les sauvegardes.

Vérification régulière des sauvegardes et des travaux planifiés pour garantir l'intégrité et la disponibilité des données.

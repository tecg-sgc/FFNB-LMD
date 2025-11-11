#1. Afficher toutes les localités et codes postaux disponibles.

#2. Lister tous les secrétaires avec leur nom, prénom et la localité où ils travaillent.

#3. Afficher tous les clubs et le nombre de nageurs inscrits dans chaque club.

#4. Rechercher le nom et le prénom des nageurs appartenant aux catégories d'âge de moins de 35 ans qui ont toujours spécifié un temps de référence à la première journée de la deuxième compétition de 2003.


#5. Lister les nageurs avec leur nom, prénom, sexe et le libellé de la catégorie à laquelle ils appartiennent


#6. Afficher toutes les piscines avec leur nom, adresse et nombre de couloirs.


#7. Lister toutes les compétitions avec leur identifiant et leur libellé.


#8. Afficher tous les juges avec le nom du club auquel ils sont affiliés.


#9. Lister toutes les journées de compétition avec la date, l’heure de la compétition et le nom de la piscine.


#10. Afficher le planning d’une journée spécifique d’une compétition, avec le numéro de course et le libellé de la course.


#11. Lister tous les résultats d’une compétition "Challenge Jean-Baptiste Evrard" pour un "ANNIE", "STOOKER" avec son temps réel et sa place.


#12. Afficher le nombre total de nageurs par club, avec le nom du club (s'il est null alors afficher son code), trié par ordre décroissant sur nombre total de nageurs.

#13. Lister les nageurs avec le nom de leur club et le libellé de sa catégorie.


#14. Afficher le nombre de compétitions organisées par chaque secrétariat, avec le nom et prénom du secrétaire.

#15. Lister toutes les piscines et le nombre de journées de compétition prévues dans chacune, trié par nombre de journées décroissant.

#16. Afficher les nageurs qui n’ont participé à aucune compétition.


#17. Lister toutes les journées de la compétition "Championnats de Belgique de Natation" avec le nom de la piscine et le nom du juge responsable.


#18. Afficher pour chaque année de compétition le nombre total de courses prévues dans le planning.


#19. Afficher tous les résultats du nageur BRUNO LEROY. Pour chaque résultat, on souhaite connaître :
# son temps réel,
#sa place,
# la distance de la course,
# le libellé du championnat ainsi que l’année de la compétition.
# Attention : Les résultats devront être classés par date et heure de la compétition.


#20. Afficher le nombre de nageurs par catégorie, avec la catégorie et la tranche d’âge correspondante.


#21. Lister les clubs et le nom du secrétaire responsable, pour tous les clubs ayant plus de 10 nageurs inscrits.


#22. Rechercher le nom et le prénom des nageurs appartenant aux catégories d'âge de moins de 35 ans qui n’ont jamais spécifié un temps de référence à la première journée de la deuxième compétition de 2003.


#23. Afficher le nom, la localité, la longueur et le nombre de couloirs de la piscine dans laquelle ont été organisées le plus de journées de compétition.


#24. Rechercher la date et le nom de la compétition qui a organisé au moins 10 courses sur une même journée


#25. Rechercher le jour de compétition qui a commencé le plus tard. On précisera le libellé de la compétition, l'année, le jour, la date et l'heure du début de la compétition.


#26. Rechercher les numéraux de ligue, nom, prénom, sexe, année de naissance, total des points du nageur qui a obtenu le plus de points sur toutes les compétitions.


#27. Rechercher le numéro de ligue, le nom, le prénom et le nom du club des nageurs qui n'ont jamais été classés parmi les 10 premiers à aucune des courses auxquelles ils ont participé.


#28. Rechercher le numéro de ligue, le nom, le prénom, le sexe, l'année de naissance et le nom du club des nageurs qui ont été classés premiers à toutes les courses auxquelles ils ont participé.



# supprimer tous les codes postaux qui ne sont pas utilisés
#2972
SELECT count(*)
FROM code_postaux;

DELETE
FROM code_postaux
WHERE code_postal NOT IN (SELECT code_postal FROM nageurs)
AND code_postal NOT IN (SELECT code_postal FROM secretariats)
AND code_postal NOT in (SELECT code_postal FROM piscines) ;

COMMIT;
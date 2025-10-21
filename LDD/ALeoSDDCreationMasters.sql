-- Suppression des tables dans l'ordre inverse des dépendances
DROP TABLE IF EXISTS resultats;
DROP TABLE IF EXISTS decisions;
DROP TABLE IF EXISTS planning;
DROP TABLE IF EXISTS journees;
DROP TABLE IF EXISTS juges;

-- Suppression de la contrainte circulaire avant de supprimer les tables
ALTER TABLE clubs DROP FOREIGN KEY fk_clubs_nageurs;

DROP TABLE IF EXISTS nageurs;
DROP TABLE IF EXISTS clubs;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS piscines;
DROP TABLE IF EXISTS organisateurs;
DROP TABLE IF EXISTS competitions;
DROP TABLE IF EXISTS secretariats;
DROP TABLE IF EXISTS code_postaux;

CREATE TABLE code_postaux
(
    code_postal varchar(5)     NOT NULL,
    localite    VARCHAR(50) NOT NULL,
    CONSTRAINT pk_code_postaux PRIMARY KEY (code_postal)
);

CREATE TABLE secretariats
(
    id_secretaire TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nom           VARCHAR(20)      NOT NULL,
    prenom        VARCHAR(20)      NOT NULL,
    adresse       VARCHAR(50)      NOT NULL,
    code_postal   varchar(5)          NOT NULL,
    localite      VARCHAR(20)      NOT NULL,
    nr_telephone  VARCHAR(15),
    nr_fax        VARCHAR(15),
    email         VARCHAR(50),
    CONSTRAINT pk_secretariats PRIMARY KEY (id_secretaire),
    CONSTRAINT fk_secretariats_code_postaux FOREIGN KEY (code_postal)
        REFERENCES code_postaux (code_postal)
);

CREATE TABLE competitions
(
    id_competition TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    libelle        VARCHAR(40)      NOT NULL,
    organisateur   VARCHAR(100),
    CONSTRAINT pk_competitions PRIMARY KEY (id_competition)
);

CREATE TABLE organisateurs
(
    id_competition               TINYINT UNSIGNED NOT NULL,
    annee                        YEAR             NOT NULL,
    nbre_jours                   TINYINT UNSIGNED NOT NULL,
    id_secretariat               TINYINT UNSIGNED NOT NULL,
    droit_inscription_individuel DECIMAL(6, 2),
    droit_inscription_relais     DECIMAL(6, 2),
    forfait_par_course           DECIMAL(6, 2),
    CONSTRAINT pk_organisateurs PRIMARY KEY (id_competition, annee),
    CONSTRAINT fk_organisateurs_competitions FOREIGN KEY (id_competition)
        REFERENCES competitions (id_competition),
    CONSTRAINT fk_organisateurs_secretariats FOREIGN KEY (id_secretariat)
        REFERENCES secretariats (id_secretaire),
    CONSTRAINT chk_organisateurs_nbre_jours CHECK (nbre_jours > 0)
);

CREATE TABLE piscines
(
    id_piscine  TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nom         VARCHAR(50)      NOT NULL,
    adresse     VARCHAR(50)      ,
    code_postal varchar(5)          NOT NULL,
    lieu        VARCHAR(20)      NOT NULL,
    longueur    TINYINT UNSIGNED NOT NULL,
    nb_couloirs TINYINT UNSIGNED NOT NULL,
    CONSTRAINT pk_piscines PRIMARY KEY (id_piscine),
    CONSTRAINT fk_piscines_code_postaux FOREIGN KEY (code_postal)
        REFERENCES code_postaux (code_postal)
);

CREATE TABLE categories
(
    code_categorie varchar(2)          NOT NULL,
    lib_categorie  VARCHAR(20)      NOT NULL,
    age_min        TINYINT UNSIGNED ,
    age_max        TINYINT UNSIGNED ,
    CONSTRAINT pk_categories PRIMARY KEY (code_categorie),
    CONSTRAINT chk_categories_ages CHECK (age_min <= age_max)
);

CREATE TABLE clubs
(
    code_club            varchar(5)          NOT NULL,
    nom                  VARCHAR(50),
    id_secretariat       TINYINT UNSIGNED NOT NULL,
    nr_ligue_responsable varchar(14),
    nbre_nageurs         SMALLINT UNSIGNED DEFAULT 0,
    CONSTRAINT pk_clubs PRIMARY KEY (code_club),
    CONSTRAINT fk_clubs_secretariats FOREIGN KEY (id_secretariat)
        REFERENCES secretariats (id_secretaire)
);

CREATE TABLE nageurs
(
    nr_ligue        varchar(14)        NOT NULL,
    nom             VARCHAR(20)     NOT NULL,
    prenom          VARCHAR(20)     NOT NULL,
    annee_naissance YEAR            NOT NULL,
    sexe            ENUM ('M', 'F') NOT NULL,
    code_categorie  varchar(2),
    code_club       varchar(5),
    adresse         VARCHAR(50),
    code_postal     varchar(5),
    localite        VARCHAR(20),
    nr_telephone    VARCHAR(15),
    email           VARCHAR(50),
    gsm             VARCHAR(15),
    cotisation      ENUM ('O', 'N'),
    CONSTRAINT pk_nageurs PRIMARY KEY (nr_ligue),
    CONSTRAINT fk_nageurs_categories FOREIGN KEY (code_categorie)
        REFERENCES categories (code_categorie),
    CONSTRAINT fk_nageurs_clubs FOREIGN KEY (code_club)
        REFERENCES clubs (code_club),
    CONSTRAINT fk_nageurs_code_postaux FOREIGN KEY (code_postal)
        REFERENCES code_postaux (code_postal)
);

-- Ajout de la contrainte circulaire pour clubs
ALTER TABLE clubs
    ADD CONSTRAINT fk_clubs_nageurs FOREIGN KEY (nr_ligue_responsable)
        REFERENCES nageurs (nr_ligue) ON DELETE SET NULL;

CREATE TABLE juges
(
    id_juge   TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nom       VARCHAR(20)      NOT NULL,
    prenom    VARCHAR(20)      NOT NULL,
    code_club varchar(5),
    CONSTRAINT pk_juges PRIMARY KEY (id_juge),
    CONSTRAINT fk_juges_clubs FOREIGN KEY (code_club)
        REFERENCES clubs (code_club)
);

CREATE TABLE journees
(
    id_competition          TINYINT UNSIGNED NOT NULL,
    annee                   YEAR             NOT NULL,
    jour                    TINYINT UNSIGNED NOT NULL,
    date_heure_competition  DATETIME         NOT NULL,
    heure_echauffement      TIME,
    id_piscine              TINYINT UNSIGNED NOT NULL,
    id_juge                 TINYINT UNSIGNED,
    date_limite_inscription DATE,
    CONSTRAINT pk_journees PRIMARY KEY (id_competition, annee, jour),
    CONSTRAINT fk_journees_organisateurs FOREIGN KEY (id_competition, annee)
        REFERENCES organisateurs (id_competition, annee),
    CONSTRAINT fk_journees_piscines FOREIGN KEY (id_piscine)
        REFERENCES piscines (id_piscine),
    CONSTRAINT fk_journees_juges FOREIGN KEY (id_juge)
        REFERENCES juges (id_juge)
);

CREATE TABLE planning
(
    id_competition TINYINT UNSIGNED NOT NULL,
    annee          YEAR             NOT NULL,
    jour           TINYINT UNSIGNED NOT NULL,
    nr_course      TINYINT UNSIGNED NOT NULL,
    libelle        VARCHAR(100)     NOT NULL,
    distance       SMALLINT UNSIGNED,
    pause          BOOLEAN DEFAULT FALSE,
    CONSTRAINT pk_planning PRIMARY KEY (id_competition, annee, jour, nr_course),
    CONSTRAINT fk_planning_journees FOREIGN KEY (id_competition, annee, jour)
        REFERENCES journees (id_competition, annee, jour)
);

CREATE TABLE decisions
(
    code_decision varchar(2)      NOT NULL,
    libelle       VARCHAR(100) NOT NULL,
    CONSTRAINT pk_decisions PRIMARY KEY (code_decision)
);

CREATE TABLE resultats
(
    nr_ligue        varchar(14)         NOT NULL,
    id_competition  TINYINT UNSIGNED NOT NULL,
    annee           YEAR             NOT NULL,
    jour            TINYINT UNSIGNED NOT NULL,
    nr_course       TINYINT UNSIGNED NOT NULL,
    temps_reference TIME(2),
    temps_reel      TIME(2),
    place           TINYINT UNSIGNED,
    points          SMALLINT UNSIGNED,
    code_decision   varchar(2),
    code_categorie  varchar(2),
    code_club       varchar(5),
    CONSTRAINT pk_resultats PRIMARY KEY (nr_ligue, id_competition, annee, jour, nr_course),
    CONSTRAINT fk_resultats_nageurs FOREIGN KEY (nr_ligue)
        REFERENCES nageurs (nr_ligue),
    CONSTRAINT fk_resultats_planning FOREIGN KEY (id_competition, annee, jour, nr_course)
        REFERENCES planning (id_competition, annee, jour, nr_course),
    CONSTRAINT fk_resultats_decisions FOREIGN KEY (code_decision)
        REFERENCES decisions (code_decision),
    CONSTRAINT fk_resultats_categories FOREIGN KEY (code_categorie)
        REFERENCES categories (code_categorie),
    CONSTRAINT fk_resultats_clubs FOREIGN KEY (code_club)
        REFERENCES clubs (code_club)
);

COMMIT;

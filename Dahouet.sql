-- phpMyAdmin SQL Dump
-- version 4.6.6deb4
-- https://www.phpmyadmin.net/
--
-- Client :  localhost:3306
-- Généré le :  Ven 03 Novembre 2017 à 11:29
-- Version du serveur :  5.7.20-0ubuntu0.17.04.1
-- Version de PHP :  7.0.22-0ubuntu0.17.04.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `Dahouet`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `Procedure1` (IN `challenge_id` INT)  BEGIN
SELECT c.libelle AS CHALLENGE, AVG(r.distance) AS AVERAGE
FROM challenge c 
INNER JOIN regate r
ON c.id = r.challenge_id
WHERE c.id = challenge_id
GROUP BY c.libelle;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Procedure2` (IN `regate_id` INT, IN `voilier_id` INT)  NO SQL
BEGIN
SELECT prenom AS PRENOM, pe.nom AS NOM 
FROM personne pe
INNER JOIN participant pa
ON pa.personne_id = pe.id
INNER JOIN equipage eq 
ON pa.equipage_id = eq.id
INNER JOIN NAVIGUER n
ON n.equipage_id = eq.id
INNER JOIN voilier v
ON v.id = n.voilier_id
INNER JOIN PARTICIPE p
ON p.voilier_id = v.id
INNER JOIN regate r
ON r.id = p.regate_id 

WHERE v.id = voilier_id
AND r.id = regate_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Procedure3` (IN `challenge_id` INT, IN `date_debut` DATE, IN `date_fin` DATE)  NO SQL
SELECT r.date AS DATE, 
pe.prenom AS PRENOM, 
pe.nom AS NOM, 
co.libelle AS COMITE
FROM personne pe

INNER JOIN commissaire c
ON c.personne_id = pe.id
INNER JOIN comite co
ON co.id=c.comite_id
INNER JOIN regate r
ON c.regate_id = r.id
INNER JOIN challenge ch
ON ch.id = r.challenge_id

WHERE ch.id = challenge_id
AND r.date > date_debut
AND r.date < date_fin$$

--
-- Fonctions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `Fonction1` (`challenge_id` INT, `regate_date` DATE) RETURNS VARCHAR(255) CHARSET utf8 NO SQL
BEGIN
DECLARE CodeChallenge VARCHAR(11);
DECLARE MoisRegate DATE;
DECLARE NumRegate INT(11) DEFAULT 0;

SELECT c.id, regate_date, COUNT(r.id)+1
INTO CodeChallenge, MoisRegate, NumRegate
FROM challenge c
INNER JOIN regate r ON c.id = r.challenge_id 
WHERE c.id=challenge_id

GROUP BY c.id;

RETURN CONCAT(CodeChallenge, '-', MONTH(MoisRegate), '-', NumRegate);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `challenge`
--

CREATE TABLE `challenge` (
  `date_debut` date NOT NULL,
  `date_fin` date NOT NULL,
  `libelle` varchar(255) CHARACTER SET utf8 NOT NULL,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `challenge`
--

INSERT INTO `challenge` (`date_debut`, `date_fin`, `libelle`, `id`) VALUES
('2017-11-01', '2018-04-30', 'hiver2017', 1),
('2018-05-01', '2018-09-30', 'ete2018', 2);

-- --------------------------------------------------------

--
-- Structure de la table `classe`
--

CREATE TABLE `classe` (
  `nom` varchar(255) NOT NULL,
  `coefficient` varchar(255) NOT NULL,
  `serie_id` int(11) NOT NULL,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `classe`
--

INSERT INTO `classe` (`nom`, `coefficient`, `serie_id`, `id`) VALUES
('Corsaire', '0.5', 1, 1),
('Surprise', '0.6', 1, 2),
('8 mètres', '0.1', 1, 3),
('Maraudeur', '0.7', 1, 4),
('Figaro', '0.8', 1, 5),
('Flying fifteen', '0.4', 2, 6),
('Soling', '0.8', 2, 7),
('Star', '0.6', 2, 8),
('Tempest', '0.5', 2, 9),
('Yngling', '0.6', 2, 10),
('5.5', '0.6', 2, 11);

-- --------------------------------------------------------

--
-- Structure de la table `club`
--

CREATE TABLE `club` (
  `id` int(11) NOT NULL,
  `libelle` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `club`
--

INSERT INTO `club` (`id`, `libelle`) VALUES
(1, 'Club des bouees'),
(2, 'Club ded otaries');

-- --------------------------------------------------------

--
-- Structure de la table `code`
--

CREATE TABLE `code` (
  `id` int(11) NOT NULL,
  `code` varchar(255) NOT NULL,
  `libelle` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `comite`
--

CREATE TABLE `comite` (
  `id` int(11) NOT NULL,
  `libelle` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `comite`
--

INSERT INTO `comite` (`id`, `libelle`) VALUES
(1, 'Comite1'),
(2, 'Comite2');

-- --------------------------------------------------------

--
-- Structure de la table `commissaire`
--

CREATE TABLE `commissaire` (
  `id` int(11) NOT NULL,
  `comite_id` int(11) NOT NULL,
  `regate_id` int(11) NOT NULL,
  `personne_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `commissaire`
--

INSERT INTO `commissaire` (`id`, `comite_id`, `regate_id`, `personne_id`) VALUES
(1, 1, 1, 4),
(2, 1, 2, 5);

-- --------------------------------------------------------

--
-- Structure de la table `equipage`
--

CREATE TABLE `equipage` (
  `id` int(11) NOT NULL,
  `skipper` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `equipage`
--

INSERT INTO `equipage` (`id`, `skipper`) VALUES
(1, 0),
(2, 1);

-- --------------------------------------------------------

--
-- Structure de la table `juge`
--

CREATE TABLE `juge` (
  `id` int(11) NOT NULL,
  `nom` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `jury_id` int(11) NOT NULL,
  `personne_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `jury`
--

CREATE TABLE `jury` (
  `id` int(11) NOT NULL,
  `regate_id` int(11) NOT NULL,
  `personne_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `NAVIGUER`
--

CREATE TABLE `NAVIGUER` (
  `voilier_id` int(11) NOT NULL,
  `equipage_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `NAVIGUER`
--

INSERT INTO `NAVIGUER` (`voilier_id`, `equipage_id`) VALUES
(1, 1),
(2, 2);

-- --------------------------------------------------------

--
-- Structure de la table `participant`
--

CREATE TABLE `participant` (
  `id` int(11) NOT NULL,
  `personne_id` int(11) NOT NULL,
  `N_licence_FFV` varchar(9) NOT NULL,
  `date_de_naissance` int(11) NOT NULL,
  `equipage_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `participant`
--

INSERT INTO `participant` (`id`, `personne_id`, `N_licence_FFV`, `date_de_naissance`, `equipage_id`) VALUES
(1, 4, '59874126', 16051975, 2),
(2, 4, '584692322', 24518632, 1);

-- --------------------------------------------------------

--
-- Structure de la table `PARTICIPE`
--

CREATE TABLE `PARTICIPE` (
  `voilier_id` int(11) NOT NULL,
  `regate_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `PARTICIPE`
--

INSERT INTO `PARTICIPE` (`voilier_id`, `regate_id`) VALUES
(1, 1),
(2, 2);

-- --------------------------------------------------------

--
-- Structure de la table `personne`
--

CREATE TABLE `personne` (
  `id` int(11) NOT NULL,
  `nom` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `mdp` varchar(255) NOT NULL,
  `adresse1` varchar(255) NOT NULL,
  `adresse2` varchar(255) NOT NULL,
  `CP` int(5) NOT NULL,
  `ville` varchar(255) NOT NULL,
  `tel` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `personne`
--

INSERT INTO `personne` (`id`, `nom`, `prenom`, `email`, `mdp`, `adresse1`, `adresse2`, `CP`, `ville`, `tel`) VALUES
(1, 'Martin', 'Marcel', 'marcel.martin@test.fr', 'mdp', '10, test de test', '', 29000, 'TEST', 0),
(3, 'Letroc', 'Pierre', 'pierre.letroc@test.fr', 'mdp', '10, test de test', '', 29000, 'TEST', 0),
(4, 'Commissaire', 'Marcel', 'marcel.commissaire@test.fr', 'mdp', '10 rue de rien', '', 29000, 'RIEN', 0),
(5, 'Inspecteur', 'Michel', 'michel.inspecteur@test.fr', 'mdp', '85 impasse du chien', '', 85000, 'SANTAS', 0);

-- --------------------------------------------------------

--
-- Structure de la table `proprietaire`
--

CREATE TABLE `proprietaire` (
  `id` int(11) NOT NULL,
  `voilier_id` int(11) NOT NULL,
  `club_id` int(11) NOT NULL,
  `personne_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `proprietaire`
--

INSERT INTO `proprietaire` (`id`, `voilier_id`, `club_id`, `personne_id`) VALUES
(1, 1, 1, 3),
(2, 2, 1, 4);

-- --------------------------------------------------------

--
-- Structure de la table `regate`
--

CREATE TABLE `regate` (
  `id` int(11) NOT NULL,
  `date` date NOT NULL,
  `libelle` varchar(255) NOT NULL,
  `distance` int(10) NOT NULL,
  `challenge_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `regate`
--

INSERT INTO `regate` (`id`, `date`, `libelle`, `distance`, `challenge_id`) VALUES
(1, '2017-11-04', 'semaine44', 258, 1),
(2, '2017-11-17', 'semaine47', 583, 1);

--
-- Déclencheurs `regate`
--
DELIMITER $$
CREATE TRIGGER `trigger_de_creation` BEFORE INSERT ON `regate` FOR EACH ROW BEGIN
DECLARE DDEBUT DATE;
DECLARE DFIN DATE;
SELECT challenge.date_debut, challenge.date_fin
FROM challenge
INTO DDEBUT,DFIN;
IF DDEBUT > NEW.date OR DFIN < NEW.date
THEN
signal sqlstate '45000' set message_text = "'MyTriggerError: Trying to insert a date which is not in the challenge trigger_de_creation";
END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trigger_de_suppression` BEFORE DELETE ON `regate` FOR EACH ROW BEGIN
DECLARE DATEFIN DATE;
SELECT challenge.id 
INTO DATEFIN 
FROM challenge 
WHERE challenge.id = OLD.challenge_id;
IF now() < DATEFIN
THEN
signal sqlstate '45002' set message_text = 'Challenge non termine'; END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `resultat`
--

CREATE TABLE `resultat` (
  `id` int(11) NOT NULL,
  `voilier_id` int(11) NOT NULL,
  `code_id` int(11) NOT NULL,
  `temps_reel` int(11) NOT NULL,
  `temps_compose` int(11) NOT NULL,
  `regate_id` int(11) NOT NULL,
  `classement` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déclencheurs `resultat`
--
DELIMITER $$
CREATE TRIGGER `trigger_de_MAJ` BEFORE UPDATE ON `resultat` FOR EACH ROW BEGIN
DECLARE TOTALVOILIER INT;
SELECT COUNT(r.voilier_id)
INTO TOTALVOILIER
FROM resultat r 
WHERE r.regate_id=NEW.regate_id;
IF NEW.classement>TOTALVOILIER
THEN
signal sqlstate '45001' set message_text = "'MyTriggerError: hummmmmmm I think you have done something wrong trigger_de_MAJ";
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `serie`
--

CREATE TABLE `serie` (
  `nom` varchar(255) NOT NULL,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `serie`
--

INSERT INTO `serie` (`nom`, `id`) VALUES
('Habitable', 1),
('Quillard de sport', 2);

-- --------------------------------------------------------

--
-- Structure de la table `voilier`
--

CREATE TABLE `voilier` (
  `id` int(11) NOT NULL,
  `nom` varchar(255) NOT NULL,
  `classe_id` int(11) NOT NULL,
  `num_voile` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `voilier`
--

INSERT INTO `voilier` (`id`, `nom`, `classe_id`, `num_voile`) VALUES
(1, 'Cocotte', 5, 7),
(2, 'LoveMumForEver', 3, 22);

--
-- Index pour les tables exportées
--

--
-- Index pour la table `challenge`
--
ALTER TABLE `challenge`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `classe`
--
ALTER TABLE `classe`
  ADD PRIMARY KEY (`id`),
  ADD KEY `serie_id` (`serie_id`);

--
-- Index pour la table `club`
--
ALTER TABLE `club`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `code`
--
ALTER TABLE `code`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `comite`
--
ALTER TABLE `comite`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `commissaire`
--
ALTER TABLE `commissaire`
  ADD PRIMARY KEY (`id`),
  ADD KEY `comite_id` (`comite_id`),
  ADD KEY `regate_id` (`regate_id`),
  ADD KEY `personne_id` (`personne_id`);

--
-- Index pour la table `equipage`
--
ALTER TABLE `equipage`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `juge`
--
ALTER TABLE `juge`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jury_id` (`jury_id`),
  ADD KEY `personne_id` (`personne_id`);

--
-- Index pour la table `jury`
--
ALTER TABLE `jury`
  ADD PRIMARY KEY (`id`),
  ADD KEY `regate_id` (`regate_id`),
  ADD KEY `personne_id` (`personne_id`);

--
-- Index pour la table `NAVIGUER`
--
ALTER TABLE `NAVIGUER`
  ADD KEY `voilier_id` (`voilier_id`),
  ADD KEY `equipage_id` (`equipage_id`);

--
-- Index pour la table `participant`
--
ALTER TABLE `participant`
  ADD PRIMARY KEY (`id`),
  ADD KEY `personne_id` (`personne_id`),
  ADD KEY `equipage_id` (`equipage_id`);

--
-- Index pour la table `PARTICIPE`
--
ALTER TABLE `PARTICIPE`
  ADD PRIMARY KEY (`voilier_id`,`regate_id`),
  ADD KEY `regate_id` (`regate_id`);

--
-- Index pour la table `personne`
--
ALTER TABLE `personne`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `proprietaire`
--
ALTER TABLE `proprietaire`
  ADD PRIMARY KEY (`id`),
  ADD KEY `voilier_id` (`voilier_id`),
  ADD KEY `club_id` (`club_id`),
  ADD KEY `personne_id` (`personne_id`);

--
-- Index pour la table `regate`
--
ALTER TABLE `regate`
  ADD PRIMARY KEY (`id`),
  ADD KEY `challenge_id` (`challenge_id`);

--
-- Index pour la table `resultat`
--
ALTER TABLE `resultat`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bateau_id` (`voilier_id`),
  ADD KEY `code_id` (`code_id`),
  ADD KEY `regate_id` (`regate_id`);

--
-- Index pour la table `serie`
--
ALTER TABLE `serie`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `voilier`
--
ALTER TABLE `voilier`
  ADD PRIMARY KEY (`id`),
  ADD KEY `classe_id` (`classe_id`);

--
-- AUTO_INCREMENT pour les tables exportées
--

--
-- AUTO_INCREMENT pour la table `challenge`
--
ALTER TABLE `challenge`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT pour la table `classe`
--
ALTER TABLE `classe`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
--
-- AUTO_INCREMENT pour la table `club`
--
ALTER TABLE `club`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT pour la table `code`
--
ALTER TABLE `code`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `comite`
--
ALTER TABLE `comite`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT pour la table `commissaire`
--
ALTER TABLE `commissaire`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT pour la table `equipage`
--
ALTER TABLE `equipage`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT pour la table `juge`
--
ALTER TABLE `juge`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `jury`
--
ALTER TABLE `jury`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `participant`
--
ALTER TABLE `participant`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT pour la table `personne`
--
ALTER TABLE `personne`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT pour la table `proprietaire`
--
ALTER TABLE `proprietaire`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT pour la table `regate`
--
ALTER TABLE `regate`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT pour la table `resultat`
--
ALTER TABLE `resultat`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `serie`
--
ALTER TABLE `serie`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT pour la table `voilier`
--
ALTER TABLE `voilier`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `classe`
--
ALTER TABLE `classe`
  ADD CONSTRAINT `classe_ibfk_1` FOREIGN KEY (`serie_id`) REFERENCES `serie` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `commissaire`
--
ALTER TABLE `commissaire`
  ADD CONSTRAINT `commissaire_ibfk_1` FOREIGN KEY (`personne_id`) REFERENCES `personne` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `commissaire_ibfk_2` FOREIGN KEY (`comite_id`) REFERENCES `comite` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `commissaire_ibfk_3` FOREIGN KEY (`regate_id`) REFERENCES `regate` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `juge`
--
ALTER TABLE `juge`
  ADD CONSTRAINT `juge_ibfk_1` FOREIGN KEY (`personne_id`) REFERENCES `personne` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `juge_ibfk_2` FOREIGN KEY (`jury_id`) REFERENCES `jury` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `jury`
--
ALTER TABLE `jury`
  ADD CONSTRAINT `jury_ibfk_2` FOREIGN KEY (`regate_id`) REFERENCES `regate` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `NAVIGUER`
--
ALTER TABLE `NAVIGUER`
  ADD CONSTRAINT `NAVIGUER_ibfk_1` FOREIGN KEY (`voilier_id`) REFERENCES `voilier` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `NAVIGUER_ibfk_2` FOREIGN KEY (`equipage_id`) REFERENCES `equipage` (`id`);

--
-- Contraintes pour la table `participant`
--
ALTER TABLE `participant`
  ADD CONSTRAINT `participant_ibfk_1` FOREIGN KEY (`personne_id`) REFERENCES `personne` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `participant_ibfk_2` FOREIGN KEY (`equipage_id`) REFERENCES `equipage` (`id`);

--
-- Contraintes pour la table `PARTICIPE`
--
ALTER TABLE `PARTICIPE`
  ADD CONSTRAINT `PARTICIPE_ibfk_1` FOREIGN KEY (`voilier_id`) REFERENCES `voilier` (`id`),
  ADD CONSTRAINT `PARTICIPE_ibfk_2` FOREIGN KEY (`regate_id`) REFERENCES `regate` (`id`);

--
-- Contraintes pour la table `proprietaire`
--
ALTER TABLE `proprietaire`
  ADD CONSTRAINT `proprietaire_ibfk_1` FOREIGN KEY (`personne_id`) REFERENCES `personne` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `proprietaire_ibfk_2` FOREIGN KEY (`voilier_id`) REFERENCES `voilier` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `proprietaire_ibfk_3` FOREIGN KEY (`club_id`) REFERENCES `club` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `regate`
--
ALTER TABLE `regate`
  ADD CONSTRAINT `regate_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenge` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `resultat`
--
ALTER TABLE `resultat`
  ADD CONSTRAINT `resultat_ibfk_1` FOREIGN KEY (`code_id`) REFERENCES `code` (`id`),
  ADD CONSTRAINT `resultat_ibfk_2` FOREIGN KEY (`voilier_id`) REFERENCES `voilier` (`id`),
  ADD CONSTRAINT `resultat_ibfk_3` FOREIGN KEY (`regate_id`) REFERENCES `regate` (`id`);

--
-- Contraintes pour la table `voilier`
--
ALTER TABLE `voilier`
  ADD CONSTRAINT `voilier_ibfk_2` FOREIGN KEY (`classe_id`) REFERENCES `classe` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

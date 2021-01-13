CREATE DATABASE medicina;
USE medicina;

CREATE TABLE grad (
	id				INTEGER PRIMARY KEY,
    naziv			VARCHAR(100) NOT NULL,
    post_broj		CHAR(5) UNIQUE NOT NULL,
    CHECK (length(post_broj) = 5)
);

CREATE TABLE specijalizacija (
	id				INTEGER PRIMARY KEY,
    naziv			VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE dijagnoza (
	id				INTEGER PRIMARY KEY,
    naziv			VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE terapija (
	id				INTEGER PRIMARY KEY,
    naziv 			VARCHAR(50) NOT NULL,
    jacina_sadrzaj	VARCHAR(50) NOT NULL,
    doplata			NUMERIC(5,2) NOT NULL,
    CHECK (doplata >= 0)
);

CREATE TABLE bolnica (
	id 				INTEGER PRIMARY KEY,
    naziv			VARCHAR(100) NOT NULL,
    adresa			VARCHAR(50) NOT NULL,
    id_grad			INTEGER NOT NULL,
    FOREIGN KEY (id_grad) REFERENCES grad(id) ON DELETE CASCADE
);

CREATE TABLE apoteka (
	id				INTEGER PRIMARY KEY,
    naziv			VARCHAR(100) NOT NULL,
    adresa			VARCHAR(50) NOT NULL,
    id_grad 		INTEGER NOT NULL,
    FOREIGN KEY (id_grad) REFERENCES grad(id) ON DELETE CASCADE		
);

CREATE TABLE osoba (
	id				INTEGER PRIMARY KEY,
    ime				VARCHAR(20) NOT NULL,
    prezime			VARCHAR(30) NOT NULL,
    spol			CHAR(1) NOT NULL,
    datum_rodjenja	DATE NOT NULL,
    mbo				CHAR(9) UNIQUE NOT NULL,
    mjesto_stan		INTEGER,
    FOREIGN KEY (mjesto_stan) REFERENCES grad(id) ON DELETE SET NULL,
    CHECK (length(mbo) = 9),
    CHECK (spol IN ('M', 'Å½'))
 );
 
 CREATE TABLE lijecnik (
	id				INTEGER PRIMARY KEY,
    id_osoba		INTEGER UNIQUE NOT NULL,
    id_bolnica 		INTEGER,
    id_spec 		INTEGER NOT NULL,
    FOREIGN KEY (id_osoba) REFERENCES osoba(id) ON DELETE CASCADE,
    FOREIGN KEY (id_bolnica) REFERENCES bolnica(id) ON DELETE SET NULL,
    FOREIGN KEY (id_spec) REFERENCES specijalizacija(id) ON UPDATE CASCADE
);

CREATE TABLE apoteka_stanje (
	 id_apoteka 	INTEGER NOT NULL,
     id_terapija 	INTEGER NOT NULL,
     kolicina		INTEGER NOT NULL,
     FOREIGN KEY (id_apoteka) REFERENCES apoteka(id) ON DELETE CASCADE,
     FOREIGN KEY (id_terapija) REFERENCES terapija(id) ON DELETE CASCADE,
     PRIMARY KEY (id_apoteka, id_terapija),
     CHECK (kolicina >= 0)
);

CREATE TABLE pacijent_dijagnoza (
	id_pacijent		INTEGER NOT NULL,
    id_lijecnik		INTEGER NOT NULL,
    id_dijagnoza	INTEGER NOT NULL,
	id_terapija 	INTEGER,
    FOREIGN KEY (id_pacijent) REFERENCES osoba(id) ON DELETE CASCADE,
    FOREIGN KEY (id_lijecnik) REFERENCES lijecnik(id) ON DELETE CASCADE,
    FOREIGN KEY (id_dijagnoza) REFERENCES dijagnoza(id) ON DELETE CASCADE,
	FOREIGN KEY (id_terapija) REFERENCES terapija(id) ON DELETE SET NULL,
    PRIMARY KEY (id_pacijent, id_lijecnik, id_dijagnoza)
);

CREATE TABLE evidencija_smrti (
	id_pacijent	 INTEGER NOT NULL,
    razlog_smrti INTEGER NOT NULL,
    datum_smrti	 DATE NOT NULL,
    FOREIGN KEY (id_pacijent) REFERENCES osoba(id) ON DELETE CASCADE,
    FOREIGN KEY (razlog_smrti) REFERENCES dijagnoza(id),
    PRIMARY KEY (id_pacijent)
);

DELIMITER //
CREATE TRIGGER istaOsoba BEFORE INSERT ON pacijent_dijagnoza
FOR EACH ROW
BEGIN
	IF (SELECT id_osoba FROM lijecnik 
		WHERE id = new.id_lijecnik) = new.id_pacijent
	THEN SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Lijecnik ne moze sam sebi postaviti dijagnozu!';
    END IF;
END;//
LOAD DATA INFILE '/var/lib/mysql-files/grad.csv' 
INTO TABLE grad 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/var/lib/mysql-files/specijalizacija.csv' 
INTO TABLE specijalizacija 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/var/lib/mysql-files/dijagnoza.csv' 
INTO TABLE dijagnoza 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/var/lib/mysql-files/terapija.csv' 
INTO TABLE terapija 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/var/lib/mysql-files/bolnica.csv' 
INTO TABLE bolnica 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/var/lib/mysql-files/apoteka.csv' 
INTO TABLE apoteka 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/var/lib/mysql-files/osoba.csv' 
INTO TABLE osoba 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/var/lib/mysql-files/lijecnik.csv' 
INTO TABLE lijecnik 
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/var/lib/mysql-files/apoteka_stanje.csv' 
INTO TABLE apoteka_stanje 
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/var/lib/mysql-files/pacijent_dijagnoza.csv' 
INTO TABLE pacijent_dijagnoza
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_pacijent, id_lijecnik, id_dijagnoza, @terapija)
SET id_terapija = NULLIF(@terapija, 0);

LOAD DATA INFILE '/var/lib/mysql-files/evidencija_smrti.csv' 
INTO TABLE evidencija_smrti
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
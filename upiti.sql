-- 1. ispiši sve dijagnoze (jednostavan upit za uspostavljanje bazične sintakse, SELECT)
SELECT * FROM dijagnoza;

-- 2. izlistaj sve liječnike (spajanje dviju tablica korištenjem JOIN-a i stranih ključeva)
SELECT *
	FROM osoba 
    JOIN lijecnik ON osoba.id = lijecnik.id_osoba;
    
 -- 3. pronađi sve osobe koje su starije životne dobi (npr. 60 nadalje) (funkcija DATEDIFF i algebarsko prilagođavanje njenoj povratnoj vrijednosti)
 SELECT *
	FROM osoba
    WHERE DATEDIFF(CURDATE(), datum_rodjenja) > 60*365;    
    
-- 4. pronađi sve liječnike u nekoj bolnici (spajanje triju tablica i postavljanje ograničenja koristeći WHERE)
SELECT osoba.*, dok.id 
	FROM osoba 
    JOIN lijecnik AS dok ON osoba.id = dok.id_osoba
    JOIN bolnica ON bolnica.id = dok.id_bolnica
    WHERE bolnica.naziv = 'Klinički bolnički centar Zagreb';
    
-- 5. pronađi sve liječnike koji rade u nekom gradu (spajanje četiriju tablica)
SELECT osoba.*, bolnica.naziv 
	FROM osoba 
    JOIN lijecnik ON osoba.id = lijecnik.id_osoba
    JOIN bolnica ON bolnica.id = lijecnik.id_bolnica
    JOIN grad ON grad.id = bolnica.id_grad
    WHERE grad.naziv = 'Zagreb';

-- 6. izlistaj sve pacijente koji su preminuli i dodatni stupac njihove navršene godine života (CAST(...) AS UNSIGNED)
SELECT *, CAST(DATEDIFF(datum_smrti, datum_rodjenja)/365 AS UNSIGNED) AS dob 
	FROM osoba 
	JOIN evidencija_smrti AS evi_smrt ON osoba.id = evi_smrt.id_pacijent;

 -- 7. pronađi sve liječnike koji trebaju odobrenje nadređenog da bi nastavili raditi (npr. u dobi od 65 na dalje)
 -- (različiti načini prilagođavanja povratnoj vrijednosti funkcije DATEDIFF u istom upitu)
 SELECT *, CAST(DATEDIFF(CURDATE(), datum_rodjenja)/365 AS UNSIGNED) AS dob
	FROM osoba 
    JOIN lijecnik ON osoba.id = lijecnik.id_osoba
    WHERE DATEDIFF(CURDATE(), datum_rodjenja) > 65*365;
    
-- 8. vrati opskrbljenost bolnica (koliko liječnika ima bolnica, poredaj od najpotrebnijih tj. onih s najmanjim brojem osoblja) (COUNT(), GROUP BY i ORDER BY)
 SELECT bol.naziv, COUNT(*) AS broj_specijalista
	FROM bolnica AS bol
      JOIN lijecnik ON bol.id = lijecnik.id_bolnica
      GROUP BY bol.id
      ORDER BY broj_specijalista ASC;     
    
-- 9. izlistaj terapije kojih sveukupno u svim apotekama nema više od 50 komada (COALESCE(), SUM(), LEFT JOIN, HAVING)
SELECT terapija.*, COALESCE(SUM(kolicina), 0) AS ukupna_kolicina
	FROM terapija 
    LEFT JOIN apoteka_stanje ON apoteka_stanje.id_terapija = terapija.id 
    GROUP BY terapija.id
    HAVING ukupna_kolicina < 50
    ORDER BY ukupna_kolicina ASC;
    
-- 10. vrati 2 stupca: koliko ljudi prima terapiju za svoju dijagnozu i koliko ljudi ne prima terapiju za svoju dijagnozu 
-- (svaki stupac je posebna povratna vrijednost različitog upit)
SELECT 
	* FROM (
		SELECT COUNT(*) AS pacijenti_bez_terapije FROM pacijent_dijagnoza WHERE id_terapija IS NULL
	) AS broj_pacijenata_bez_terapije, (
		SELECT COUNT(*) AS pacijenti_sa_terapijom FROM pacijent_dijagnoza WHERE id_terapija IS NOT NULL
	) AS broj_pacijenata_sa_terapijom;
    
-- 11. izlistaj sve liječnike koji primaju neku terapiju (primjer: tražimo nekog tko ne bi trebao raditi sa simptomima koje stvara ta terapija) (AS)
SELECT osoba_dok.*, dok.*, terapija.jacina_sadrzaj 
	FROM osoba AS osoba_dok
    JOIN lijecnik AS dok ON osoba_dok.id = dok.id_osoba
    JOIN pacijent_dijagnoza AS pd ON pd.id_pacijent = dok.id_osoba
    JOIN terapija ON pd.id_terapija = terapija.id
    WHERE terapija.naziv = 'Aerius';

-- 12. pronađi top 3 najsmrtonosnijih bolesti u tekućem mjesecu (MONTH(), LIMIT)
SELECT dijagnoza.*, COUNT(*) broj_preminulih
	FROM dijagnoza
    JOIN evidencija_smrti AS ev_smrt ON dijagnoza.id = ev_smrt.razlog_smrti
    WHERE MONTH(ev_smrt.datum_smrti) = MONTH(CURDATE())
    GROUP BY dijagnoza.id
    ORDER BY broj_preminulih DESC
    LIMIT 3;
    
-- 13. izlistaj sve specijalizacije koje imaju manje od 5 specijalista
SELECT spec.*, COALESCE(COUNT(dok.id), 0) AS broj_spec
	FROM specijalizacija AS spec
    LEFT JOIN lijecnik AS dok ON dok.id_spec = spec.id
    GROUP BY spec.id
    HAVING broj_spec < 5
    ORDER BY broj_spec;

-- 14. izlistaj apoteke koje imaju neku terapiju, poredaj od najveće količine prema najmanjoj
SELECT apo.*, ap_st.kolicina
	FROM apoteka AS apo
    JOIN apoteka_stanje AS ap_st ON apo.id = ap_st.id_apoteka
    JOIN terapija AS ter ON ap_st.id_terapija = ter.id
    WHERE ter.naziv = 'Ofev'
    ORDER BY kolicina DESC;

-- 15. pronađi baš sve osobe kojima je neki liječnik postavio dijagnozu, čija su nam ime i prezime poznati (AND)
SELECT DISTINCT dok.id, pac.* 
	FROM osoba AS osoba_dok
    JOIN lijecnik AS dok ON osoba_dok.id = dok.id_osoba
    JOIN pacijent_dijagnoza AS pd ON dok.id = pd.id_lijecnik
    JOIN osoba AS pac ON pac.id = pd.id_pacijent
    WHERE osoba_dok.ime = 'Karlo' AND osoba_dok.prezime = 'Mikulić';
    
-- 16. prikaži sve bolnice bez osoblja (za potrebe zatvaranja) (CREATE VIEW)
CREATE VIEW bolnice_bez_osoblja AS 
SELECT bolnica.*, COALESCE(COUNT(lijecnik.id), 0) AS broj_specijalista
	FROM bolnica
    LEFT JOIN lijecnik ON bolnica.id = lijecnik.id_bolnica
    GROUP BY bolnica.id
    HAVING broj_specijalista = 0
    ORDER BY broj_specijalista ASC;   

-- 17. vrati top 10 gradova koji imaju najviše stanovnika ali nemaju bolnicu (npr. planiramo kamo sagraditi novu bolnicu) (NOT IN)
SELECT grad.*, COALESCE(COUNT(osoba.id), 0) AS broj_stanovnika
	FROM grad
    LEFT JOIN osoba ON grad.id = osoba.mjesto_stan
    GROUP BY grad.id
    HAVING grad.id NOT IN (SELECT id_grad FROM bolnica)
    ORDER BY broj_stanovnika DESC
    LIMIT 10;

-- 18. izlistaj sve osobe koje su liječnici i kojima je postavljena određena dijagnoza (npr. da su zaraženi COVID-om)
SELECT osoba.*, dijagnoza.* 
	FROM lijecnik
    JOIN osoba ON osoba.id = lijecnik.id_osoba
    JOIN pacijent_dijagnoza AS pd ON pd.id_pacijent = osoba.id
    JOIN dijagnoza ON dijagnoza.id = pd.id_dijagnoza
    WHERE dijagnoza.id = 567;

-- 19. vrati broj umrlih u svakoj godini i koliko godina su u prosjeku imali ti koji su umrli (YEAR(), AVG(), ugnježđeni upit)
SELECT YEAR(datum_smrti) AS godina_smrti, COUNT(*) AS broj_umrlih, CAST(prosjecna_dob_umrlih AS UNSIGNED) prosjecna_starost_umrlih
	FROM evidencija_smrti 
    JOIN (SELECT YEAR(datum_smrti) AS god_smrt, AVG(DATEDIFF(datum_smrti, datum_rodjenja) / 365) AS prosjecna_dob_umrlih
			FROM evidencija_smrti 
			JOIN osoba ON osoba.id = evidencija_smrti.id_pacijent
            GROUP BY YEAR(datum_smrti)) AS pros_dob_umrli ON pros_dob_umrli.god_smrt = YEAR(datum_smrti)
	GROUP BY godina_smrti;

-- 20. vrati top 10 najzauzetijih doktora (doktora koji imaju najviše dijagnosticiranih pacijenata) i broj njihovih pacijenata
SELECT osoba_dok.*, COUNT(pac.id) AS broj_pacijenata
	FROM osoba AS osoba_dok
    JOIN lijecnik AS dok ON osoba_dok.id = dok.id_osoba
    JOIN pacijent_dijagnoza AS pd ON dok.id = pd.id_lijecnik
    JOIN osoba AS pac ON pac.id = pd.id_pacijent
    GROUP BY dok.id
    ORDER BY broj_pacijenata DESC
    LIMIT 10;

-- 21. izlistaj doktore kojima je u zadnjih godinu dana umrlo više od 5 pacijenata (WHERE -> GROUP BY -> HAVING)
SELECT osoba_dok.*, COUNT(osoba_pac.id) AS broj_preminulih_pacijenata
	FROM lijecnik AS dok
    JOIN osoba AS osoba_dok ON osoba_dok.id = dok.id_osoba
    JOIN pacijent_dijagnoza AS pd ON pd.id_lijecnik = dok.id
    JOIN osoba AS osoba_pac ON osoba_pac.id = pd.id_pacijent
    JOIN evidencija_smrti AS evid_smrt ON osoba_pac.id = evid_smrt.id_pacijent
    WHERE DATEDIFF(CURDATE(), datum_smrti) < 365
    GROUP BY dok.id
    HAVING broj_preminulih_pacijenata > 5;
    
-- 22. dodaj novospecijaliziranog liječnika u bazu (INSERT)
INSERT INTO lijecnik VALUES (20022, 50033, 22005, 143);

-- 23. povećaj doplatu svih lijekova koji se već naplaćuju za 5% (UPDATE)
UPDATE terapija
	SET doplata = doplata + (0.05 * doplata)
	WHERE id IN (SELECT * 
					FROM (SELECT id 
							FROM terapija 
                            WHERE doplata > 0) AS terapija_doplata);
    
-- 24. otpusti sve liječnike starije od 80 godina (DELETE)
DELETE FROM lijecnik 
	WHERE id_osoba IN (SELECT id 
						FROM osoba 
                        WHERE DATEDIFF(CURDATE(), datum_rodjenja) > 80*365);

-- 25. Povijest pacijenta, dijagnoza, ljecnik, ljekovi, terapije	(IS NOT NULL)

SELECT 
    oso.ime,
    oso.prezime,
    dij.naziv,
    ter.naziv,
    ter.jacina_sadrzaj
FROM
    osoba oso
        LEFT JOIN
    pacijent_dijagnoza p_dij ON p_dij.id_pacijent = oso.id
        LEFT JOIN
    terapija ter ON ter.id = p_dij.id_terapija
        LEFT JOIN
    dijagnoza dij ON dij.id = p_dij.id_dijagnoza
WHERE
    p_dij.id_dijagnoza IS NOT NULL;


-- 26. Sve osobe koje nisu lijecnici	(NOT IN, CREATE VIEW, CHECK)
CREATE VIEW not_lijecnik AS
    (SELECT 
        *
    FROM
        osoba
    WHERE
        id NOT IN (SELECT 
                id_osoba
            FROM
                lijecnik)) WITH CHECK OPTION;
		-- Provjera
SELECT 
    *
FROM
    not_lijecnik;
insert into not_lijecnik values (50200,'ime11','prezime22','M',str_to_date('11.3.1994','%d.%m.%Y'),'123456789',49000);


-- 27. Upis novog doktora 'Lukas Rusac', specijalizirao Neurologiju, jos nije zaposlen	(INSERT)
		SELECT 
    *
FROM
    lijecnik
WHERE
    id_osoba IN (SELECT 
            id
        FROM
            osoba
        WHERE
            ime = 'Lukas' AND prezime = 'Rusac');
		-- nije, sad insert
        
insert into lijecnik value	(
							(select max(id)+1 from lijecnik l1),
							(select id from osoba where ime='Lukas' and prezime='Rusac'),
							null,
							(select id from specijalizacija where naziv='Neurologija')
                            );


-- 28. Brisanje lijecnika Lukas Rusac	(DELETE)

DELETE FROM lijecnik 
WHERE
    id_osoba IN (SELECT 
        id
    FROM
        osoba
    
    WHERE
        ime = 'Lukas' AND prezime = 'Rusac');


-- 29. Preminulih u danjih mjesec dana	(DATE_SUB, NOW, INTERVAL)

SELECT 
    COUNT(*) br_umrlih
FROM
    evidencija_smrti
WHERE
    datum_smrti > DATE_SUB(NOW(), INTERVAL 1 MONTH);


-- 30. Koliko ljudi prosjecno umre svaki mjesec tokom zadnjih godinu dana	(ROUND, AVG)

SELECT 
    ROUND(AVG(po_mj))
FROM
    (SELECT 
        COUNT(*) po_mj
    FROM
        evidencija_smrti
    GROUP BY MONTH(datum_smrti)) mj;


-- 40. Mjesec u kojem ljudi najvise umiru	(MONTH, GROUP, ORDER, LIMIT)

SELECT 
    MONTH(datum_smrti) mjesec, COUNT(*) br_preminulih
FROM
    evidencija_smrti
GROUP BY MONTH(datum_smrti)
ORDER BY br_preminulih DESC
LIMIT 1;


-- 41. Dali je osobi postavljena dijagnoza?	(CASE)

SELECT 
    o.ime,
    o.prezime,
    CASE
        WHEN id_dijagnoza IS NULL THEN 'Nije'
        ELSE 'Je'
    END dijagnoza_postavljena
FROM
    osoba o
        LEFT JOIN
    pacijent_dijagnoza pd ON pd.id_pacijent = o.id;



-- 42. Lijecnik i pacijet koji zive u istom gradu	(OUTER JOIN, USING)


SELECT 
    o.ime ime_lijecnik,
    o.prezime prezime_lijecnik,
    pac.ime ime_pacijent,
    pac.prezime prezime_pacijent,
    grad.naziv
FROM
    pacijent_dijagnoza p
        LEFT JOIN
    lijecnik l ON l.id = p.id_lijecnik
        LEFT JOIN
    osoba o ON l.id_osoba = o.id
        LEFT JOIN
    grad ON grad.id = o.mjesto_stan
        LEFT JOIN
    osoba pac USING (mjesto_stan);


-- 43. Dodaj 'R.I.P.' pored imena umrlih	(CONCAT, EXISTS)

UPDATE osoba 
SET 
    ime = CONCAT(ime, ' R.I.P.')
WHERE
    EXISTS( SELECT 
            id_pacijent
        FROM
            evidencija_smrti es
        WHERE
            es.id_pacijent = osoba.id);


-- 44. Dijagnoza	(COALESCE)

SELECT 
    id_pacijent, COALESCE(id_terapija, 'Nema') dijagnoza
FROM
    pacijent_dijagnoza;


-- 45. Koliko terapija primaju osobe koje primaju vise od jedne terapije?	(CASE)

SELECT 
    o.ime ime_pacijent,
    o.prezime prezime_pacijent,
    CASE COUNT(*)
        WHEN
            (SELECT 
                    COUNT(*) max
                FROM
                    pacijent_dijagnoza
                GROUP BY id_pacijent
                HAVING COUNT(*) >= 2
                ORDER BY COUNT(*) DESC
                LIMIT 1)
        THEN
            'Najvise'
        WHEN
            (SELECT 
                    COUNT(*) min
                FROM
                    pacijent_dijagnoza
                GROUP BY id_pacijent
                HAVING COUNT(*) >= 2
                ORDER BY COUNT(*) ASC
                LIMIT 1)
        THEN
            'Najmanje'
        ELSE 'Sredina'
    END AS test
FROM
    pacijent_dijagnoza pd
        LEFT JOIN
    osoba o ON o.id = pd.id_pacijent
GROUP BY id_pacijent
HAVING COUNT(*) >= 2;


-- 46. Najgori lijecnik, drugi po redu (LIMIT OFFSET)
    
SELECT 
    lij.ime ime_lijecnik, lij.prezime prezime_lijecnik
FROM
    evidencija_smrti es
        LEFT JOIN
    osoba o ON o.id = es.id_pacijent
        LEFT JOIN
    pacijent_dijagnoza pd ON pd.id_pacijent = o.id
        LEFT JOIN
    lijecnik l ON l.id = pd.id_lijecnik
        LEFT JOIN
    osoba lij ON l.id_osoba = lij.id
GROUP BY lij.id
ORDER BY COUNT(*) DESC
LIMIT 1 , 1

  
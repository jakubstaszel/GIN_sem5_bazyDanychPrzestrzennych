-- 2. Utwórz pustą bazę danych.
CREATE DATABASE "BDP_2"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
	
-- 3. Dodaj funkcjonalności PostGIS’a do bazy poleceniem CREATE EXTENSION postgis;
CREATE EXTENSION postgis;

-- 4. Na podstawie poniższej mapy utwórz trzy tabele: budynki (id, geometria, nazwa), drogi (id, geometria, nazwa), punkty_informacyjne (id, geometria, nazwa).
CREATE TABLE budynki(
	id INT,
	geometria GEOMETRY,
	nazwa VARCHAR(50)
);
SELECT * FROM budynki;
CREATE TABLE drogi(
	id INT,
	geometria GEOMETRY,
	nazwa VARCHAR(50)
);
SELECT * FROM drogi;
CREATE TABLE punkty_informacyjne(
	id INT,
	geometria GEOMETRY,
	nazwa VARCHAR(50)
);
SELECT * FROM punkty_informacyjne;

-- 5. Współrzędne obiektów oraz nazwy (np. BuildingA) należy odczytać z mapki umieszczonej poniżej. Układ współrzędnych ustaw jako niezdefiniowany.
INSERT INTO budynki VALUES (1, ST_GeomFromText('POLYGON((1 1, 2 1, 2 2, 1 2, 1 1))', 0), 'BuildingF');
INSERT INTO budynki VALUES (2, ST_GeomFromText('POLYGON((8 1.5, 10.5 1.5, 10.5 4, 8 4, 8 1.5))', 0), 'BuildingA');
INSERT INTO budynki VALUES (3, ST_GeomFromText('POLYGON((4 5, 6 5, 6 7, 4 7, 4 5))', 0), 'BuildingB');
INSERT INTO budynki VALUES (4, ST_GeomFromText('POLYGON((3 6, 5 6, 5 8, 3 8, 3 6))', 0), 'BuildingC');
INSERT INTO budynki VALUES (5, ST_GeomFromText('POLYGON((9 8, 10 8, 10 9, 9 9, 9 8))', 0), 'BuildingD');
SELECT * FROM budynki;
INSERT INTO drogi VALUES (1, ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)', 0), 'RoadX');
INSERT INTO drogi VALUES (2, ST_GeomFromText('LINESTRING(7.5 0, 7.5 10.5)', 0), 'Roady');
SELECT * FROM drogi;
INSERT INTO punkty_informacyjne VALUES (1, ST_GeomFromText('POINT(1 3.5)', 0), 'G');
INSERT INTO punkty_informacyjne VALUES (2, ST_GeomFromText('POINT(5.5 1.5)', 0), 'H');
INSERT INTO punkty_informacyjne VALUES (3, ST_GeomFromText('POINT(6.5 6)', 0), 'J');
INSERT INTO punkty_informacyjne VALUES (4, ST_GeomFromText('POINT(6 9.5)', 0), 'K');
INSERT INTO punkty_informacyjne VALUES (5, ST_GeomFromText('POINT(9.5 6)', 0), 'I');
SELECT * FROM punkty_informacyjne;
-- 6. Na bazie przygotowanych tabel wykonaj poniższe polecenia:
--     a. Wyznacz całkowitą długość dróg w analizowanym mieście.
SELECT SUM(ST_Length(geometria)) AS calkowita_dlugosc_drog FROM drogi;

--     b. Wypisz geometrię (WKT), pole powierzchni oraz obwód poligonu reprezentującego budynek o nazwie BuildingA.
SELECT ST_AsText(geometria) AS geometria, ST_Area(geometria) AS pole_powierzchni, ST_Perimeter(geometria) AS obwod FROM budynki
	WHERE nazwa='BuildingA';

--     c. Wypisz nazwy i pola powierzchni wszystkich poligonów w warstwie budynki. Wyniki posortuj alfabetycznie.
SELECT nazwa, ST_Area(geometria) AS pole_powierzchni FROM budynki
	ORDER BY nazwa;
--     d. Wypisz nazwy i obwody 2 budynków o największej powierzchni.
SELECT nazwa, ST_Perimeter(geometria) AS obwod FROM budynki
 ORDER BY obwod DESC 
 LIMIT 2;

--     e. Wyznacz najkrótszą odległość między budynkiem BuildingC a punktem G.
SELECT ST_Distance(B.geometria, PI.geometria) AS odleglosc_punktG_budynekC FROM punkty_informacyjne PI, budynki B
	WHERE B.nazwa='BuildingC' AND PI.nazwa='G';

--     f. Wypisz pole powierzchni tej części budynku BuildingC, która znajduje się w odległości większej niż 0.5 od budynku BuildingB.
CREATE TABLE buffer AS SELECT ST_Buffer(geometria, 0.5) FROM budynki WHERE nazwa='BuildingB';
SELECT * FROM buffer;
SELECT -1 * (ST_AREA(B.geometria) - ST_AREA(Buf.st_buffer)) AS pole_powierzchni FROM budynki B, buffer Buf WHERE B.nazwa='BuildingC';
--     g. Wybierz te budynki, których centroid (ST_Centroid) znajduje się powyżej drogi o nazwie RoadX.
SELECT B.nazwa, B.geometria, ST_CENTROID(B.geometria) FROM budynki B, drogi D WHERE ST_CENTROID(B.geometria) > D.geometria AND D.nazwa='RoadX';
 
--     h. Oblicz pole powierzchni tych części budynku BuildingC i poligonu o współrzędnych (4 7, 6 7, 6 8, 4 8, 4 7), które nie są wspólne dla tych dwóch obiektów.
SELECT ST_Area(ST_Difference(geometria, ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))', 0))) AS pole_powierzchni_roznicy FROM budynki 
	WHERE nazwa='BuildingC';
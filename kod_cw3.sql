CREATE EXTENSION postgis;

--- wykorzystane dane: https://qgis.org/downloads/data/qgis_sample_data.zip
--- pliki zaimportowane przy pomocy wtyczki PostGIS DBF Loader

--- 4. Wyznacz liczbę budynków (tabela: popp, atrybut: f_codedesc, reprezentowane, jako punkty) położonych w odległości mniejszej 
---     niż 100000 m od głównych rzek. Budynki spełniające to kryterium zapisz do osobnej tabeli tableB.
CREATE TABLE tableB AS
SELECT ST_Intersection(b.geom, ST_Buffer(r.geom, 100000.0)) AS budynkiDo100kmOdRzek FROM popp b, majrivers r
WHERE b.f_codedesc='Building';
SELECT * FROM tableB;
SELECT f_codedesc FROM popp;

--- 5.Utwórz tabelę o nazwie airportsNew. Z tabeli airports do zaimportuj nazwy lotnisk, ich geometrię, a także atrybut elev, reprezentujący wysokość n.p.m.
---     Uwaga: geodezyjny układ współrzędnych prostokątnych płaskich (x – oś pionowa, y – oś pozioma)
CREATE TABLE airportsNew AS
SELECT name, geom, elev FROM airports;
SELECT * FROM airportsNew;

---     a) Znajdź lotnisko, które położone jest najbardziej na zachód i najbardziej na wschód.
SELECT name, ST_AsText(geom), ST_X(geom) AS max_na_zachod FROM airportsNew
ORDER BY max_na_zachod LIMIT 1;
SELECT name, ST_AsText(geom), ST_X(geom) AS max_na_wschod FROM airportsNew
ORDER BY max_na_wschod DESC LIMIT 1;
---     b) Do tabeli airportsNew dodaj nowy obiekt - lotnisko, które położone jest w punkcie środkowym drogi pomiędzy lotniskami znalezionymi 
---     w punkcie a. Lotnisko nazwij airportB. Wysokość n.p.m. przyjmij dowolną.
INSERT INTO airportsNew VALUES ('airportB',ST_Centroid(ST_ShortestLine(ST_GeomFromText('POINT(-4480198.52221446 1492348.0273686)'),
	ST_GeomFromText('POINT(4615124.97898512 2620432.35721463)'))), 0.0);
SELECT * FROM airportsNew WHERE name='airportB' OR name='ANNETTE ISLAND' OR name='ATKA';

--- 6. Wyznacz pole powierzchni obszaru, który oddalony jest mniej niż 1000 jednostek od najkrótszej linii łączącej jezioro o nazwie ‘Iliamna Lake’ 
---     i lotnisko o nazwie „AMBLER”.
SELECT ST_Area(ST_Buffer(ST_ShortestLine(j.geom, l.geom), 1000)) AS pole_powierzchni_bufor1000_odleglosc
FROM airports l, lakes j
WHERE l.name='AMBLER' AND j.names='Iliamna Lake';

--- 7. Napisz zapytanie, które zwróci sumaryczne pole powierzchni poligonów reprezentujących poszczególne typy drzew znajdujących się na obszarze tundry i bagien.
SELECT (SUM(t.area_km2)+SUM(b.areakm2)) suma, d.vegdesc gatunek FROM  trees d, tundra t , swamp b
WHERE t.area_km2 IN (SELECT t.area_km2 FROM tundra t, trees d 
					 WHERE ST_CONTAINS(d.geom,t.geom) = 'true') AND b.areakm2  IN (SELECT b.areakm2 FROM swamp b, trees d 
																				   WHERE ST_CONTAINS(d.geom,b.geom) = 'true') GROUP BY d.vegdesc;

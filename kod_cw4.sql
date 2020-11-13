CREATE EXTENSION postgis;

-- 1. Utwórz tabelę obiekty. W tabeli umieść nazwy i geometrie obiektów przedstawionych poniżej. Układ odniesienia
-- ustal jako niezdefiniowany.
CREATE TABLE obiekty(
	nazwa VARCHAR(50) NOT NULL PRIMARY KEY,
	geom GEOMETRY
);
--     obiekt1
INSERT INTO obiekty VALUES ('obiekt1', ST_GeomFromText('GEOMETRYCOLLECTION(LINESTRING(0 1, 1 1), CIRCULARSTRING(1 1, 2 0, 3 1),
													   CIRCULARSTRING(3 1, 4 2, 5 1), LINESTRING(5 1, 6 1))'));
--     obiekt2
INSERT INTO obiekty VALUES ('obiekt2', ST_GeomFromText('GEOMETRYCOLLECTION(LINESTRING(10 2, 10 6, 14 6), CIRCULARSTRING(14 6, 16 4, 14 2),
													   CIRCULARSTRING(14 2, 12 0, 10 2), CIRCULARSTRING(11 2, 13 2, 11 2))'));
--     obiekt3
INSERT INTO obiekty VALUES ('obiekt3', ST_MakePolygon('LINESTRING(7 15, 12 13, 10 17, 7 15)'));
--     obiekt4
INSERT INTO obiekty VALUES ('obiekt4', ST_GeomFromText('LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)'));
--     obiekt5
INSERT INTO obiekty VALUES ('obiekt5', ST_GeomFromText('GEOMETRYCOLLECTION(POINT(30 30 59), POINT(38 32 234))'));
--     obiekt6
INSERT INTO obiekty VALUES ('obiekt6', ST_GeomFromText('GEOMETRYCOLLECTION(LINESTRING(1 1, 3 2), POINT(4 2))'));
SELECT ST_Buffer(geom,0.01) FROM obiekty;

-- 1. Wyznacz pole powierzchni bufora o wielkości 5 jednostek, który został utworzony wokół najkrótszej linii łączącej
--     obiekt 3 i 4.
SELECT ST_Area(ST_Buffer(ST_ShortestLine(ob3.geom, ob4.geom),5))
FROM obiekty ob3, obiekty ob4
WHERE ob3.nazwa='obiekt3' AND ob4.nazwa='obiekt4';

-- 2. Zamień obiekt4 na poligon. Jaki warunek musi być spełniony, aby można było wykonać to zadanie? Zapewnij te
--      warunki.
SELECT ST_MakePolygon(ST_AddPoint(geom, ST_StartPoint(geom)))
FROM obiekty WHERE nazwa='obiekt4';

-- 3. W tabeli obiekty, jako obiekt7 zapisz obiekt złożony z obiektu 3 i obiektu 4.
INSERT INTO obiekty SELECT 'obiekt7', ST_Collect(ob3.geom, ob4.geom)
FROM obiekty ob3, obiekty ob4
WHERE ob3.nazwa='obiekt3' AND ob4.nazwa='obiekt4';
SELECT ST_Buffer(geom,0.01) FROM obiekty WHERE nazwa='obiekt7';

-- Wyznacz pole powierzchni wszystkich buforów o wielkości 5 jednostek, które zostały utworzone wokół obiektów
--     nie zawierających łuków.
SELECT SUM(ST_Area(ST_Buffer(geom, 5)))
FROM obiekty
WHERE ST_Hasarc(geom)=false;
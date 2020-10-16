-- 1. Utwórz nową bazę danych nazywając ją sNumerIndeksu (na przykład s222195).
CREATE DATABASE s298430;

-- 2. Dodaj schemat o nazwie firma.
CREATE SCHEMA Firma;

-- 3. Stwórz rolę o nazwie ksiegowosc i nadaj jej uprawnienia tylko do odczytu.


-- 4. Dodaj cztery tabele:
-- 	    pracownicy (id_pracownika, imie, nazwisko, adres, telefon)
--      godziny(id_godziny, data, liczba_godzin , id_pracownika)
--      pensja_stanowisko(id_pensji, stanowisko, kwota)
--      premia(id_premii, rodzaj, kwota)
--      wynagrodzenie(id_wynagrodzenia, data, id_pracownika, id_godziny, id_pensji, id_premii)
--    wykonując następujące działania:
--      a) Ustal typy danych tak, aby przetwarzanie i składowanie danych było najbardziej optymalne. Zastanów się, które pola muszą przyjmować wartość NOT NULL,
--      b) Ustaw klucz główny dla każdej tabeli – użyj polecenia ALTER TABLE,
--      c) Zastanów się jakie relacje zachodzą pomiędzy tabelami, a następnie dodaj klucze obce tam, gdzie występują,
--      d) Załóż indeks tam, gdzie uznasz, iż jest on potrzebny. Indeksowanie metodą B-drzewa. Wybierz odpowiednią kolumnę!,
--      e) Ustaw opisy/komentarze każdej tabeli – użyj polecenia COMMENT,
--      f) Ustal więzy integralności tak, aby po usunięciu, czy modyfikacji nie wyzwalano żadnej akcji.
CREATE TABLE Firma.Pracownicy(
	id_pracownika INT,
	imie VARCHAR(50) NOT NULL,
	nazwisko VARCHAR(50) NOT NULL,
	adres VARCHAR(100),
	telefon VARCHAR(12)
);
ALTER TABLE Firma.Pracownicy ADD PRIMARY KEY (id_pracownika);
COMMENT ON TABLE Firma.Pracownicy IS 'Tabela z danymi pracowników.';

CREATE TABLE Firma.Godziny(
	id_godziny INT,
	data DATE,
	liczba_godzin INT NOT NULL,
	id_pracownika INT NOT NULL REFERENCES Firma.Pracownicy(id_pracownika)
);
ALTER TABLE Firma.Godziny ADD PRIMARY KEY (id_godziny);
CREATE INDEX Liczba_godzin_index ON Firma.Godziny USING btree (liczba_godzin);
COMMENT ON TABLE Firma.Godziny IS 'Tabela z ilością godzin przepracowanych przez pracownika w miesiącu.';

CREATE TABLE Firma.Pensja_stanowisko(
	id_pensji INT,
	stanowisko VARCHAR(50) NOT NULL,
	kwota FLOAT NOT NULL
);
ALTER TABLE Firma.Pensja_stanowisko ADD PRIMARY KEY (id_pensji);
CREATE INDEX Kwota_pensji_index ON Firma.Pensja_stanowisko USING btree (kwota);
COMMENT ON TABLE Firma.Pensja_stanowisko IS 'Tabela z pensją dla stanowisk pracy.';

CREATE TABLE Firma.Premia(
	id_premii INT,
	rodzaj VARCHAR(50) NOT NULL,
	kwota FLOAT NOT NULL
);
ALTER TABLE Firma.Premia ADD PRIMARY KEY (id_premii);
CREATE INDEX Kwota_premii_index ON Firma.Premia USING btree (kwota);
COMMENT ON TABLE Firma.Premia IS 'Tabela z rodzajami i wartościami premii.';

CREATE TABLE Firma.Wynagrodzenie(
	id_wynagrodzenia INT,
	data DATE,
	id_pracownika INT NOT NULL REFERENCES Firma.Pracownicy(id_pracownika),
	id_godziny INT REFERENCES Firma.Godziny(id_godziny),
	id_pensji INT NOT NULL REFERENCES Firma.Pensja_stanowisko(id_pensji),
	id_premii INT REFERENCES Firma.Premia(id_premii)
);
ALTER TABLE Firma.Wynagrodzenie ADD PRIMARY KEY (id_wynagrodzenia);
COMMENT ON TABLE Firma.Wynagrodzenie IS 'Tabela z wynagrodzeniem dla pracownikow w miesiącu.';

-- 5. Wypełnij tabele treścią wg poniższego wzoru (każda tabela ma zawierać min. 10 rekordów).
INSERT INTO Firma.Pracownicy VALUES (1, 'Jakub', 'Staszel', 'ul. Łokietka 12, 30-150 Kraków', '+48731480317');
INSERT INTO Firma.Pracownicy VALUES (2, 'Julianna', 'Zryk', 'al. Mickiewicza 33/12, 34-156 Wroclaw', '+48321567876');
INSERT INTO Firma.Pracownicy VALUES (3, 'Konrad', 'Pawlowski', 'ul. Marii 1, 32-145 Male Ciche', '+48987098235');
INSERT INTO Firma.Pracownicy VALUES (4, 'Marta', 'Lasak', 'ul. Kubusia Puchatka 98, 54-657 Poronin', '+48456009132');
INSERT INTO Firma.Pracownicy VALUES (5, 'Aleksandra', 'Fafrowicz', 'ul. Armii 32, 87-980 Ostrow Wielkopolski', '+48890675436');
INSERT INTO Firma.Pracownicy VALUES (6, 'Franciszek', 'Zeglen', 'ul. Kapuściana 12, 12-567 Krakow', '+48876456231');
INSERT INTO Firma.Pracownicy VALUES (7, 'Aleksander', 'Oliwek', 'al. Janosika 34, 98-098 Gdansk', '+48987630154');
INSERT INTO Firma.Pracownicy VALUES (8, 'Wioletta', 'Orlik', 'ul. Powstania 12, 09-0432 Olsztyn', '+48946187632');
INSERT INTO Firma.Pracownicy VALUES (9, 'Karol', 'Wierzbanowski', 'ul. Bezdomnych 54, 75-987 Stalowa Wola', '+48759265020');
INSERT INTO Firma.Pracownicy VALUES (10, 'Krzysztof', 'Zryk', 'ul. Węzłowa 45, 30-123 Krakow', '+48895329704');
SELECT * FROM Firma.Pracownicy;

INSERT INTO Firma.Godziny VALUES (1, '2020-03-31', 80, 10);
INSERT INTO Firma.Godziny VALUES (2, '2020-03-31', 600, 9);
INSERT INTO Firma.Godziny VALUES (3, '2020-03-31', 123, 1);
INSERT INTO Firma.Godziny VALUES (4, '2020-03-31', 98, 7);
INSERT INTO Firma.Godziny VALUES (5, '2020-03-31', 162, 2);
INSERT INTO Firma.Godziny VALUES (6, '2020-03-31', 192, 5);
INSERT INTO Firma.Godziny VALUES (7, '2020-03-31', 240, 3);
INSERT INTO Firma.Godziny VALUES (8, '2020-03-31', 123, 8);
INSERT INTO Firma.Godziny VALUES (9, '2020-03-31', 243, 2);
INSERT INTO Firma.Godziny VALUES (10, '2020-03-31', 106, 4);
SELECT * FROM Firma.Godziny;

INSERT INTO Firma.Pensja_stanowisko VALUES (1, 'doradca finansowy', 2200.00);
INSERT INTO Firma.Pensja_stanowisko VALUES (2, 'ksiegowy', 2745.50);
INSERT INTO Firma.Pensja_stanowisko VALUES (3, 'zarzad', 4276.20);
INSERT INTO Firma.Pensja_stanowisko VALUES (4, 'kierownik', 3223.25);
INSERT INTO Firma.Pensja_stanowisko VALUES (5, 'inzynier', 2656.89);
INSERT INTO Firma.Pensja_stanowisko VALUES (6, 'projektant', 2308.00);
INSERT INTO Firma.Pensja_stanowisko VALUES (7, 'hr', 2143.40);
INSERT INTO Firma.Pensja_stanowisko VALUES (8, 'dzial rozwoju', 1145.10);
INSERT INTO Firma.Pensja_stanowisko VALUES (9, 'przedstawiciel handlowy', 3012.70);
INSERT INTO Firma.Pensja_stanowisko VALUES (10, 'rekruter', 2434.00);
SELECT * FROM Firma.Pensja_stanowisko;

INSERT INTO Firma.Premia VALUES (1, 'swiateczna', 120.30);
INSERT INTO Firma.Premia VALUES (2, 'na dziecko', 10.80);
INSERT INTO Firma.Premia VALUES (3, 'zapomoga', 200.00);
INSERT INTO Firma.Premia VALUES (4, 'innowacje', 542.36);
INSERT INTO Firma.Premia VALUES (5, 'teamplayer', 400.25);
INSERT INTO Firma.Premia VALUES (6, 'pomoc', 158.00);
INSERT INTO Firma.Premia VALUES (7, 'zmiana dzialu', 98.35);
INSERT INTO Firma.Premia VALUES (8, 'staz', 685.00);
INSERT INTO Firma.Premia VALUES (9, 'wyjazd', 109.98);
INSERT INTO Firma.Premia VALUES (10, 'zywnosc', 104.99);
INSERT INTO Firma.Premia VALUES (11, 'brak', 0.0);
SELECT * FROM Firma.Premia;

INSERT INTO Firma.Wynagrodzenie VALUES (1, '2020-03-31', 1, 2, 3, 4);
INSERT INTO Firma.Wynagrodzenie VALUES (2, '2020-03-31', 2, 3, 8, 1);
INSERT INTO Firma.Wynagrodzenie VALUES (3, '2020-03-31', 3, 3, 5, 5);
INSERT INTO Firma.Wynagrodzenie VALUES (4, '2020-03-31', 4, 6, 3, 8);
INSERT INTO Firma.Wynagrodzenie VALUES (5, '2020-03-31', 5, 2, 2, 5);
INSERT INTO Firma.Wynagrodzenie VALUES (6, '2020-03-31', 6, 5, 2, 11);
INSERT INTO Firma.Wynagrodzenie VALUES (7, '2020-03-31', 7, 3, 5, 6);
INSERT INTO Firma.Wynagrodzenie VALUES (8, '2020-03-31', 8, 8, 9, 9);
INSERT INTO Firma.Wynagrodzenie VALUES (9, '2020-03-31', 9, 2, 3, 11);
INSERT INTO Firma.Wynagrodzenie VALUES (10, '2020-03-31', 10, 4, 9, 6);
SELECT * FROM Firma.Wynagrodzenie;

--      a) W tabeli godziny, dodaj pola przechowujące informacje o miesiącu oraz
--      numerze tygodnia danego roku (rok ma 53 tygodnie). Oba mają być typu DATE.
ALTER TABLE Firma.Godziny ADD COLUMN miesiac INT;
UPDATE Firma.Godziny SET miesiac=DATE_PART('month',data);
ALTER TABLE Firma.Godziny ADD COLUMN tydzien INT;
UPDATE Firma.Godziny SET tydzien=DATE_PART('week',data);

--      b) W tabeli wynagrodzenie zamień pole data na typ tekstowy.
ALTER TABLE Firma.Wynagrodzenie ALTER COLUMN data TYPE VARCHAR(10);

--      c) Pole ‘rodzaj’ w tabeli premia ma przyjmować także wartość ‘brak’. Wtedy kwota premii równa się zero.
-- zrobione przy wypełnianiu tabel

-- 6. Wykonaj następujące zapytania:
--      a) Wyświetl tylko id pracownika oraz jego nazwisko
SELECT imie, nazwisko FROM Firma.Pracownicy;

--      b) Wyświetl id pracowników, których płaca jest większa niż 1000
SELECT FPrac.id_pracownika FROM Firma.Pracownicy FPrac, Firma.Pensja_stanowisko FPens, Firma.Wynagrodzenie FWyn 
	WHERE FPrac.id_pracownika = FWyn.id_pracownika AND FPens.id_pensji = FWyn.id_pensji AND FPens.kwota>1000;

--      c) Wyświetl id pracowników nie posiadających premii, których płaca jest większa niż 2000
SELECT FPrac.id_pracownika FROM Firma.Pracownicy FPrac, Firma.Pensja_stanowisko FPens, Firma.Wynagrodzenie FWyn, Firma.Premia FPrem 
	WHERE FPrac.id_pracownika = FWyn.id_pracownika AND FPens.id_pensji = FWyn.id_pensji AND FPrem.id_premii = FWyn.id_premii AND FPens.kwota>2000 AND Fprem.rodzaj='brak';

--      d) Wyświetl pracowników, których pierwsza litera imienia zaczyna się na literę ‘J’
SELECT * FROM Firma.Pracownicy
	WHERE imie LIKE 'J%';

--      e) Wyświetl pracowników, których nazwisko zawiera literę ‘n’ oraz imię kończy się na literę ‘a’
SELECT * FROM Firma.Pracownicy
	WHERE (imie LIKE '%a') AND (nazwisko LIKE '%n%');

--      f) Wyświetl imię i nazwisko pracowników oraz liczbę ich nadgodzin, przyjmując, iż standardowy czas pracy to 160 h miesięcznie.
SELECT FPrac.imie, FPrac.nazwisko, (FG.liczba_godzin::integer - 160) FROM Firma.Pracownicy FPrac, Firma.Godziny FG
	WHERE FPrac.id_pracownika = FG.id_pracownika AND FG.liczba_godzin::integer > 160;

--      g) Wyświetl imię i nazwisko pracowników, których pensja zawiera się w przedziale 1500 – 3000
SELECT FPrac.imie, FPrac.nazwisko FROM Firma.Pracownicy FPrac, Firma.Pensja_stanowisko FPens, Firma.Wynagrodzenie FWyg
	WHERE FPrac.id_pracownika = FWyg.id_pracownika AND FPens.id_pensji = FWyg.id_pensji AND FPens.kwota > 1500 AND FPens.kwota < 3000;

--      h) Wyświetl imię i nazwisko pracowników, którzy pracowali w nadgodzinach i nie otrzymali premii
SELECT FPrac.imie, FPrac.nazwisko FROM Firma.Pracownicy FPrac, Firma.Godziny FG, Firma.Wynagrodzenie FWyg, Firma.Premia FPrem
	WHERE FPrac.id_pracownika = FG.id_pracownika AND FG.liczba_godzin::integer > 160 AND FWyg.id_pracownika = FPrac.id_pracownika 
		AND FWyg.id_premii = FPrem.id_premii AND FPrem.rodzaj = 'brak';

-- 7. Wykonaj poniższe polecenia:
--      a) Uszereguj pracowników według pensji
SELECT FPrac.imie, FPrac.nazwisko, FPen.kwota 
	FROM Firma.Pensja_stanowisko FPen, Firma.Wynagrodzenie FWyn, Firma.Pracownicy FPrac 
	WHERE FPen.id_pensji = FWyn.id_pensji AND FWyn.id_pracownika = FPrac.id_pracownika
	ORDER BY FPen.kwota;
--      b) Uszereguj pracowników według pensji i premii malejąco
SELECT FPrac.imie, FPrac.nazwisko, FPen.kwota, FPrem.kwota
	FROM Firma.Pensja_stanowisko FPen, Firma.Wynagrodzenie FWyn, Firma.Pracownicy FPrac, Firma.Premia FPrem
	WHERE FPen.id_pensji = FWyn.id_pensji AND FWyn.id_pracownika = FPrac.id_pracownika AND FWyn.id_premii = FPrem.id_premii
	ORDER BY FPen.kwota DESC, FPrem.kwota DESC;

--      c) Zlicz i pogrupuj pracowników według pola ‘stanowisko’
SELECT COUNT(*),  FPen.stanowisko 
	FROM Firma.Pensja_stanowisko FPen
	GROUP BY FPen.stanowisko;

--      d) Policz średnią, minimalną i maksymalną płacę dla stanowiska ‘kierownik’ (jeżeli takiego nie masz, to przyjmij dowolne inne)
SELECT MIN(FPen.kwota) AS MinPensja,MAX(FPen.kwota) AS MaxPensja, AVG(FPen.kwota) AS SredniaPensja 
	FROM Firma.Pensja_stanowisko FPen
	WHERE FPen.stanowisko = 'kierownik';

--      e) Policz sumę wszystkich wynagrodzeń
SELECT SUM(FPrem.kwota)+SUM(FPens.kwota) AS Wynagrodzenie 
	FROM Firma.Wynagrodzenie FWyn
	LEFT JOIN Firma.Pensja_stanowisko FPens ON FWyn.id_pensji = FPens.id_pensji
	LEFT JOIN Firma.Premia FPrem ON FWyn.id_premii = FPrem.id_premii;

--      f) Policz sumę wynagrodzeń w ramach danego stanowiska
SELECT SUM(COALESCE(FPrem.kwota,0))+ SUM(COALESCE(FPens.kwota,0)) as Wynagrodzenie, FPens.stanowisko 
	FROM Firma.Wynagrodzenie FWyn 
	LEFT JOIN Firma.Pensja_stanowisko FPens ON FWyn.id_pensji = FPens.id_pensji
	LEFT JOIN Firma.Premia FPrem ON FWyn.id_premii = FPrem.id_premii 
	GROUP BY FPens.stanowisko;

--      g) Wyznacz liczbę premii przyznanych dla pracowników danego stanowiska
SELECT COUNT(FWyn.id_premii) AS IloscPremii, FPens.stanowisko 
	FROM Firma.Wynagrodzenie FWyn
	JOIN Firma.Pensja_stanowisko FPens ON FWyn.id_pensji = FPens.id_pensji
	GROUP BY FPens.stanowisko;

--      h) Usuń wszystkich pracowników mających pensję mniejszą niż 1200 zł
DELETE FROM Firma.Pracownicy 
	WHERE id_pracownika IN (SELECT id_pracownika FROM Firma.Wynagrodzenie 
		WHERE id_pensji IN (SELECT id_pensji FROM Firma.Pensja_stanowisko WHERE kwota < 1200));
		
-- 8. Wykonaj poniższe polecenia:
--      a) Zmodyfikuj numer telefonu w tabeli pracownicy, dodając do niego kierunkowy dla Polski w nawiasie (+48) b) Zmodyfikuj kolumnę telefon w 
--          tabeli pracownicy tak, aby numer oddzielony był myślnikami wg wzoru: ‘555-222-333’
ALTER TABLE Firma.Pracownicy ALTER COLUMN telefon TYPE VARCHAR(16);
UPDATE Firma.Pracownicy FPrac
SET telefon = '('||SUBSTRING(FPrac.telefon, 1, 3)||')'||SUBSTRING(FPrac.telefon, 4, 3)||'-'||SUBSTRING(FPrac.telefon, 7, 3)||'-'||SUBSTRING(FPrac.telefon, 10, 3);
SELECT * FROM Firma.Pracownicy;
--      c) Wyświetl dane pracownika, którego nazwisko jest najdłuższe, używając wielkich liter
SELECT id_pracownika, UPPER(FPrac.imie), UPPER(FPrac.nazwisko), UPPER(FPrac.adres), FPrac.telefon
FROM Firma.Pracownicy FPrac 
ORDER BY LENGTH(FPrac.nazwisko) DESC 
LIMIT 1;

-- 9. Raport końcowy
--      Utwórz zapytanie zwracające w wyniku treść wg poniższego szablonu:
--      Pracownik Jan Nowak, w dniu 7.08.2017 otrzymał pensję całkowitą na kwotę 7540 zł, gdzie wynagrodzenie zasadnicze 
--      wynosiło: 5000 zł, premia: 2000 zł, nadgodziny: 540 zł.
ALTER TABLE Firma.Pensja_stanowisko ALTER COLUMN kwota TYPE FLOAT USING kwota::double precision;
SELECT CONCAT('Pracownik ',FPrac.imie,' ',FPrac.nazwisko,', w dniu ',
FWyn.data,' otrzymał pensję całkowitą na kwotę ',COALESCE(FPrem.kwota,0)+COALESCE(FPens.kwota,0),
' zł, gdzie wynagrodzenie zasadnicze wynosiło: ',FPens.kwota,
'zł, premia: ',FPrem.kwota,' zł, nadgodziny: ', COALESCE((FG.liczba_godzin::integer-160)*10.5,0),' zł.') 
AS Informacja
FROM Firma.wynagrodzenie FWyn 
JOIN Firma.Pensja_stanowisko FPens ON FWyn.id_pensji = FPens.id_pensji
JOIN Firma.Premia FPrem ON FWyn.id_premii = FPrem.id_premii 
JOIN Firma.Pracownicy FPrac ON FWyn.id_pracownika = FPrac.id_pracownika
JOIN Firma.Godziny FG ON FWyn.id_pracownika = FPrac.id_pracownika;
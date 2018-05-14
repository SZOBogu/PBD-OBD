--2. Wszystkie dane nt. wszystkich studentów
SELECT * FROM student s;

--3. Nazwa i id wszystkich budynkow
select nazwa, id_budynek from budynek;

--4. Dane wykladowcow o nazwisku na p
SELECT * FROM wykladowca w WHERE nazwisko LIKE 'P%';

--5. ects i nazwa przedmiotow z 10+ znakami bez whitspacow
SELECT ects, nazwa FROM Przedmiot WHERE nazwa LIKE '__________%';
--wersja alternatywna
SELECT ects, nazwa FROM przedmiot WHERE LENGTH(REPLACE(nazwa, ' ', ''))>10;

--6. Miasto, kod pocztowy, ulice nr.lokalu Kolumny miasto, kod poczt, ul, nr lokalu, potem zlacz w kolumne dane adresowe
SELECT miasto as MIASTO, kodpocztowy as "KOD POCZTOWY", ulica as ULICA,nrlokalny as "NR LOKALU" FROM Adres;
SELECT miasto||' '||kodpocztowy||' '||ulica||' '||nrlokalny "DANE ADRESOWE" FROM Adres;

--7. nazwiska, imiona i id studentow alfabetycznie
SELECT nazwisko, imie, id_student FROM student ORDER BY nazwisko;

--8. oceny od najmlodszej, dd-mm-yyyy
SELECT ocena, EXTRACT(DAY FROM data)||'/'||EXTRACT(MONTH FROM data)||'/'||EXTRACT(YEAR FROM data) FROM Ocena ORDER BY DATA DESC;

--10. dale sal z kofem zawierajacym F lub 01
SELECT * FROM Sala WHERE KODSALI LIKE '%F%' OR kodsali LIKE '%01%';

--11. miasto i ulica, gdzie ulica na drugiej literze ma o lub i a reszta dowlona, a miejscowosc ma 8 znakow
SELECT miasto, ulica FROM Adres WHERE (ULICA LIKE '_o%' OR ulica LIKE '_i%') AND LENGTH(Miasto) = 8;

--12. nazwisko, imie, nr albumu studentow z nie krakowa
SELECT nazwisko, imie , nralbumu, miasto FROM Student s, Adres a WHERE a.id_adres=s.ID_adres AND miasto NOT LIKE 'Krak_w'; 

--13.przedmioty konczoace sie na a
SELECT nazwa FROM Przedmiot p WHERE nazwa LIKE '%a';

--14.wszystkie tytuly naukowe bez inzyniera
SELECT nazwa FROM TYTULNAUKOWY WHERE nazwa NOT LIKE '%in¿%';

--15.liczba studentow z kazdej grupy
SELECT g.nazwa, COUNT(id_student) FROM Grupa g, Student s WHERE s.ID_GRUPA = g.ID_GRUPA GROUP BY g.nazwa;

--16.ile jest rodzajow przedmiotow
SELECT COUNT(id_przedmiot) FROM Przedmiot p;
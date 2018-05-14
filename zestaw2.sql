--2. nazwisko imie, tytul wykladowcy. imie pierwsza duza, nazwiska capsem kolumna dane osobowe
SELECT UPPER(nazwisko)||' '||INITCAP(imie)||' '||nazwa as "Dane Osobowe" FROM wykladowca w, tytulnaukowy t WHERE t.id_tytul = w.id_tytul;
--3. ile dni uplynelo od wpisania ostatnej oceny (sysdate), kto i z jakiego przedmiotu
SELECT ROUND(SYSDATE - o.data, 2) as DNI, o.ocena, w.imie, w.nazwisko, p.nazwa FROM ocena o, przedmiot p, zajecia z, wykladowca w 
WHERE z.id_wykladowca = w.id_wykladowca AND o.id_zajecia = z.id_zajecia AND z.id_przedmiot = p.id_przedmiot
ORDER BY DNI ASC FETCH FIRST ROW ONLY;
--4. dane wykladowcow, ktorzy wpisali oceny w ciagu ostatnich 5 miesiacu w kolumnie dane
SELECT nazwisko||' '||imie as dane, ocena FROM wykladowca w, ocena o, zajecia z WHERE 
o.id_zajecia = z.id_zajecia AND w.id_wykladowca = z.id_wykladowca AND SYSDATE<ADD_MONTHS(o.data, 55);
--5. min, sr, max
SELECT MIN(o.ocena) as "MINIMALNA OCENA", AVG(o.ocena) as "SREDNIA OCENA", MAX(o.ocena) FROM ocena o;
--6. roznica miedzy najstarsza a najmlodsza oceno. kol ROZNICA
SELECT (MAX(o.ocena) - MIN (o.ocena)) AS roznica FROM ocena o;
--7. liczba prowadzacych z kazdego przedmiotu, od najmniejszej
SELECT COUNT(z.id_wykladowca) as liczba, p.nazwa FROM zajecia z, wykladowca w, przedmiot p WHERE
z.id_wykladowca = w.id_wykladowca AND z.id_przedmiot = p.id_przedmiot GROUP BY p.nazwa ORDER BY COUNT(z.id_wykladowca) DESC;
--8.student z najwieksza lczba ocen
SELECT COUNT(o.id_ocena), s.nazwisko, s.imie FROM student s, ocena o WHERE o.id_student = s.id_student GROUP BY s.nazwisko, s.imie 
ORDER BY COUNT(o.id_ocena) DESC FETCH FIRST ROW ONLY;
--9.liczbe studentow w kazdej grupie z informatyki
SELECT COUNT(s.id_student), g.nazwa FROM student s, grupa g WHERE s.id_grupa = g.id_grupa GROUP BY g.nazwa;
--10. daty najblizszych poniedzialkow, przypadajacych po ostatniej ocenie w bazie
SELECT o.data + 7*(SELECT COUNT(o.data) FROM ocena o, zajecia z WHERE o.id_zajecia = z.id_zajecia AND z.dzientyg LIKE 'PON') as "najblizsze poniedzialki"
FROM ocena o, zajecia z WHERE o.id_zajecia=z.id_zajecia AND z.dzientyg LIKE 'PON' GROUP BY o.data ORDER BY o.data DESC;
--11.nazwiska i imiona prowadzacych. jezeli dany wykladowca ma w nazwsiku sk zamiast jego nazwiska wypisz brak przedmiotu
SELECT p.nazwa, w.imie,w.nazwisko, CASE WHEN w.nazwisko LIKE '%sk%' THEN 'BRAK PRZEDMIOTU' ELSE w.nazwisko END FROM przedmiot p, zajecia z , wykladowca w WHERE
z.id_przedmiot = p.id_przedmiot AND z.id_wykladowca = w.id_wykladowca;
--12. zastap liczby 357 liczbami 000 w indexie
SELECT REPLACE(CAST(nralbumu AS varchar(10)), '913', '000') FROM student;
--13. nazwy przedmiotow z najwieksza liczba ects
SELECT p.nazwa, p.ects FROM przedmiot p WHERE p.ects = (SELECT MAX(p.ECTS) FROM przedmiot p);
--14. dzien tygodnia, w ktorym sa zajecia z algorytmow lub statystyki
SELECT z.dzientyg, p.nazwa FROM zajecia z, przedmiot p WHERE z.id_przedmiot = p.id_przedmiot AND (p.nazwa LIKE'%lgorytmy%' OR p.nazwa LIKE '%tatystyka%');
--15. nazwa grupy ktora ma zajecia w budynku wfmii i wil
SELECT g.nazwa, b.nazwa FROM grupa g, zajecia z, sala s, budynek b WHERE
s.id_budynek = b.id_budynek AND z.id_sala = s.id_sala AND z.id_grupa = g.id_grupa AND (b.nazwa LIKE'%Fizyki%' OR b.nazwa LIKE '%L_dowej%');
--16. ilosc ocen z kazdego przedmiotu
SELECT p.nazwa, COUNT(id_ocena) FROM zajecia z, przedmiot p, ocena o WHERE 
o.id_zajecia = z.id_zajecia AND z.id_przedmiot = p.id_przedmiot GROUP BY p.nazwa;
--17. nazwy przedmiotow prowadzonych przez mgr inz
SELECT p.nazwa, w.nazwisko, t.nazwa FROM przedmiot p, wykladowca w, zajecia z, tytulnaukowy t WHERE 
z.id_przedmiot = p.id_przedmiot AND z.id_wykladowca = w.id_wykladowca AND w.id_tytul = t.id_tytul AND t.nazwa LIKE '%mgr in%';
--18. miasto, z ktorego pochodzi najmniejsza liczba studentow z matmy
SELECT a.miasto, COUNT(id_student) FROM adres a, student s, grupa g, kierunek k 
WHERE s.id_adres = a.id_adres AND s.id_grupa = g.id_grupa AND g.id_kierunek = k.id_kierunek AND k.nazwa LIKE '%atematyka%' 
GROUP BY a.miasto ORDER BY a.miasto DESC;
--19. nazwiska prowadzacych, ktorzy sa profesorami i ucza analizy danych
SELECT w.nazwisko FROM wykladowca w, tytulnaukowy t, przedmiot p, zajecia z WHERE
z.id_przedmiot = p.id_przedmiot AND z.id_wykladowca = w.id_wykladowca AND w.id_tytul = t.id_tytul 
AND p.nazwa LIKE '%naliza%' AND t.nazwa LIKE '%rof%';
--20. ile jest zajec o charakterze cwiczen
SELECT COUNT(id_zajecia) FROM zajecia z, charakter ch WHERE z.ID_CHARAKTER = ch.ID_CHARAKTER AND ch.NAZWA LIKE '%wiczenia%';
--21. wyswietl imi i nazw prowadzacego zajecia na silce i kiedy
SELECT w.imie, w.nazwisko, z.dzientyg, s.kodsali FROM zajecia z, sala s, wykladowca w WHERE
z.id_sala = s.id_sala AND z.id_wykladowca = w.id_wykladowca  AND s.kodsali LIKE '%Si_ownia%';
--22. srednia ilosc ocen z sw dla kazdej grupy
SELECT AVG(COUNT(o.id_ocena)) FROM ocena o , zajecia z, przedmiot p, student s, grupa g WHERE
g.id_grupa = s.id_grupa AND o.id_student = s.id_student AND o.id_zajecia = z.id_zajecia AND z.id_przedmiot = p.id_przedmiot
AND p.nazwa LIKE '_ystemy _budowane' GROUP BY g.id_grupa;
--23. ile zajec w kazdym budynku
SELECT COUNT(z.id_zajecia), b.nazwa FROM zajecia z, sala s, budynek b WHERE
z.id_zajecia = s.id_sala AND s.id_budynek = b.id_budynek GROUP BY b.nazwa;
--24. dane prowadzacych, ktorzy nie maja zajec w salach na k w poniedzilki i czwartki
SELECT w.nazwisko, w.imie, z.dzientyg, s.kodsali FROM wykladowca w, zajecia z, sala s WHERE
z.id_wykladowca = w.id_wykladowca AND z.id_sala = s.id_sala AND s.kodsali NOT LIKE 'K%'
AND z.dzientyg NOT LIKE 'CZW' AND z.dzientyg NOT LIKE 'PON';
--25. wyswietl jakie zajecia odbywaja sie w budynkach wis
SELECT p.nazwa, b.nazwa FROM przedmiot p, zajecia z, sala s, budynek b WHERE
z.id_przedmiot = p.id_przedmiot AND z.id_sala = s.id_sala AND s.id_budynek = b.id_budynek 
AND b.nazwa LIKE 'Wydzia³ Fizyki Matematyki i Iinformatyki' GROUP BY p.nazwa, b.nazwa;
--26. kto prowadzi seminaria: *******dane**************t naukowy**********8kierunek*******
SELECT LPAD(w.nazwisko,15,'*')||' '||RPAD(w.imie,15,'*') AS dane, RPAD(t.nazwa,25,'*') as "tytul naukowy",RPAD(k.nazwa,25,'*') as kierunek
FROM wykladowca w, charakter ch, zajecia z, kierunek k, grupa g, tytulnaukowy t WHERE
z.id_charakter = ch.id_charakter AND z.id_wykladowca = w.id_wykladowca AND w.id_tytul = t.id_tytul AND
z.id_grupa = g.id_grupa AND g.id_kierunek = k.id_kierunek AND ch.nazwa LIKE 'Seminarium';
--27. w jakich salach i budynkach sa wyklady
SELECT s.kodsali, b.nazwa FROM budynek b, sala s, zajecia z, charakter ch WHERE
b.id_budynek = s.id_budynek AND s.id_sala = z.id_sala AND z.id_charakter = ch.id_charakter AND ch.nazwa LIKE 'Wyk_ady' GROUP BY s.kodsali, b.nazwa;
--28. naz i imiona studentow ktorzy majo najwiecej ocen z lektoratu
SELECT s.nazwisko, s.imie
--29. w ktory dzien tygodnia jest najwiecej zajec

--30.im i naz, nr albumu najlepszego studenta z bdi oraz jego adres w 1 kolumnie
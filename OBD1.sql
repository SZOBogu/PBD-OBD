set serveroutput on;
/*
1. Napisz program, który poprosi o podanie imienia i nazwiska (zarówno imiê jak
i nazwisko powinno byæ przechowywane w osobnych zmiennych), a nastêpnie
wyœwietli na ekranie napis: Witaj imiê nazwisko!
Witaj imie nazwisko!*/
DECLARE
    imie varchar2(30) := '&imie';
    nazwisko varchar2(50) := '&nazwisko';
BEGIN
    DBMS_OUTPUT.PUT_LINE('Witaj '||imie||' '||nazwisko);
END;
/*
2. Napisz program, który dla podanego przez u¿ytkownika n obliczy wartoœæ wyra¿enia
n! = 1 * 2 * 3 * ... * n (silniê).*/
DECLARE
    maxcap number(3) := &a;
    silnia number(38) := 1;
BEGIN
    IF maxcap < 0 THEN
        DBMS_OUTPUT.PUT_LINE('Nieprawidlowa wartosc');
    ELSIF maxcap = 0 OR maxcap = 1 THEN
        DBMS_OUTPUT.PUT_LINE(1);
    ELSE
        FOR i IN 1..maxcap LOOP
            silnia:=silnia*i;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(silnia);
    END IF;
END;
/*
3. Napisz program, który dla podanej wartoœci r (promieñ) obliczy pole i obwód
zadanego ko³a. Wartoœæ PI zadeklaruj jako wartoœæ sta³¹ równ¹ 3,1416.*/
DECLARE
    promien number:=&promien;
    pole number(30,15);
    obwod number(30,15);
    PI constant number:=3.1416;
BEGIN
    pole:=promien*promien*PI;
    obwod:=2*PI*promien;
    dbms_output.put_line('Promien: '||promien||' Obwod: '||obwod||' Pole: '||pole);
END;
/*
4. Napisz program, który przy podanych dwóch zmiennych podniesie wartoœæ pierwszej
zmiennej do potêgi równej wartoœci drugiej zmiennej (bez u¿ycia funkcji power).
Program powinien dzia³aæ dla liczb z zakresu od 1 do 10. W przeciwnym przypadku
powinien wypisaæ komunikat informuj¹cy, która liczba (podstawa lub wyk³adnik)
przekracza zakres.
Proszê podaæ wartoœæ dla podstawy:
Proszê podaæ wartoœæ dla wyk³adnika:
wyk³adnik wynosi
podstawa wynosi
Wynik: 
*/
DECLARE
    podstawa number:=&podstawa;
    wykladnik number:=&wykladnik;
    wynik number:=1;
BEGIN
    IF podstawa < 0 OR podstawa > 10 THEN
        dbms_output.put_line('Podstawa winna byæ z zakresu 1-10');
    ELSIF wykladnik < 0 OR wykladnik > 10 THEN
        dbms_output.put_line('Wykladnik winien byæ z zakresu 1-10');
    ELSE
        FOR i IN 1..wykladnik LOOP
            wynik:=wynik*podstawa;
        END LOOP;
            dbms_output.put_line(wynik); 
    END IF;
END;
    
/*
5. Napisz program, który dla podanej przez u¿ytkownika liczby wyrazów szeregu obliczy
liczbê e (liczba Eulera) ze wzoru:
Podaj liczbe wyrazow szeregu:
Liczba e wynosi:
*/
DECLARE
    wyrazow number:=&wyrazow;
    eee number:=1;
    silnia number:=1;
BEGIN
    FOR i IN 1..wyrazow LOOP
        eee:=eee + 1/silnia;
        silnia:=silnia*i;
    END LOOP;
        dbms_output.put_line(eee);
END;
/*
6. Napisz program, który bêdzie pracowa³ do momentu, gdy nastanie najbli¿sza sekunda
aktualnego czasu systemowego bêd¹ca wielokrotnoœci¹ liczby 15 (czyli 0, 15, 30, 45).
Przed zakoñczeniem program powinien wypisaæ tekst: Jest godzina HH:MM:SS.
Koncze dzia³anie.
*/
    DECLARE
        czas TIMESTAMP;
    BEGIN
        LOOP
            SELECT CURRENT_TIMESTAMP INTO czas FROM dual;
        EXIT WHEN remainder(round(extract(second from czas)),15)=0;
        END LOOP;
        dbms_output.put_line('Czas: '||to_char(czas,'HH:MI:SS')||' Koncze');
    END;
/*
7. Napisz anonimowy blok PL/SQL, który wypisze ile dni minê³o od twojej daty
urodzenia. Data ma byæ podawana z klawiatury. WprowadŸ obs³ugê b³êdów gdy
zostanie podana nieprawid³owa data – kontroluj iloœæ dni w miesi¹cu oraz miesiêcy w
roku.*/

--overcomplicated, there certainly is a better way, one of the many things i'll fix in the future. Yeah.
DECLARE
    rok number:=&rok;
    miesiac number:=&miesiac;
    dzien number:=&dzien;
    obecna date;
    temp varchar2(50);
BEGIN
    IF miesiac > 12 THEN                                --ain't nothing like a gigantic if statements
        dbms_output.put_line('Rok ma 12 miesiecy');
    ELSIF miesiac < 0 THEN
        dbms_output.put_line('Nie ma czegoœ takiego jak ujemny miesiac');
    ELSIF miesiac = 2 AND dzien > 29 THEN
        dbms_output.put_line('Luty nie ma tylu dni');
    ELSIF miesiac = 4 OR miesiac = 6 OR miesiac = 9 OR miesiac = 11 AND dzien > 30 THEN 
        dbms_output.put_line('Ten miesiac nie ma tylu dni'); 
    ELSIF dzien > 31 THEN 
        dbms_output.put_line('Zaden miesiac nie ma tylu dni');
    ELSIF rok = 0 THEN 
        dbms_output.put_line('Nie bylo roku zerowego');
    ELSIF miesiac = 0 THEN 
        dbms_output.put_line('Nie ma miesiaca zerowego');
    ELSIF dzien = 0 THEN 
        dbms_output.put_line('Nie nie ma dnia zerowego');
    ELSIF rok < 0 THEN 
        dbms_output.put_line('Niby byly lata przed chrystusem ale ja sie nimi nie zajmuje');
    END IF;
    temp:=dzien||'-'||miesiac||'-'||rok;
    to_date(temp,'DD-MM-YYYY');
    obecna:=CURRENT_DATE();
    dbms_output.put_line(obecna-temp);
END;
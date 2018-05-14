set serveroutput on;
/*
1. Napisaæ program, który dla podanego nazwiska i imienia prowadz¹cego zwróci liczbê
przedmiotów przez niego prowadzonych. Wykorzystaj zapytanie w PL/SQL.
*/
DECLARE
    imie varchar2(50):='Dymitr';
    nazwisko varchar2(50):='Dudel';
    liczba number:=0;
BEGIN
    SELECT count(p.id_przedmiot) INTO liczba FROM przedmiot p, zajecia z, wykladowca w WHERE z.id_przedmiot=p.id_przedmiot AND w.id_wykladowca=z.id_wykladowca
AND w.imie = imie AND w.nazwisko = nazwisko;
    dbms_output.put_line(to_char(liczba));
END;
/*
2. Napisaæ program PL/SQL, który dla podanego nr albumu studenta oraz budynku i sali
zwróci liczbê przedmiotów, na które uczêszcza dany student. Wykorzystaj zapytanie
w PL/SQL
*/
DECLARE
    nralbum number:=6896;
    sala varchar2(50):='Silownia';
    budynek varchar2(50):='Centrum Sportu i Rekreacji PK';
    liczba number;
BEGIN
    SELECT count(p.id_przedmiot) INTO liczba FROM przedmiot p, zajecia z, sala s, budynek b, grupa g, student s WHERE
    z.id_przedmiot = p.id_przedmiot AND z.id_sala=s.id_sala AND s.id_budynek = b.id_budynek AND z.id_grupa=g.id_grupa AND s.id_grupa = g.id_grupa
    AND s.nralbumu = nralbum AND s.kodsali = sala AND b.nazwa = budynek;
    dbms_output.put_line(liczba);
END;
/*
3. Napisz program, który wyœwietli imiona, nazwiska oraz numery albumu wszystkich
studentów, w nastêpuj¹cej postaci (wynik powinien byæ posortowany wed³ug nazwisk
w kolejnoœci odwrotnej, wszystkie nazwiska du¿ymi literami, odstêpy w postaci
wykropkowanej). Wykorzystaj polecenie FETCH.
STUDENCI:
Jan.......NOWAK.......51120435861
Jakub.....LIPKA.......65060712098
Piotr.....KOWALSKI....32121345067
Bogdan....BRACKI......44032478690
*/
DECLARE
    CURSOR kursor IS 
        SELECT RPAD(INITCAP(s.imie),25,'*')||LPAD(UPPER(s.nazwisko),25,'*')||LPAD(s.nralbumu,25,'*') as STUDENCI FROM student s ORDER BY s.nazwisko DESC;
        --SELECT s.imie,s.nazwisko,s.nralbumu FROM student;
    wynik varchar(80);
    licz number;
BEGIN
    OPEN kursor;
    LOOP
        FETCH kursor INTO wynik;
        dbms_output.put_line(wynik);
        EXIT WHEN kursor%NOTFOUND;
    END LOOP;
    CLOSE kursor;
END;
/*
4. Napisz program w trzech wariantach, który pobierze dane wszystkich studentów i
umieœci je w zmiennej rekordowej. W pierwszym wariancie zadeklaruj zmienn¹ jako
rekord typu TYPE … IS RECORD, w drugim wykorzystaj atrybut %ROWTYPE,
w trzecim wykorzystaj pêtlê FOR z kursorem. Wyœwietl wszystkie dane z rekordu.
*/
DECLARE
    CURSOR kursor IS
        SELECT id_student,imie,nazwisko,id_adres,s.NRALBUMU,s.ID_GRUPA FROM student s;
    TYPE studenciak IS RECORD(
        ID_STUDENT	NUMBER(4,0),
        IMIE	VARCHAR2(20 BYTE),
        NAZWISKO	VARCHAR2(30 BYTE),
        ID_ADRES	NUMBER(4,0),
        NRALBUMU	NUMBER(10,0),
        ID_GRUPA	NUMBER(4,0)
    );
    stud studenciak;
BEGIN
    OPEN kursor;
    LOOP
        FETCH kursor INTO stud;
        dbms_output.put_line(stud.nazwisko||' '||stud.imie||' '||stud.nralbumu);
        EXIT WHEN kursor%NOTFOUND;
    END LOOP;
    CLOSE kursor;
END;
--wariant z %rowtype
DECLARE
    CURSOR kursor IS
        SELECT * FROM student s;
    studenciak student%ROWTYPE;
BEGIN
    OPEN kursor;
    LOOP
        FETCH kursor INTO studenciak;
        dbms_output.put_line(studenciak.nazwisko||' '||studenciak.imie||' '||studenciak.nralbumu);
        EXIT WHEN kursor%NOTFOUND;
    END LOOP;
    CLOSE kursor;
END;

--wariant z tym trzecim
DECLARE
    CURSOR kursor IS
        SELECT * FROM student s;
    --studenciak student%ROWTYPE;
BEGIN
    FOR i IN kursor LOOP
        --FETCH kursor INTO studenciak;
        dbms_output.put_line(i.nazwisko||' '||i.imie||' '||i.nralbumu);
        --EXIT WHEN kursor%NOTFOUND;
    END LOOP;
END;
/*
5. Napisz program zwiêkszaj¹cy ocenê studenta najgorszego z wybranego przedmiotu o
0,5. Zmiany nale¿y przerwaæ, jeœli w jakimœ momencie ocena bêdzie poza zakresem
obowi¹zuj¹cych ocen. Wprowadziæ obs³ugê b³êdów. Nazwê przedmiotu wraz z iloœci¹
zmian wypisaæ na ekranie.
*/

-- doesn't work yet
DECLARE
    zaduza exception;
    CURSOR leser IS     --should also return grade itself, and name of the subject, i'll fix it someday. Maybe.
        SELECT s.nazwisko, s.imie , MIN(o.ocena) FROM ocena o, student s WHERE o.id_student = s.id_student 
        GROUP BY o.ocena, s.nazwisko, s.imie ORDER BY o.ocena ASC;
    TYPE studento IS RECORD(
        naz varchar2(20),
        im varchar2(20) ,
        najnizsza number(5,4)
    );
    zmian number:=0;
BEGIN
    OPEN leser;
    FETCH leser INTO studento;
        IF studento.najnizsza >= 5 THEN
            raise zaduza;
        ELSE
            i.ocena:= i.ocena + 0.5;
            zmian:=zmian + 1;
            dbms_output.put_line(studento.najnizsza||' '||zmian); 
        END IF;
    END LOOP;
    CLOSE leser;
    dbms_output.put_line(zmian);
    exception
    when zaduza then                            --??????????????????????????????????????????
        dbms_output.put_line("za duza ocena");
END;
/* Some otherday maybe
6. Napisaæ program, który zmodyfikuje typ zajêæ dla podanej grupy studenckiej w
zale¿noœci od jego aktualnej zawartoœci. Wykorzystaj zamianê wg wzorca:
L - W
W - Æ
P – L
Æ - P
*/

/* Some otherday maybe
7. Napisz program, który wyœwietli dane o wszystkich studentach, którzy nie maj¹
zaliczenia przynajmniej z jednego przedmiotu (nazwa przedmiotu, nazwisko i imiê
prowadz¹cego). Korzystaj¹c z atrybutu %ROWCOUNT ogranicz iloœæ wyników do
trzech pozycji.
*/

/* Some otherday maybe
8. Podnieœ ocenê wszystkim studentom z przedmiotu (nazwa przedmiotu – parametrem
kursora) o jeden stopieñ, a pozosta³e oceny o 0,5 jeœli to mo¿liwe. Bezpoœrednio po
zmianie oceny wyœwietl na ekranie nazwisko i imiê studenta oraz now¹ ocenê. W
pierwszym wariancie programu skorzystaj z klauzuli WHERE CURRENT OF (celem
wskazania rekordu do zmiany ceny). W wariancie drugim skorzystaj z klauzuli
RETURNING INTO (celem przekazania zmienionej oceny do zmiennej).*/
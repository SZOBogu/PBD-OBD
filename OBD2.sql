set serveroutput on;
/*
1. Napisa� program, kt�ry dla podanego nazwiska i imienia prowadz�cego zwr�ci liczb�
przedmiot�w przez niego prowadzonych. Wykorzystaj zapytanie w PL/SQL.
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
2. Napisa� program PL/SQL, kt�ry dla podanego nr albumu studenta oraz budynku i sali
zwr�ci liczb� przedmiot�w, na kt�re ucz�szcza dany student. Wykorzystaj zapytanie
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
3. Napisz program, kt�ry wy�wietli imiona, nazwiska oraz numery albumu wszystkich
student�w, w nast�puj�cej postaci (wynik powinien by� posortowany wed�ug nazwisk
w kolejno�ci odwrotnej, wszystkie nazwiska du�ymi literami, odst�py w postaci
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
4. Napisz program w trzech wariantach, kt�ry pobierze dane wszystkich student�w i
umie�ci je w zmiennej rekordowej. W pierwszym wariancie zadeklaruj zmienn� jako
rekord typu TYPE � IS RECORD, w drugim wykorzystaj atrybut %ROWTYPE,
w trzecim wykorzystaj p�tl� FOR z kursorem. Wy�wietl wszystkie dane z rekordu.
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
5. Napisz program zwi�kszaj�cy ocen� studenta najgorszego z wybranego przedmiotu o
0,5. Zmiany nale�y przerwa�, je�li w jakim� momencie ocena b�dzie poza zakresem
obowi�zuj�cych ocen. Wprowadzi� obs�ug� b��d�w. Nazw� przedmiotu wraz z ilo�ci�
zmian wypisa� na ekranie.
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
6. Napisa� program, kt�ry zmodyfikuje typ zaj�� dla podanej grupy studenckiej w
zale�no�ci od jego aktualnej zawarto�ci. Wykorzystaj zamian� wg wzorca:
L - W
W - �
P � L
� - P
*/

/* Some otherday maybe
7. Napisz program, kt�ry wy�wietli dane o wszystkich studentach, kt�rzy nie maj�
zaliczenia przynajmniej z jednego przedmiotu (nazwa przedmiotu, nazwisko i imi�
prowadz�cego). Korzystaj�c z atrybutu %ROWCOUNT ogranicz ilo�� wynik�w do
trzech pozycji.
*/

/* Some otherday maybe
8. Podnie� ocen� wszystkim studentom z przedmiotu (nazwa przedmiotu � parametrem
kursora) o jeden stopie�, a pozosta�e oceny o 0,5 je�li to mo�liwe. Bezpo�rednio po
zmianie oceny wy�wietl na ekranie nazwisko i imi� studenta oraz now� ocen�. W
pierwszym wariancie programu skorzystaj z klauzuli WHERE CURRENT OF (celem
wskazania rekordu do zmiany ceny). W wariancie drugim skorzystaj z klauzuli
RETURNING INTO (celem przekazania zmienionej oceny do zmiennej).*/
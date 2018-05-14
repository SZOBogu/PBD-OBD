set SERVEROUTPUT ON
/*
5. Napisz procedurê sparametryzowan¹, w której zostanie wybrany
najlepszy student, a jego nazwisko, imiê i numer albumu oraz œrednia
zostan¹ przekazane do œrodowiska wywo³uj¹cego, gdzie nale¿y wypisaæ
je na ekranie. WprowadŸ obs³ugê b³êdów, jeœli wiêcej ni¿ jeden student
uzyska najwy¿sz¹ œredni¹.
*/
CREATE OR REPLACE PROCEDURE procedura5 (sred OUT number, imi OUT varchar2, na OUT varchar2, nral OUT varchar2) IS
    BEGIN
        SELECT AVG(o.ocena), s.nazwisko, s.imie, s.nralbumu INTO sred, imi, na, nral FROM student s, ocena o 
        WHERE s.id_student = o.id_student GROUP BY o.ocena, s.nazwisko, s.imie, s.nralbumu HAVING o.ocena = 
            (SELECT max(srednia) FROM 
                (SELECT avg(o.ocena) as srednia FROM student s, ocena o 
                WHERE s.id_student = o.id_student GROUP BY s.id_student));
    EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        raise_application_error(-20001, 'Wiecej niz jeden najlepszy student');
    END procedura5;
    
DECLARE
    srednia number(5,4);
    naz varchar2(30);
    im varchar2(30);
    nra number(6);
BEGIN
    procedura5(srednia, im, naz, nra);
    dbms_output.put_line(srednia||' '||im||' '||naz||' '||nra);
END;
/*
6. Utworzyæ funkcjê, która dla podanego nazwiska i imienia prowadz¹cego
(parametr), zwróci liczbê przedmiotów przez niego prowadzonych.
*/
CREATE OR REPLACE FUNCTION funkcja6(imie IN varchar2, nazwisko IN varchar2) RETURN number IS
        ile number(4);
        BEGIN
            SELECT count(distinct p.id_przedmiot) INTO ile FROM przedmiot p, zajecia z, wykladowca w 
            WHERE p.id_przedmiot = z.id_przedmiot AND z.id_wykladowca = w.id_wykladowca 
            AND w.imie = imie AND w.nazwisko = nazwisko;
            RETURN ile;
        END funkcja6;
        
    DECLARE
        im varchar2(20) := 'Iwon';
        naz varchar2(30) := 'Juka';
        il number(4);
    BEGIN
        il := funkcja6(im, naz);
        dbms_output.put_line(il);
    END;
/*
DECLARE
    SELECT count(p.id_przedmiot) FROM przedmiot p, zajecia z, wykladowca w WHERE
    z.id_przedmiot = p.id_przedmiot AND z.id_wykladowca = w.id_wykladowca AND w.imie = 'Walenty' AND w.nazwisko = 'Drul'
BEGIN

END;*/
/*
7. Napisaæ funkcje PL/SQL, która dla podanego nr albumu studenta oraz
budynku i sali (parametry) zwróci liczbê przedmiotów, na które uczêszcza
dany student.
*/

CREATE OR REPLACE FUNCTION funkcja7(nralbumu IN varchar2, budynek IN varchar2, sala IN varchar2) RETURN number IS
    ile number(4);
    BEGIN
        SELECT count(distinct p.id_przedmiot) INTO ile FROM przedmiot p, zajecia z, student st, grupa g, sala s, budynek b WHERE
        z.id_przedmiot = p.id_przedmiot AND z.id_sala = s.id_sala AND s.id_budynek = b.id_budynek AND z.id_grupa = g.id_grupa
        AND st.id_grupa = g.id_grupa AND s.kodsali = sala AND b.nazwa = budynek AND st.NRALBUMU = nralbumu;
        return ile;
END funkcja7;

    DECLARE
        nralbum number(6) := 91027;
        sala varchar2(20) := 'Hala';
        budynek varchar2(30) := 'Centrum Sportu i Rekreacji PK';
        il number(4);
    BEGIN
        il := funkcja7(nralbum, sala, budynek);
        dbms_output.put_line(il);
    END;
/*
8. Napisaæ procedurê, która zmodyfikuje typ zajêæ dla podanej, jako
parametr grupy studenckiej w zale¿noœci od jego aktualnej zawartoœci.
Wykorzystaj klauzurê: L – W oraz W - Æ
*/

--chyba dziala
CREATE OR REPLACE PROCEDURE procedura8(idgrupa IN number) IS
    CURSOR kursor IS
        SELECT ch.nazwa FROM charakter ch, zajecia z, grupa g 
        WHERE ch.id_charakter = z.id_charakter AND z.id_grupa = g.id_grupa
        AND g.id_grupa = idgrupa FOR UPDATE OF ch.nazwa;
    BEGIN
        FOR licz in kursor LOOP
            dbms_output.put_line('bifor: '||licz.nazwa);
            IF licz.nazwa = 'Laboratoria' THEN
                UPDATE charakter SET nazwa = 'Wyk³ady' WHERE CURRENT OF kursor;
                dbms_output.put_line('after: '||licz.nazwa);
            END IF;
            IF licz.nazwa = 'Æwiczenia' THEN
                 UPDATE charakter SET nazwa = 'Laboratoria' WHERE CURRENT OF kursor; 
                 dbms_output.put_line('after: '||licz.nazwa);
            END IF;
            IF licz.nazwa = 'Wyk³ady' THEN
                 UPDATE charakter SET nazwa = 'Æwiczenia' WHERE CURRENT OF kursor;  
                 dbms_output.put_line('after: '||licz.nazwa);
            END IF;
        END LOOP;
    END procedura8;
    
DECLARE
    grupa number:= 4;
BEGIN
    procedura8(grupa);
END;
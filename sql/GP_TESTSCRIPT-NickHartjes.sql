/*================================================================*/
/* Database name:  GameParadise			                          */
/* DBMS name:      Microsoft SQL Server 2017                      */
/* Created on:     20/12/2017							          */
/* Made by:        Martijn de Geus, Nick Hartjes en Joey Stoffels */
/*================================================================*/

USE GAMEPARADISE
GO

-- Opdracht 4: TESTEN (GROEP)
-- Test alle constraints die in 2 en 3 gecreëerd zijn. Toon door middel van INSERT-statements voor het toevoegen van voorbeeldpopulatie (goede populatie en tegenvoorbeelden) aan dat de geïmplementeerde constraints uit opdrachten 2 en 3 correct geïmplementeerd zijn.
-- 1. Het geslacht van een klant moet ‘M’ (man) of ‘V’ (vrouw) zijn.
-- Case 1a: Onsuccesvol: Geslact G
INSERT INTO KLANT VALUES ('test1a_wilfried.kanen1984@gmail.com', 'Sony', 'PS4', 'Wilfried', 'Kanen', 'K. Bouterlaan', '31', '6092AH', 'Arnhem', '02-01-1984', 'G', 'kapsalon123');
GO
-- Case 1b: Onsuccesvol: Geslact 9
INSERT INTO KLANT VALUES ('test1b_wilfried.kanen1984@gmail.com', 'Sony', 'PS4', 'Wilfried', 'Kanen', 'K. Bouterlaan', '31', '6092AH', 'Arnhem', '02-01-1984', '9', 'kapsalon123');
GO
-- Case 1c: Succesvol: Geslacht M
INSERT INTO KLANT VALUES ('test1c_wilfried.kanen1984@gmail.com', 'Sony', 'PS4', 'Wilfried', 'Kanen', 'K. Bouterlaan', '31', '6092AH', 'Arnhem', '02-01-1984', 'M', 'kapsalon123');
GO
-- Cleanup
DELETE FROM KLANT WHERE EMAILADRES = 'test1c_wilfried.kanen1984@gmail.com';
GO



-- 2. De einddatum van een verhuur moet later zijn dan de begindatum van een verhuur.
-- Case 2a: Onsuccesvol: Einddatum vroeger dan startdatum
INSERT INTO HUUROVEREENKOMST VALUES ('2017-12-23', 'a.neque@nonummyacfeugiat.net', '2017-12-10', 'VERHUURD', NULL, NULL);
GO
-- Case 2b: Onsuccesvol: Einddatum is gelijk als de startdatum
INSERT INTO HUUROVEREENKOMST VALUES ('2017-12-23', 'a.neque@nonummyacfeugiat.net', '2017-12-23', 'VERHUURD', NULL, NULL);
GO
-- Case 2c: Succesvol: Startdatum is na einddatum
INSERT INTO HUUROVEREENKOMST VALUES ('2017-12-23', 'a.neque@nonummyacfeugiat.net', '2017-12-24', 'VERHUURD', NULL, NULL);
GO
-- Cleanup
DELETE FROM HUUROVEREENKOMST WHERE STARTDATUM = '2017-12-23' AND EMAILADRES = 'a.neque@nonummyacfeugiat.net';
GO


-- 3. De betaaldatum (startdatum) van een schade moet eerder of gelijk zijn t.o.v. de gereeddatum van een schade.
-- Case 3a: Onsuccesvol: Gereeddatum vroeger dan startdatum
INSERT INTO REPARATIE VALUES (26, '10000004', '2017-12-24', 'stews', '2017-12-23',  100.00 , 'GEREED');
GO
-- Case 3b: Onsuccesvol: Gereeddatum vroeger dan startdatum
INSERT INTO REPARATIE VALUES (26, '10000004', '2017-12-24', 'stews', '2017-12-24',  100.00 , 'GEREED');
GO
-- Cleanup
DELETE FROM REPARATIE WHERE SCHADENUMMER = 26;
GO


-- 4. Het adres van een klant moet uniek zijn.
-- Case 4a: Onsuccesvol: Adres is al toegevoegd in test case 1
INSERT INTO KLANT VALUES ('test4a_wilfried.kanen1984@gmail.com', 'Sony', 'PS4', 'Wilfried', 'Kanen', 'K. Bouterlaan', '31', '6092AH', 'Arnhem', '02-01-1984', 'M', 'kapsalon123');
GO
-- Case 4a: Succesvol: Adres is uniek
INSERT INTO KLANT VALUES ('test4b_wilfried.kanen1984@gmail.com', 'Sony', 'PS4', 'Wilfried', 'Kanen', 'K. Bouterlaan', '32', '6092AH', 'Arnhem', '02-01-1984', 'M', 'kapsalon123');
GO
-- Cleanup
DELETE FROM KLANT WHERE EMAILADRES = 'test4b_wilfried.kanen1984@gmail.com';
GO

-- 5. Het wachtwoord moet minimaal een lente hebben van 6 , en heeft minimaal 1 nummer nodig
-- Case 5a: Onsuccesvol: Wachtwoord is te kort
INSERT INTO KLANT VALUES ('test5a_wilfried.kanen1984@gmail.com', 'Sony', 'PS4', 'Wilfried', 'Kanen', 'K. Bouterlaan', '311', '6092AH', 'Arnhem', '02-01-1984', 'M', 'abcd');
GO
-- Case 5b: Onsuccesvol: Wachtwoord is lang genoeg, maar heeft geen nummer
INSERT INTO KLANT VALUES ('test5b_wilfried.kanen1984@gmail.com', 'Sony', 'PS4', 'Wilfried', 'Kanen', 'K. Bouterlaan', '322', '6092AH', 'Arnhem', '02-01-1984', 'M', 'abcdefghij');
GO
-- Case 5c: Onsuccesvol: Wachtwoord heeft een nummer maar is te kort
INSERT INTO KLANT VALUES ('test5c_wilfried.kanen1984@gmail.com', 'Sony', 'PS4', 'Wilfried', 'Kanen', 'K. Bouterlaan', '323', '6092AH', 'Arnhem', '02-01-1984', 'M', '1abcd');
GO
-- Case 5d: Succesvol: Wachtwoord heeft een nummer maar is te kort
INSERT INTO KLANT VALUES ('test5d_wilfried.kanen1984@gmail.com', 'Sony', 'PS4', 'Wilfried', 'Kanen', 'K. Bouterlaan', '324', '6092AH', 'Arnhem', '02-01-1984', 'M', '1abcdefghij');
GO
-- Cleanup
DELETE FROM KLANT WHERE EMAILADRES = 'test5d_wilfried.kanen1984@gmail.com';
GO

-- 6. Het telefoonnummer moet uit 11 characters bestaan
-- Case 6a: Onsuccesvol: Telefoonnummer is te kort
INSERT INTO TELEFOONNUMMER VALUES ('0612345678', 'M')
GO
-- Case 6b: Onsuccesvol: Telefoonnummer is te lang
INSERT INTO TELEFOONNUMMER VALUES ('06-123456789', 'M')
GO
-- Case 6c: Onsuccesvol: Telefoonnummer goed
INSERT INTO TELEFOONNUMMER VALUES ('06-12345678', 'M')
GO
-- Cleanup
DELETE FROM TELEFOONNUMMER WHERE  TELNUMMER = '06-12345678';
GO
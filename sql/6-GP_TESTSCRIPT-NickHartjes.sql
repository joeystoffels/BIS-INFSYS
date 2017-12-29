/*================================================================*/
/* Database name:  GameParadise			                          */
/* DBMS name:      Microsoft SQL Server 2017                      */
/* Created on:     20/12/2017							          */
/* Made by:        Martijn de Geus, Nick Hartjes en Joey Stoffels */
/*================================================================*/

USE GAMEPARADISE
GO

/*================================================================*/
/* Testen voor check constrains  		                          */
/*================================================================*/

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
-- Case 3b: Succesvol: Gereeddatum gelijk dan startdatum
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
-- Case 6c: Succesvol: Telefoonnummer goed
INSERT INTO TELEFOONNUMMER VALUES ('06-12345678', 'M')
GO
-- Cleanup
DELETE FROM TELEFOONNUMMER WHERE TELNUMMER = '06-12345678';
GO

-- 7. Het emailadres moet een correcte syntax hebben
-- Case 7a: Onsuccesvol: Emailadres zonder top level domain
INSERT INTO KLANT VALUES ('test7_wilfried.kanen1984@gmail', 'Sony', 'PS4', 'Wilfried', 'Kanen', 'K. Bouterlaan', '324', '6092AH', 'Arnhem', '02-01-1984', 'M', '1abcdefghij');
GO
-- Case 7b: Onsuccesvol: Emailadres zonder top "@"
INSERT INTO KLANT VALUES ('test7_wilfried.kanen1984gmail.com', 'Sony', 'PS4', 'Wilfried', 'Kanen', 'K. Bouterlaan', '324', '6092AH', 'Arnhem', '02-01-1984', 'M', '1abcdefghij');
GO
-- Case 7c: Succesvol: Emailadres met juiste syntax
INSERT INTO KLANT VALUES ('test7_wilfried.kanen1984@gmail.com', 'Sony', 'PS4', 'Wilfried', 'Kanen', 'K. Bouterlaan', '324', '6092AH', 'Arnhem', '02-01-1984', 'M', '1abcdefghij');
GO
-- Cleanup
DELETE FROM KLANT WHERE EMAILADRES = 'test7_wilfried.kanen1984@gmail.com';
GO

-- 8. De postcode bestaat uit 4 cijfers en 2 letters.
-- Case 8a: Onsuccesvol: 6 cijfers
INSERT INTO KLANT VALUES ('test8_wilfried.kanen1984@gmail.com', 'Sony', 'PS4', 'Wilfried', 'Kanen', 'K. Bouterlaan', '324', '609222', 'Arnhem', '02-01-1984', 'M', '1abcdefghij');
GO
-- Case 8b: Onsuccesvol: 6 letters
INSERT INTO KLANT VALUES ('test8_wilfried.kanen1984@gmail.com', 'Sony', 'PS4', 'Wilfried', 'Kanen', 'K. Bouterlaan', '324', 'AHAHAH', 'Arnhem', '02-01-1984', 'M', '1abcdefghij');
GO
-- Case 8c: Succesvol: 4 cijfers en 2 letters
INSERT INTO KLANT VALUES ('test8_wilfried.kanen1984@gmail.com', 'Sony', 'PS4', 'Wilfried', 'Kanen', 'K. Bouterlaan', '324', '6092AH', 'Arnhem', '02-01-1984', 'M', '1abcdefghij');
GO
-- Cleanup
DELETE FROM KLANT WHERE EMAILADRES = 'test8_wilfried.kanen1984@gmail.com';
GO


/*================================================================*/
/* Testen voor foreign key constraints  		                  */
/*================================================================*/

-- Test: 
-- ALTER TABLE ARTIKEL ADD CONSTRAINT FK_ARTIKEL_IS_SPEL foreign key (TITEL, UITGEVER, JAAR_UITGAVE) REFERENCES SPEL (TITEL, UITGEVER, JAAR_UITGAVE) ON UPDATE CASCADE ON DELETE NO ACTION;
-- ALTER TABLE CATEGORIEPERSPEL ADD CONSTRAINT FK_SPEL FOREIGN KEY (TITEL, UITGEVER, JAAR_UITGAVE) REFERENCES SPEL (TITEL, UITGEVER, JAAR_UITGAVE) ON UPDATE CASCADE ON DELETE NO ACTION;
-- ALTER TABLE SPELTYPEPERSPEL ADD CONSTRAINT FK_SPELTYPE_PER_SPEL FOREIGN KEY (TITEL, UITGEVER, JAAR_UITGAVE) REFERENCES SPEL (TITEL, UITGEVER, JAAR_UITGAVE) ON UPDATE CASCADE ON DELETE NO ACTION;
-- Begin Transaction
BEGIN TRAN
GO
SELECT * FROM SPEL WHERE TITEL = 'Battlefield III - Iran';
SELECT * FROM CATEGORIEPERSPEL WHERE TITEL = 'Battlefield III - Iran';
SELECT * FROM SPELTYPEPERSPEL WHERE TITEL = 'Battlefield III - Iran';
SELECT * FROM ARTIKEL WHERE BARCODE = '10000062';
GO
-- Update
UPDATE SPEL SET TITEL = 'Battlefield III - Iraq' WHERE TITEL = 'Battlefield III - Iran';
SELECT * FROM SPEL WHERE TITEL = 'Battlefield III - Iraq';
SELECT * FROM CATEGORIEPERSPEL WHERE TITEL = 'Battlefield III - Iraq';
SELECT * FROM SPELTYPEPERSPEL WHERE TITEL = 'Battlefield III - Iraq';
SELECT * FROM ARTIKEL WHERE BARCODE = '10000062';
GO
-- Delete
DELETE FROM  SPEL WHERE TITEL = 'Battlefield III - Iraq';
GO
-- Rollback Transaction
ROLLBACK TRAN
GO

-- ALTER TABLE CONSOLE ADD CONSTRAINT FK_MERK_CONSOLE FOREIGN KEY (MERK_NAAM) REFERENCES CONSOLE_MERK (MERK_NAAM) ON UPDATE CASCADE ON DELETE NO ACTION;
-- Begin Transaction
BEGIN TRAN
GO
SELECT * FROM CONSOLE_MERK WHERE MERK_NAAM = 'Microsoft';
SELECT * FROM CONSOLE WHERE MERK_NAAM = 'Microsoft';
GO
-- Update
UPDATE CONSOLE_MERK SET MERK_NAAM = 'Microschoft' WHERE MERK_NAAM = 'Microsoft';
SELECT * FROM CONSOLE_MERK WHERE MERK_NAAM = 'Microschoft';
SELECT * FROM CONSOLE WHERE MERK_NAAM = 'Microschoft';
GO
-- Delete
DELETE FROM CONSOLE_MERK WHERE MERK_NAAM = 'Microschoft';
GO
-- Rollback Transaction
ROLLBACK TRAN
GO

-- ALTER TABLE CONSOLE ADD CONSTRAINT FK_TYPE_CONSOLE FOREIGN KEY (TYPE_NAAM) REFERENCES CONSOLE_TYPE (TYPE_NAAM) ON UPDATE CASCADE ON DELETE NO ACTION;
-- Begin transaction
BEGIN TRAN
GO
SELECT * FROM CONSOLE_TYPE WHERE TYPE_NAAM = 'Xbox';
SELECT * FROM CONSOLE WHERE TYPE_NAAM = 'Xbox';
GO
-- Update
UPDATE CONSOLE_TYPE SET TYPE_NAAM = 'ZBox' WHERE TYPE_NAAM = 'Xbox';
SELECT * FROM CONSOLE_TYPE WHERE TYPE_NAAM = 'Zbox';
SELECT * FROM CONSOLE WHERE TYPE_NAAM = 'Zbox';
GO
-- Delete
DELETE FROM CONSOLE_TYPE WHERE TYPE_NAAM = 'Zbox';
GO
-- Rollback Transaction
ROLLBACK TRAN
GO

-- ALTER TABLE KLANT ADD CONSTRAINT FK_KLANT_CONSOLE FOREIGN KEY (MERK_EIGEN_CONSOLE, TYPE_EIGEN_CONSOLE) REFERENCES CONSOLE (MERK_NAAM, TYPE_NAAM) ON UPDATE CASCADE ON DELETE NO ACTION;
-- Begin transaction
BEGIN TRAN
GO
SELECT * FROM KLANT WHERE MERK_EIGEN_CONSOLE = 'Sony';
SELECT * FROM KLANT WHERE TYPE_EIGEN_CONSOLE = 'PS3';
GO
-- Update
UPDATE CONSOLE_TYPE SET TYPE_NAAM = 'PR3' WHERE TYPE_NAAM = 'PS3';
UPDATE CONSOLE_MERK SET MERK_NAAM = 'Fony' WHERE MERK_NAAM = 'Sony';
SELECT * FROM KLANT WHERE TYPE_EIGEN_CONSOLE = 'PR3';
SELECT * FROM KLANT WHERE MERK_EIGEN_CONSOLE = 'Fony';
GO
-- Delete
DELETE FROM CONSOLE_TYPE WHERE TYPE_NAAM = 'PR3';
DELETE FROM CONSOLE_MERK WHERE MERK_NAAM = 'Fony';
GO
-- Rollback Transaction
ROLLBACK TRAN
GO

-- ALTER TABLE ARTIKEL ADD CONSTRAINT FK_ARTIKEL_IS_CONSOLE FOREIGN KEY (MERK, [TYPE]) REFERENCES CONSOLE (MERK_NAAM, TYPE_NAAM) ON UPDATE CASCADE ON DELETE NO ACTION;
-- Begin Transaction
BEGIN TRAN
GO
SELECT * FROM ARTIKEL WHERE BARCODE = 10000000;
SELECT * FROM CONSOLE WHERE MERK_NAAM = 'Microsoft';
SELECT * FROM CONSOLE WHERE TYPE_NAAM = 'Xbox 360';
GO
-- Update
UPDATE CONSOLE_MERK SET MERK_NAAM = 'Microschoft' WHERE MERK_NAAM = 'Microsoft';
UPDATE CONSOLE_TYPE SET TYPE_NAAM = 'Xbox 365' WHERE TYPE_NAAM = 'Xbox 360';
SELECT * FROM ARTIKEL WHERE BARCODE = 10000000;
SELECT * FROM CONSOLE WHERE MERK_NAAM = 'Microschoft';
SELECT * FROM CONSOLE WHERE TYPE_NAAM = 'Xbox 365';
GO
-- Delete
DELETE FROM CONSOLE_MERK WHERE MERK_NAAM = 'Microschoft';
DELETE FROM CONSOLE_TYPE WHERE TYPE_NAAM = 'Xbox 365';
GO
-- Rollback Transaction
ROLLBACK TRAN
GO

-- ALTER TABLE ARTIKELENVERHUUR ADD CONSTRAINT FK_ARTIKELENVERHUUR_ARTIKEL FOREIGN KEY (BARCODE) REFERENCES ARTIKEL (BARCODE) ON UPDATE CASCADE ON DELETE NO ACTION;
-- Begin Transaction
BEGIN TRAN
GO
SELECT * FROM ARTIKELENVERHUUR WHERE BARCODE = '10000002';
SELECT * FROM ARTIKEL WHERE BARCODE = '10000002';
GO
-- Update
UPDATE ARTIKEL SET BARCODE = '99999999' WHERE BARCODE = '10000002';
SELECT * FROM ARTIKELENVERHUUR WHERE BARCODE = '99999999';
SELECT * FROM ARTIKEL WHERE BARCODE = '99999999';
GO
-- Delete
DELETE FROM ARTIKEL WHERE BARCODE = '99999999';
GO
--Rollback Transaction
ROLLBACK TRAN
GO

-- ALTER TABLE ARTIKELENVERHUUR ADD CONSTRAINT FK_ARTIKELENVERHUUR_HUUROVEREENKOMST FOREIGN KEY (EMAILADRES, STARTDATUM) REFERENCES HUUROVEREENKOMST (EMAILADRES, STARTDATUM) ON UPDATE NO ACTION ON DELETE CASCADE;
-- Begin Transaction
BEGIN TRAN
GO
SELECT * FROM ARTIKELENVERHUUR WHERE STARTDATUM = '2014-08-11 00:00:00.000' AND EMAILADRES = 'sit@Etiam.co.uk';
SELECT * FROM HUUROVEREENKOMST WHERE STARTDATUM = '2014-08-11 00:00:00.000' AND EMAILADRES = 'sit@Etiam.co.uk';
GO
-- Update
UPDATE HUUROVEREENKOMST SET EMAILADRES = 'text@example.com' WHERE STARTDATUM = '2014-08-11 00:00:00.000' AND EMAILADRES = 'sit@Etiam.co.uk';
SELECT * FROM ARTIKELENVERHUUR WHERE STARTDATUM = '2014-08-11 00:00:00.000' AND EMAILADRES = 'text@example.com';
SELECT * FROM HUUROVEREENKOMST WHERE STARTDATUM = '2014-08-11 00:00:00.000' AND EMAILADRES = 'text@example.com';
GO
-- Delete
DELETE FROM ARTIKELENVERHUUR WHERE STARTDATUM = '2014-08-11 00:00:00.000' AND EMAILADRES = 'text@example.com';
DELETE FROM HUUROVEREENKOMST WHERE STARTDATUM = '2014-08-11 00:00:00.000' AND EMAILADRES = 'text@example.com';
GO
-- Rollback Transaction
ROLLBACK TRAN
GO
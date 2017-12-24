/*================================================================*/
/* Database name:  GameParadise			                          */
/* DBMS name:      Microsoft SQL Server 2017                      */
/* Created on:     20/12/2017							          */
/* Made by:        Martijn de Geus, Nick Hartjes en Joey Stoffels */
/*================================================================*/

USE GAMEPARADISE
GO

-- Foreign keys uit origineel aangeleverd document

-- Deze is verwijderd in het alteration script, en komt later weer terug
-- ALTER TABLE Artikel ADD CONSTRAINT FK_ARTIKEL_IS_CONSOLE foreign key (MERK, TYPE) references CONSOLE (MERK, TYPE);

-- Een artikel titel moet worden aangepast in de tabel spel, en niet vanuit deze tabel.
ALTER TABLE ARTIKEL ADD CONSTRAINT FK_ARTIKEL_IS_SPEL foreign key (TITEL) REFERENCES SPEL (TITEL) ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Deze is verwijderd in het alteration script, en komt later weer terug
-- ALTER TABLE Klant ADD CONSTRAINT FK_KLANT_CONSOLE foreign key (MERK_EIGEN_CONSOLE, TYPE_EIGEN_CONSOLE) references CONSOLE (MERK, TYPE);

-- ALTER TABLE Huurovereenkomst ADD CONSTRAINT FK_HUUROVEREENKOMST_ARTIKEL foreign key (BARCODE) references ARTIKEL (BARCODE);

-- Een huurovereenkomst moet altijd aan een bestaande klant gelinked zijn, dus een cascading update en delete.
ALTER TABLE Huurovereenkomst ADD CONSTRAINT FK_HUUROVEREENKOMST_KLANT foreign key (EMAILADRES) references KLANT (EMAILADRES) ON UPDATE CASCADE ON DELETE CASCADE;

-- Een telefoonnummer moet worden aangepast in de telefoonnummer tabel, niet vanuit deze koppeltabel.
ALTER TABLE Klanttelefoonnr ADD CONSTRAINT FK_KLANTTELEFOONNUMMER_HEEFT_NUMMER foreign key (TELNUMMER) references TELEFOONNUMMER (TELNUMMER) ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Een e-mailadres moet worden aangepast in de klant tabel, niet vanuit deze koppeltabel.
ALTER TABLE Klanttelefoonnr ADD CONSTRAINT FK_KLANTTELEFOONNUMMER_HOORT_BIJ_KLANT foreign key (EMAILADRES) references KLANT (EMAILADRES) ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Een koopovereenkomst moet altijd aan een bestaande klant gelinked zijn, dus een cascading update en delete.
ALTER TABLE Koopovereenkomst ADD CONSTRAINT FK_KOOP_AAN_KLANT foreign key (EMAILADRES) references KLANT (EMAILADRES) ON UPDATE CASCADE ON DELETE CASCADE;

-- ALTER TABLE Koopovereenkomst ADD CONSTRAINT FK_KOOP_ARTIKEL foreign key (BARCODE) references ARTIKEL (BARCODE);

-- Een inkoopovereenkomst moet altijd aan een bestaande klant gelinked zijn, dus een cascading update en delete.
ALTER TABLE Inkoopovereenkomst ADD CONSTRAINT FK_INKOOP_VAN_KLANT foreign key (EMAILADRES) references KLANT (EMAILADRES) ON UPDATE CASCADE ON DELETE CASCADE;

-- ALTER TABLE Inkoopovereenkomst ADD CONSTRAINT FK_INKOOP_VAN_ARTIKEL foreign key (BARCODE) references ARTIKEL (BARCODE);


-- Vanuit de medewerkerrol tabel moet het mogelijk zijn om de rol aan te passen, als er een nieuwe rol neergezet wordt moet deze in de tabel rol aangemaakt worden. Bij verwijderen moet er niks gebeuren.
ALTER TABLE Medewerkerrol ADD CONSTRAINT FK_MEDEWERKER_IS_ROL foreign key (ROL) references ROL (ROL) ON UPDATE CASCADE ON DELETE NO ACTION;

-- Dit is een foreign key van een koppeltabel, wijzigingen vanuit de koppeltablel richting de hoofdtabel worden niet doorgevoerd of verwijderd.
ALTER TABLE Medewerkerrol ADD CONSTRAINT FK_MEDEWERKER_HEEFT_ROL foreign key (INLOGNAAM) references MEDEWERKER (INLOGNAAM) ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Vanuit de reparatie tabel wil je niet de inlognaam van een medewerker wijzigen, dit moet vanuit de tabel medewerker gebeuren.
ALTER TABLE Reparatie ADD CONSTRAINT FK_REPARATIE_DOOR_MEDEWERKER foreign key (INLOGNAAM) references MEDEWERKER (INLOGNAAM) ON UPDATE NO ACTION ON DELETE NO ACTION;

-- ALTER TABLE Reparatie ADD CONSTRAINT FK_REPARATIE_BIJ_HUUROVEREENKOMST foreign key (BARCODE, STARTDATUM) references HUUROVEREENKOMST (BARCODE, STARTDATUM);

-- Deze is verwijderd aangezien wij alles hebben omgeschreven naar koppeltabellen.
-- ALTER TABLE Spel ADD CONSTRAINT FK_SPEL_HOORT_BIJ_SPELCATEGORIE foreign key (CATEGORIE) references CATEGORIE (CATEGORIE);


-- Foreign keys uit alterations

-- Als iemand een merk of type van een console aanpast moet dat in de console tabel, en niet in de artikel tabel.
ALTER TABLE ARTIKEL ADD CONSTRAINT FK_ARTIKEL_IS_CONSOLE FOREIGN KEY (MERK, [TYPE]) REFERENCES CONSOLE (MERK_NAAM, TYPE_NAAM) ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Als iemand een merk of type van een console aanpast moet dat in de console tabel, en niet in de klant tabel.
ALTER TABLE KLANT ADD CONSTRAINT FK_KLANT_CONSOLE FOREIGN KEY (MERK_EIGEN_CONSOLE, TYPE_EIGEN_CONSOLE) REFERENCES CONSOLE (MERK_NAAM, TYPE_NAAM) ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Dit is een foreign key van een koppeltabel, wijzigingen vanuit de koppeltablel richting de hoofdtabel worden niet doorgevoerd of verwijderd.
ALTER TABLE CATEGORIEPERSPEL ADD CONSTRAINT FK_SPEL FOREIGN KEY (TITEL, UITGEVER, JAAR_UITGAVE) REFERENCES SPEL (TITEL, UITGEVER, JAAR_UITGAVE) ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Dit is een foreign key van een koppeltabel, wijzigingen vanuit de koppeltablel richting de hoofdtabel worden niet doorgevoerd of verwijderd.
ALTER TABLE CATEGORIEPERSPEL ADD CONSTRAINT FK_CATEGORIE FOREIGN KEY (CATEGORIE) REFERENCES CATEGORIE (CATEGORIE) ON UPDATE NO ACTION ON DELETE NO ACTION;


-- Dit is een foreign key van een koppeltabel, wijzigingen vanuit de koppeltablel richting de hoofdtabel worden niet doorgevoerd of verwijderd.
ALTER TABLE SPELTYPEPERSPEL ADD CONSTRAINT FK_SPELTYPE_PER_SPEL FOREIGN KEY (TITEL, UITGEVER, JAAR_UITGAVE) REFERENCES SPEL (TITEL, UITGEVER, JAAR_UITGAVE) ON UPDATE NO ACTION ON DELETE NO ACTION;
-- Dit is een foreign key van een koppeltabel, wijzigingen vanuit de koppeltablel richting de hoofdtabel worden niet doorgevoerd of verwijderd.
ALTER TABLE SPELTYPEPERSPEL ADD CONSTRAINT FK_SPELTYPE FOREIGN KEY (SPELTYPE) REFERENCES SPELTYPE (SPELTYPE) ON UPDATE NO ACTION ON DELETE NO ACTION;


-- Een spel mag alleen aangepast worden vanuit de spel tabel, en niet vanuit de artikel tabel. Dit ook zodat je alle identieke artikelen in een keer kunt aanpassen.
ALTER TABLE ARTIKEL ADD CONSTRAINT FK_ARTIKEL_SPEL FOREIGN KEY (TITEL, UITGEVER, JAAR_UITGAVE) REFERENCES SPEL (TITEL, UITGEVER, JAAR_UITGAVE) ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Een console merk mag alleen aangepast worden vanuit de console_merk tabel zodat in een keer alle merken aangepast worden.
ALTER TABLE CONSOLES ADD CONSTRAINT FK_MERK_CONSOLES FOREIGN KEY (MERK_NAAM) REFERENCES CONSOLE_MERK (MERK_NAAM) ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Een console type mag alleen aangepast worden vanuit de console_type tabel zodat in een keer alle typen aangepast worden.
ALTER TABLE CONSOLES ADD CONSTRAINT FK_TYPE_CONSOLES FOREIGN KEY (TYPE_NAAM) REFERENCES CONSOLE_TYPE (TYPE_NAAM) ON UPDATE NO ACTION ON DELETE NO ACTION;


-- Dit is een foreign key van een koppeltabel, wijzigingen vanuit de koppeltablel richting de hoofdtabel worden niet doorgevoerd of verwijderd.
ALTER TABLE ARTIKELENVERHUUR
	ADD CONSTRAINT FK_ARTIKELENVERHUUR_HUUROVEREENKOMST FOREIGN KEY (EMAILADRES, STARTDATUM) REFERENCES HUUROVEREENKOMST (EMAILADRES, STARTDATUM) ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Dit is een foreign key van een koppeltabel, wijzigingen vanuit de koppeltablel richting de hoofdtabel worden niet doorgevoerd of verwijderd.
ALTER TABLE ARTIKELENVERHUUR
	ADD CONSTRAINT FK_ARTIKELENVERHUUR_ARTIKEL FOREIGN KEY (BARCODE) REFERENCES ARTIKEL (BARCODE) ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Dit is een foreign key van een koppeltabel, wijzigingen vanuit de koppeltablel richting de hoofdtabel worden niet doorgevoerd of verwijderd.
ALTER TABLE ARTIKELENVERKOOP
	ADD CONSTRAINT FK_ARTIKELENVERKOOP_VERKOOPOVEREENKOMST FOREIGN KEY (EMAILADRES, DATUM) REFERENCES VERKOOPOVEREENKOMST (EMAILADRES, DATUM) ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Dit is een foreign key van een koppeltabel, wijzigingen vanuit de koppeltablel richting de hoofdtabel worden niet doorgevoerd of verwijderd.
ALTER TABLE ARTIKELENVERKOOP
	ADD CONSTRAINT FK_ARTIKELENVERKOOP_ARTIKEL FOREIGN KEY (BARCODE) REFERENCES ARTIKEL (BARCODE) ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Dit is een foreign key van een koppeltabel, wijzigingen vanuit de koppeltablel richting de hoofdtabel worden niet doorgevoerd of verwijderd.
ALTER TABLE ARTIKELENINKOOP
	ADD CONSTRAINT FK_ARTIKELENINKOOP_INKOOPOVEREENKOMST FOREIGN KEY (EMAILADRES, DATUM) REFERENCES INKOOPOVEREENKOMST (EMAILADRES, DATUM) ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Dit is een foreign key van een koppeltabel, wijzigingen vanuit de koppeltablel richting de hoofdtabel worden niet doorgevoerd of verwijderd.
ALTER TABLE ARTIKELENINKOOP
	ADD CONSTRAINT FK_ARTIKELENINKOOP_ARTIKEL FOREIGN KEY (BARCODE) REFERENCES ARTIKEL (BARCODE) ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Als ik de barcode aanpas in de reparatie wil ik niet het artikel updaten, maar wil ik een ander artikel selecteren, vandaar geen update of delete.
ALTER TABLE REPARATIE
	ADD CONSTRAINT FK_REPARATIE_ARTIKEL FOREIGN KEY (BARCODE) REFERENCES ARTIKEL (BARCODE) ON UPDATE NO ACTION ON DELETE NO ACTION;
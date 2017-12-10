USE GAMEPARADISE
GO


/*==============================================================*/
/* Table: SPELTYPE	                                            */
/*==============================================================*/
CREATE TABLE SPELTYPE (
	SPELTYPE			VARCHAR(30)			not null,
	CONSTRAINT PK_SPELTYPE PRIMARY KEY (SPELTYPE)
)
GO

/*==============================================================*/
/* Table: SPELTYPEPERSPEL	                                    */
/*==============================================================*/
CREATE TABLE SPELTYPEPERSPEL  (
	SPELTYPE			VARCHAR(30)			not null,
	TITEL				VARCHAR(150)		not null, /*  TITEL, UITGEVER, JAAR_UITGAVE  */
	UITGEVER			VARCHAR(150)		not null,
	JAAR_UITGAVE		INT					not null,
	CONSTRAINT PK_SPELTYPEPERSPEL PRIMARY KEY (SPELTYPE, TITEL, UITGEVER, JAAR_UITGAVE)
)
GO

/*==============================================================*/
/* Table: LEEFTIJDSCATEGORIE                                    */
/*==============================================================*/
CREATE TABLE LEEFTIJDSCATEGORIE (
	LEEFTIJDSCATEGORIE	CHAR(10)			not null,
	CONSTRAINT PK_LEEFTIJDSCATEGORIE PRIMARY KEY (LEEFTIJDSCATEGORIE)
)
GO

/*==============================================================*/
/* Table: UITGEVER			                                    */
/*==============================================================*/
CREATE TABLE UITGEVER (
	UITGEVER			VARCHAR(150)		not null,
	CONSTRAINT PK_UITGEVER PRIMARY KEY (UITGEVER)
)
GO

/*==============================================================*/
/* Table: CATEGORIEPERSPEL   	                                    */
/*==============================================================*/
CREATE TABLE CATEGORIEPERSPEL (
	CATEGORIE			CHAR(50)			not null,
	TITEL				VARCHAR(150)		not null,
	UITGEVER			VARCHAR(150)		not null,
	JAAR_UITGAVE		INT					not null,
	CONSTRAINT PK_CATEGORIEPERSPEL PRIMARY KEY (CATEGORIE, TITEL, UITGEVER, JAAR_UITGAVE)
)
GO

EXEC sp_RENAME 'SPEL.SINGLE_MULTIPLAYER', 'SPELTYPE', 'COLUMN'
GO

INSERT INTO SPELTYPE 
	SELECT DISTINCT SPELTYPE FROM SPEL;

INSERT INTO SPELTYPEPERSPEL
	SELECT DISTINCT SPELTYPE, TITEL, UITGEVER, JAAR_UITGAVE FROM SPEL;

INSERT INTO LEEFTIJDSCATEGORIE
	SELECT DISTINCT LEEFTIJDSCATEGORIE FROM SPEL;

INSERT INTO UITGEVER
	SELECT DISTINCT UITGEVER FROM SPEL;

INSERT INTO CATEGORIEPERSPEL
	SELECT DISTINCT CATEGORIE, TITEL, UITGEVER, JAAR_UITGAVE FROM SPEL;
	
ALTER TABLE ARTIKEL
	DROP CONSTRAINT FK_ARTIKEL_IS_SPEL;

ALTER TABLE SPEL
	DROP CONSTRAINT PK_SPEL;

UPDATE SPEL SET UITGEVER=0 WHERE UITGEVER IS NULL

UPDATE SPEL SET JAAR_UITGAVE=1990 WHERE JAAR_UITGAVE IS NULL

ALTER TABLE SPEL ALTER COLUMN UITGEVER VARCHAR(150) NOT NULL

ALTER TABLE SPEL ALTER COLUMN JAAR_UITGAVE INTEGER NOT NULL

ALTER TABLE SPEL
	ADD CONSTRAINT PK_SPEL PRIMARY KEY (TITEL, UITGEVER, JAAR_UITGAVE);

ALTER TABLE SPEL
	DROP CONSTRAINT FK_SPEL_HOORT_BIJ_SPELCATEGORIE;
	
ALTER TABLE SPEL
	ADD CONSTRAINT FK_UITGEVER FOREIGN KEY (UITGEVER) REFERENCES UITGEVER (UITGEVER);

ALTER TABLE SPEL
	ADD CONSTRAINT FK_LEEFTIJDSCATEGORIE FOREIGN KEY (LEEFTIJDSCATEGORIE) REFERENCES LEEFTIJDSCATEGORIE (LEEFTIJDSCATEGORIE);

ALTER TABLE CATEGORIEPERSPEL
	ADD CONSTRAINT FK_SPEL FOREIGN KEY (TITEL, UITGEVER, JAAR_UITGAVE) REFERENCES SPEL (TITEL, UITGEVER, JAAR_UITGAVE);

ALTER TABLE CATEGORIEPERSPEL
	ADD CONSTRAINT FK_CATEGORIE FOREIGN KEY (CATEGORIE) REFERENCES CATEGORIE (CATEGORIE);

ALTER TABLE SPELTYPEPERSPEL
	ADD CONSTRAINT FK_SPELTYPE_PER_SPEL FOREIGN KEY (TITEL, UITGEVER, JAAR_UITGAVE) REFERENCES SPEL (TITEL, UITGEVER, JAAR_UITGAVE);

ALTER TABLE SPELTYPEPERSPEL
	ADD CONSTRAINT FK_SPELTYPE FOREIGN KEY (SPELTYPE) REFERENCES SPELTYPE (SPELTYPE);

	

/*==============================================================*/
/* Table: CONSOLE_TYPE                                          */ 
/*==============================================================*/
CREATE TABLE CONSOLE_TYPE   (
        TYPE_NAAM                        varchar(30)     not null,
        CONSTRAINT PK_TYPE PRIMARY KEY (TYPE_NAAM)
)
GO

/*==============================================================*/
/* Table: CONSOLE_MERK                                          */ 
/*==============================================================*/
CREATE TABLE CONSOLE_MERK   (
        MERK_NAAM							varchar(30)  not null,
        CONSTRAINT PK_MERK PRIMARY KEY (MERK_NAAM)
)
GO

/*==============================================================*/
/* Table: CONSOLES                                              */ 
/*==============================================================*/
CREATE TABLE CONSOLES   (
        MERK_NAAM                       varchar(30)     not null,
        TYPE_NAAM                       varchar(30)     not null,
		KLEUR							char(20)			null, /* varchar ipv char voor bijv tweekleurige consoles? */
		JAAR_UITGAVE					int					null,
		MAAT							char(4)				null,
		OPMERKINGEN						varchar(200)		null,
        HUIDIGE_PRIJS                   decimal(6,2)		null, /* nu null bij gebrek aan gegevens */
        CONSTRAINT PK_CONSOLES PRIMARY KEY (MERK_NAAM, TYPE_NAAM)
)
GO

/*===============================================================*/
/*  INSERTING DATA INTO CONSOLES, CONSOLE_MERK & CONSOLE_TYPE	 */
/*===============================================================*/
INSERT INTO CONSOLES (MERK_NAAM, TYPE_NAAM, KLEUR, JAAR_UITGAVE, MAAT, OPMERKINGEN)
	(SELECT MERK, TYPE, KLEUR, JAAR_UITGAVE, MAAT, OPMERKINGEN FROM CONSOLE);

INSERT INTO CONSOLE_MERK
	SELECT DISTINCT MERK FROM CONSOLE;

INSERT INTO CONSOLE_TYPE
	SELECT DISTINCT TYPE FROM CONSOLE;

/*===============================================================*/
/*  Foreign Keys for CONSOLES                                     */
/*===============================================================*/
ALTER TABLE CONSOLES
    ADD CONSTRAINT FK_MERK_CONSOLES FOREIGN KEY (MERK_NAAM) REFERENCES CONSOLE_MERK (MERK_NAAM);
ALTER TABLE CONSOLES
    ADD CONSTRAINT FK_TYPE_CONSOLES FOREIGN KEY (TYPE_NAAM) REFERENCES CONSOLE_TYPE (TYPE_NAAM);
GO


/*===============================================================*/
/*  Clean-up for CONSOLES										 */
/*===============================================================*/
ALTER TABLE ARTIKEL
	DROP CONSTRAINT FK_ARTIKEL_IS_CONSOLE;

ALTER TABLE KLANT
	DROP CONSTRAINT FK_KLANT_CONSOLE;

ALTER TABLE KLANT 
	ALTER COLUMN MERK_EIGEN_CONSOLE varchar(30);

ALTER TABLE KLANT
	ALTER COLUMN TYPE_EIGEN_CONSOLE varchar(30);

DROP TABLE CONSOLE;

EXEC sp_rename 'CONSOLES', 'CONSOLE';

ALTER TABLE KLANT 
	ADD CONSTRAINT FK_KLANT_CONSOLE FOREIGN KEY (MERK_EIGEN_CONSOLE, TYPE_EIGEN_CONSOLE) REFERENCES CONSOLE (MERK_NAAM, TYPE_NAAM);

/*==============================================================*/
/* Alter Table: REPARATIE	                            */
/*==============================================================*/
/* Remove FK_REPARATIE_BIJ_HUUROVEREENKOMST                     */
/*                                                              */
/*==============================================================*/

ALTER TABLE REPARATIE 
	DROP CONSTRAINT FK_REPARATIE_BIJ_HUUROVEREENKOMST
GO  

/*==============================================================*/
/* Alter Table: HUUROVEREENKOMST	                            */
/*==============================================================*/
/* Table: HUUROVEREENKOMST                                      */
/*                                                              */
/*==============================================================*/

CREATE TABLE ARTIKELENVERHUUR (
   BARCODE              char(8)              not null,
   STARTDATUM           datetime             not null,
   EMAILADRES           varchar(100)         not null,
)
GO

INSERT INTO ARTIKELENVERHUUR
	SELECT DISTINCT BARCODE, STARTDATUM, EMAILADRES FROM HUUROVEREENKOMST;

ALTER TABLE HUUROVEREENKOMST  
	DROP CONSTRAINT PK_HUUROVEREENKOMST

ALTER TABLE HUUROVEREENKOMST  
	DROP CONSTRAINT FK_HUUROVEREENKOMST_ARTIKEL

-- Drop index so we can remove the barcode column
DROP INDEX HUUROVEREENKOMST.Huurovereenkomst_barcode_einddatum;
ALTER TABLE HUUROVEREENKOMST
	DROP COLUMN BARCODE;

ALTER TABLE HUUROVEREENKOMST 	
	ADD CONSTRAINT PK_HUUROVEREENKOMST PRIMARY KEY (EMAILADRES, STARTDATUM)

ALTER TABLE ARTIKELENVERHUUR
	ADD CONSTRAINT FK_HUUROVEREENKOMST FOREIGN KEY (EMAILADRES, STARTDATUM) REFERENCES HUUROVEREENKOMST (EMAILADRES, STARTDATUM);
ALTER TABLE ARTIKELENVERHUUR
	ADD CONSTRAINT FK_ARTIKEL FOREIGN KEY (BARCODE) REFERENCES ARTIKEL (BARCODE);
GO



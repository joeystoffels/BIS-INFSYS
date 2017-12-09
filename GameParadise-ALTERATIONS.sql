USE gameparadise
GO


/*==============================================================*/
/* Table: SPELTYPE	                                            */
/*==============================================================*/
CREATE TABLE SPELTYPE (
	TYPE				VARCHAR(30)			not null,
	CONSTRAINT PK_SPELTYPE PRIMARY KEY (TYPE)
)
GO

/*==============================================================*/
/* Table: SPELTYPEPERSPEL	                                    */
/*==============================================================*/
CREATE TABLE SPELTYPEPERSPEL  (
	TYPE				VARCHAR(30)			not null,
	TITEL				VARCHAR(150)		not null,
	UITGEVER			VARCHAR(150)		not null,
	JAAR_UITGAVE		INT					not null,
	CONSTRAINT PK_SPELTYPEPERSPEL PRIMARY KEY (TYPE, TITEL, UITGEVER, JAAR_UITGAVE)
)
GO

/*==============================================================*/
/* Table: LEEFTIJDSCATEGORIE                                    */
/*==============================================================*/
CREATE TABLE LEEFTIJDSCATEGORIE (
	LEEFTIJDSCATEGORIE	VARCHAR(10)			not null,
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
/* Table: CATEGORIE			                                    */
/*==============================================================*/
CREATE TABLE CATEGORIE (
	CATEGORIE			CHAR(50)			not null,
	CONSTRAINT PK_CATEGORIE PRIMARY KEY (CATEGORIE)
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

INSERT INTO SPELTYPE 
	SELECT DISTINCT SINGLE_MULTIPLAYER FROM SPEL;

INSERT INTO SPELTYPEPERSPEL 
	SELECT DISTINCT TITEL, UITGEVER, JAAR_UITGAVE FROM SPEL;

INSERT INTO LEEFTIJDSCATEGORIE
	SELECT DISTINCT LEEFTIJDSCATEGORIE FROM SPEL;

INSERT INTO UITGEVER
	SELECT DISTINCT UITGEVER FROM SPEL;
	
INSERT INTO CATEGORIE
	SELECT DISTINCT CATEGORIE FROM SPEL;

INSERT INTO CATEGORIEPERSPEL
	SELECT DISTINCT CATEGORIE, TITEL, UITGEVER, JAAR_UITGAVE FROM SPEL;
	
EXEC sp_RENAME 'Spel.SINGLE_MULTIPLAYER', 'TYPE', 'COLUMN';

ALTER TABLE SPEL
	DROP CONSTRAINT TITEL;

ALTER TABLE SPEL
	DROP CONSTRAINT CATEGORIE;

ALTER TABLE SPEL
	ADD CONSTRAINT PK_SPEL PRIMARY KEY (TITEL, UITGEVER, JAAR_UITGAVE);

ALTER TABLE SPEL
	ADD CONSTRAINT FK_UITGEVER FOREIGN KEY (UITGEVER) REFERENCES UITGEVER (UITGEVER);

ALTER TABLE SPEL
	ADD CONSTRAINT FK_LEEFTIJDSCATEGORIE FOREIGN KEY (LEEFTIJDSCATEGORIE) REFERENCES LEEFTIJDSCATEGORIE (LEEFTIJDSCATEGORIE);

ALTER TABLE CATEGORIEPERSPEL
	ADD CONSTRAINT FK_SPEL FOREIGN KEY (TITEL, UITGEVER, JAAR_UITGAVE) REFERENCES SPEL (TITEL, UITGEVER, JAAR_UITGAVE);

ALTER TABLE CATEGORIEPERSPEL
	ADD CONSTRAINT FK_CATEGORIE FOREIGN KEY (CATEGORIE) REFERENCES CATEGORIE (CATEGORIE);

ALTER TABLE SPELTYPEPERSPEL
	ADD CONSTRAINT FK_SPEL FOREIGN KEY (TITEL, UITGEVER, JAAR_UITGAVE) REFERENCES SPEL (TITEL, UITGEVER, JAAR_UITGAVE);

ALTER TABLE SPELTYPEPERSPEL
	ADD CONSTRAINT FK_SPELTYPE FOREIGN KEY (TYPE) REFERENCES SPELTYPE (TYPE);



/*==============================================================*/
/* Table: MERK                                                  */ 
/*==============================================================*/
CREATE TABLE MERK   (
        MERK                            varchar(30)     not null,
        CONSTRAINT PK_MERK PRIMARY KEY (MERK)
)
GO


/*==============================================================*/
/* Table: TYPE                                                  */ 
/*==============================================================*/
CREATE TABLE TYPE   (
        TYPE                            varchar(30)     not null,
        CONSTRAINT PK_TYPE PRIMARY KEY (TYPE)
)
GO


/*==============================================================*/
/* Table: CONSOLES                                              */ 
/*==============================================================*/
CREATE TABLE CONSOLES   (
        MERK                            varchar(30)     not null,
        TYPE                            varchar(30)     not null,
        HUIDIGE_PRIJS                   decimal(6,2)    not null,
        CONSTRAINT PK_CONSOLES PRIMARY KEY (MERK, TYPE)
)
GO







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



USE gameparadise
go




/*==============================================================*/
/* Table: SPELTYPE	                                            */
/*==============================================================*/
create table SPELTYPE (
	TYPE				varchar(30)			not null,
	constraint PK_SPELTYPE primary key (TYPE)
)
go

/*==============================================================*/
/* Table: LEEFTIJDSCATEGORIE                                    */
/*==============================================================*/
create table LEEFTIJDSCATEGORIE (
	LEEFTIJDSCATEGORIE	varchar(10)			not null,
	constraint PK_LEEFTIJDSCATEGORIE primary key (LEEFTIJDSCATEGORIE)
)
go

/*==============================================================*/
/* Table: UITGEVER			                                    */
/*==============================================================*/
create table UITGEVER (
	UITGEVER			varchar(150)		not null,
	constraint PK_UITGEVER primary key (UITGEVER)
)
go

/*==============================================================*/
/* Table: SPELCATEGORIE   	                                    */
/*==============================================================*/
create table SPELCATEGORIE (
	CATEGORIE			char(50)			not null,
	TITEL				varchar(150)		not null,
	UITGEVER			varchar(150)		not null,
	JAAR_UITGAVE		int					not null,
	constraint PK_SPELCATEGORIE primary key (CATEGORIE, TITEL, UITGEVER, JAAR_UITGAVE)
)
go

/*==============================================================*/
/* Table: SPELTYPEPERSPEL	                                    */
/*==============================================================*/
create table TYPEPERSPEL  (
	TYPE				varchar(30)			not null,
	TITEL				varchar(150)		not null,
	UITGEVER			varchar(150)		not null,
	JAAR_UITGAVE		int					not null,
	constraint PK_SPELTYPEPERSPEL primary key (TYPE, TITEL, UITGEVER, JAAR_UITGAVE)
)
go











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
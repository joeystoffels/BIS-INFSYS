/*==============================================================*/
/* Database name:  GAMEPARADISE                                 */
/* DBMS name:      Microsoft SQL Server 2016                    */
/* Created on:     13-11-2017 11:22:09 AM                       */
/*==============================================================*/

use master
go

IF EXISTS(SELECT * FROM sysdatabases WHERE name = 'GAME_P')
	DROP DATABASE GAME_P
go

IF EXISTS(SELECT * FROM sysdatabases WHERE name = 'GAMEPARADISE')
	DROP DATABASE GAMEPARADISE
go

/*==============================================================*/
/* Database: GAMEPARADISE                                       */
/*==============================================================*/
create database GAMEPARADISE
go

use GAMEPARADISE
go

/*==============================================================*/
/* Table: CONSOLE                                               */
/*==============================================================*/
create table CONSOLE (
   MERK                 char(30)             not null,
   TYPE                 char(30)             not null,
   KLEUR                char(20)             null,
   JAAR_UITGAVE         int                  null,
   MAAT                 char(4)              null,
   OPMERKINGEN          varchar(200)         null,
   constraint PK_CONSOLE primary key (MERK, TYPE)
)
go		

/*==============================================================*/
/* Table: SPEL                                                  */
/*==============================================================*/
create table SPEL (
   TITEL                varchar(150)         not null,
   CATEGORIE            char(50)             not null,
   JAAR_UITGAVE         int                  null,
   UITGEVER             varchar(150)         null,
   LEEFTIJDSCATEGORIE   char(10)             null,
   SINGLE_MULTIPLAYER   char(6)              null,
   OMSCHRIJVING         text                 null,
   constraint PK_SPEL primary key (TITEL),
)
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
/* Table: ARTIKEL                                               */
/*==============================================================*/
create table ARTIKEL (
   BARCODE              char(8)              not null,
   MERK                 char(30)             null,
   TYPE                 char(30)             null,
   TITEL                varchar(150)         null,
   PRIJS                smallmoney			 not null,
   PRIJS_PER_D          smallmoney			 null,
   SPEL_OF_CONSOLE      char(7)              not null,
   constraint PK_ARTIKEL primary key nonclustered (BARCODE)
)
go

/*==============================================================*/
/* Table: CATEGORIE                                             */
/*==============================================================*/
create table CATEGORIE (
   CATEGORIE            char(50)             not null,
   constraint PK_CATEGORIE primary key nonclustered (CATEGORIE)
)
go

/*==============================================================*/
/* Table: KLANT                                                 */
/*                                                              */
/* KLANTSTATUS: GOLD / SILVER / BRONZE -- Kan berekend worden!  */
/*                                                              */
/*==============================================================*/
create table KLANT (
   EMAILADRES           varchar(100)         not null,
   MERK_EIGEN_CONSOLE   char(30)             null,
   TYPE_EIGEN_CONSOLE   char(30)             null,
   VOORNAMEN            varchar(150)         not null,
   ACHTERNAAM           varchar(150)         not null,
   ADRES                varchar(150)         not null,
   HUISNUMMER           char(10)             not null,
   POSTCODE             char(7)              not null,
   WOONPLAATS           varchar(30)          not null,
   GEBOORTEDATUM        datetime             not null,
   GESLACHT             char(1)              null,
   WACHTWOORD           char(25)             not null,
  /* KLANTSTATUS          char(6)              not null,*/ /* Kan berekend worden! */
   constraint PK_KLANT primary key (EMAILADRES),
)
go

/*==============================================================*/
/* Table: HUUROVEREENKOMST                                      */
/*                                                              */
/* HUURSTATUS: GERESERVEERD, VERHUURD, GEANNULEERD              */
/*                                                              */
/*==============================================================*/
create table HUUROVEREENKOMST (
   BARCODE              char(8)              not null,
   STARTDATUM           datetime             not null,
   EMAILADRES           varchar(100)         not null,
   EINDDATUM            datetime             not null,
   HUURSTATUS           char(20)             not null,
   SCHADE               bit                  null,
   REPARABEL            bit                  null,
   constraint PK_HUUROVEREENKOMST primary key (BARCODE, STARTDATUM),
)
go

/*==============================================================*/
/* Table: TELEFOONNUMMER                                        */
/*==============================================================*/
create table TELEFOONNUMMER (
   TELNUMMER            char(11)             not null,
   MOBIEL_OF_VAST       char(1)              not null,
   constraint PK_TELEFOONNUMMER primary key nonclustered (TELNUMMER)
)
go

/*==============================================================*/
/* Table: KLANTTELEFOONNR                                       */
/*==============================================================*/
create table KLANTTELEFOONNR (
   TELNUMMER            char(11)             not null,
   EMAILADRES           varchar(100)         not null,
   constraint PK_KLANTTELEFOONNR primary key (TELNUMMER, EMAILADRES),
)
go

/*==============================================================*/
/* Table: KOOPOVEREENKOMST                                      */
/*==============================================================*/
create table KOOPOVEREENKOMST (
   BARCODE              char(8)              not null,
   EMAILADRES           varchar(100)         not null,
   DATUM                datetime             not null,
   constraint PK_KOOPOVEREENKOMST primary key (BARCODE),
)
go

/*==============================================================*/
/* Table: INKOOPOVEREENKOMST                                    */
/*==============================================================*/
create table INKOOPOVEREENKOMST (
   BARCODE              char(8)              not null,
   EMAILADRES           varchar(100)         not null,
   DATUM                datetime             not null,
   INKOOPBEDRAG	        smallmoney			 not null,
   UITBETALING_CASH_OF_BONNEN char(6)        null,
   constraint PK_INKOOPOVEREENKOMST primary key (BARCODE),
)
go
/*==============================================================*/
/* Table: MEDEWERKER                                            */
/*==============================================================*/
create table MEDEWERKER (
   INLOGNAAM            char(15)             not null,
   WACHTWOORD           char(25)             not null,
   GEBOORTEDATUM        datetime             null,
   MEDEWERKERVOORNAAM   varchar(20)          not null,
   MEDEWERKERACHTERNAAM varchar(150)         not null,
   constraint PK_MEDEWERKER primary key (INLOGNAAM)
)
go

/*==============================================================*/
/* Table: ROL                                                   */
/*==============================================================*/
create table ROL (
   ROL                  char(20)             not null,
   constraint PK_ROL primary key (ROL)
)
go

/*==============================================================*/
/* Table: MEDEWERKERROL                                         */
/*==============================================================*/
create table MEDEWERKERROL (
   ROL                  char(20)             not null,
   INLOGNAAM            char(15)             not null,
   constraint PK_MEDEWERKERROL primary key (ROL, INLOGNAAM)
)
go

/*==============================================================*/
/* Table: REPARATIE                                             */
/*                                                              */
/*  Kosten moeten er ook bij, deze worden direct betaald        */
/*==============================================================*/
create table REPARATIE (
   SCHADENUMMER         int                  not null,
   BARCODE              char(8)              not null,
   STARTDATUM           datetime             not null,
   INLOGNAAM            char(15)             not null,
   DATUM_GEREED         datetime             not null,
   KOSTEN	         	smallmoney		     not null,
   REPARATIESTATUS      char(20)             null,
   constraint PK_REPARATIE primary key (SCHADENUMMER)
)
go

/* FOREIGN KEYS */

ALTER TABLE Artikel ADD CONSTRAINT FK_ARTIKEL_IS_CONSOLE foreign key (MERK, TYPE) references CONSOLE (MERK, TYPE);
ALTER TABLE Artikel ADD CONSTRAINT FK_ARTIKEL_IS_SPEL foreign key (TITEL) references SPEL (TITEL);

ALTER TABLE Klant ADD CONSTRAINT FK_KLANT_CONSOLE foreign key (MERK_EIGEN_CONSOLE, TYPE_EIGEN_CONSOLE) references CONSOLE (MERK, TYPE);

ALTER TABLE Huurovereenkomst ADD CONSTRAINT FK_HUUROVEREENKOMST_ARTIKEL foreign key (BARCODE) references ARTIKEL (BARCODE);
ALTER TABLE Huurovereenkomst ADD CONSTRAINT FK_HUUROVEREENKOMST_KLANT foreign key (EMAILADRES) references KLANT (EMAILADRES);

ALTER TABLE Klanttelefoonnr ADD CONSTRAINT FK_KLANTTELEFOONNUMMER_HEEFT_NUMMER foreign key (TELNUMMER) references TELEFOONNUMMER (TELNUMMER);
ALTER TABLE Klanttelefoonnr ADD CONSTRAINT FK_KLANTTELEFOONNUMMER_HOORT_BIJ_KLANT foreign key (EMAILADRES) references KLANT (EMAILADRES);

ALTER TABLE Koopovereenkomst ADD CONSTRAINT FK_KOOP_AAN_KLANT foreign key (EMAILADRES) references KLANT (EMAILADRES);
ALTER TABLE Koopovereenkomst ADD CONSTRAINT FK_KOOP_ARTIKEL foreign key (BARCODE) references ARTIKEL (BARCODE);

ALTER TABLE Inkoopovereenkomst ADD CONSTRAINT FK_INKOOP_VAN_KLANT foreign key (EMAILADRES) references KLANT (EMAILADRES);
ALTER TABLE Inkoopovereenkomst ADD CONSTRAINT FK_INKOOP_VAN_ARTIKEL foreign key (BARCODE) references ARTIKEL (BARCODE);

ALTER TABLE Medewerkerrol ADD CONSTRAINT FK_MEDEWERKER_IS_ROL foreign key (ROL) references ROL (ROL);
ALTER TABLE Medewerkerrol ADD CONSTRAINT FK_MEDEWERKER_HEEFT_ROL foreign key (INLOGNAAM) references MEDEWERKER (INLOGNAAM);
CREATE INDEX Huurovereenkomst_barcode_einddatum ON HUUROVEREENKOMST (BARCODE, EINDDATUM);
ALTER TABLE Reparatie ADD CONSTRAINT FK_REPARATIE_DOOR_MEDEWERKER foreign key (INLOGNAAM) references MEDEWERKER (INLOGNAAM);

/* LET OP: foreignkey klopt eigenlijk niet, Einddatum van huurovereenkomst kan de begindatum van een reparatie zijn. Startdatum kan dat eigenlijk niet */
ALTER TABLE Reparatie ADD CONSTRAINT FK_REPARATIE_BIJ_HUUROVEREENKOMST foreign key (BARCODE, STARTDATUM) references HUUROVEREENKOMST (BARCODE, STARTDATUM);

ALTER TABLE Spel ADD CONSTRAINT FK_SPEL_HOORT_BIJ_SPELCATEGORIE foreign key (CATEGORIE) references CATEGORIE (CATEGORIE);

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
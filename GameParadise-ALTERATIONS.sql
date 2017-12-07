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
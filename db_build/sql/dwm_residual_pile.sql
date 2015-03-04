-- Create the DWM_RESIDUAL_PILE table
create table FIA.DWM_RESIDUAL_PILE(
	CN varchar(34),
	PLT_CN varchar(34),
	INVYR numeric(4,0),
	STATECD	numeric(4,0),
	COUNTYCD numeric(3,0),
	PLOT numeric(5,0),
	SUBP numeric(1,0),
	PILE smallint,
	MEASYEAR numeric(4,0),
	CONDID numeric(1,0),
	SHAPECD numeric(1,0),
	AZIMUTH numeric(3,0),
	DENSITY numeric(2,0),
	HEIGHT1 numeric(2,0),
	WIDTH1 numeric(2,0),
	LENGTH1 numeric(2,0),
	HEIGHT2 numeric(2,0),
	WIDTH2 numeric(2,0),
	LENGTH2 numeric(2,0),
	VOLCF double precision,
	DRYBIO double precision,
	CARBON double precision,
	PPA_UNADJ double precision,
	PPA_PLOT double precision,
	PPA_COND double precision,
	CREATED_BY varchar(30),
	CREATED_DATE date,
	CREATED_IN_INSTANCE varchar(6),
	MODIFIED_BY varchar(30),
	MODIFIED_IN_INSTANCE varchar(6), -- order was changed in file
	MODIFIED_DATE date,
	COMP_HT numeric(2,0),
	DECAYCD numeric(1,0),
	HORIZ_BEGNDIST numeric(3,1),
	HORIZ_ENDDIST numeric(3,1),
	PILE_SAMPLE_METHOD	varchar(6),
	SPCD numeric(4,0),
	TRANSECT numeric(3,0),
	PRIMARY KEY(CN), UNIQUE(PLT_CN,SUBP,TRANSECT,PILE)
);
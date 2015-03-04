-- Create the P2VEG_SUBPLOT_SPP table
create table FIA.P2VEG_SUBPLOT_SPP(
	CN varchar(34),
	PLT_CN varchar(34),
	INVYR numeric(4,0),
	STATECD	numeric(4,0),
	UNITCD numeric(2,0),
	COUNTYCD numeric(3,0),
	PLOT integer,
	SUBP smallint,
	CONDID numeric(1,0),
	VEG_FLDSPCD varchar(10),
	UNIQUE_SP_NBR numeric(2,0),
	VEG_SPCD varchar(10),
	GROWTH_HABIT_CD varchar(2),
	LAYER numeric(1,0),
	COVER_PCT numeric(3,0),
	CREATED_BY varchar(30),
	CREATED_DATE date,
	CREATED_IN_INSTANCE varchar(6),
	MODIFIED_BY varchar(30),
	MODIFIED_DATE date,
	MODIFIED_IN_INSTANCE varchar(6),
	CYCLE numeric(2,0),
	SUBCYCLE numeric(2,0),
	PRIMARY KEY (CN),
	UNIQUE(PLT_CN, VEG_FLDSPCD, UNIQUE_SP_NBR, SUBP, CONDID)
);
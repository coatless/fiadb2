-- Create the SUBPLOT_REGEN table
create table FIA.SUBPLOT_REGEN(
	CN varchar(34),
	PLT_CN varchar(34),
	SBP_CN	varchar(34),
	INVYR numeric(4,0),
	STATECD numeric(4,0),
	UNITCD numeric(2,0),
	COUNTYCD numeric(3,0),
	PLOT numeric(5,0),
	SUBP numeric(2,0),
	REGEN_SUBP_STATUS_CD numeric(1,0),
	REGEN_SUBP_NONSAMPLE_REASN_CD numeric(2,0),
	SUBPLOT_SITE_LIMITATIONS numeric(1,0),
	MICROPLOT_SITE_LIMITATIONS numeric(1,0),
	CREATED_BY varchar(30),
	CREATED_DATE date,
	CREATED_IN_INSTANCE varchar(6),
	MODIFIED_BY varchar(30),
	MODIFIED_DATE date,
	MODIFIED_IN_INSTANCE varchar(6),
	CYCLE numeric(2,0),
	SUBCYCLE numeric(2,0),
	PRIMARY KEY (CN),
	UNIQUE(STATECD, COUNTYCD, PLOT, SUBP, INVYR)
);
COPY FIA.SUBPLOT_REGEN FROM 'F:\Documents\GitHub\nasacms\fia\SUBPLOT_REGEN.CSV' DELIMITER ',' CSV HEADER;
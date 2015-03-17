#!/bin/bash

function usage
{
    echo "usage: fiadb [[[-b] [-u username] [-hf host] [-W password] [] ] | [-h]]"
}

#Parameters are set using export
function dbcreate
{
	COMMAND=$(cat <<EOF
CREATE DATABASE $DBNAME;
CREATE SCHEMA $DBSCHEMA;
EOF
)
	psql -d $DBNAME -U $USERNAME -h $DBHOST -p $PORT -a -w -c $COMMAND
	psql_exit_status = $?

	if [ $psql_exit_status != 0 ]; then
		echo "psql failed while trying to create database and schema" 1>&2
		exit $psql_exit_status
	fi
}

#1 parameter needs to be passed in containing the file name
function dbfile
{
	FILE=$1
	psql -d $DBNAME -U $USERNAME -h $DBHOST -p $PORT -a -w -f $FILE.sql
}

# Export statements
export DBHOST="localhost"
export DBNAME="fiadb"
export DBSCHEMA="fia"
export USERNAME="postgres"
export PORT=5432
export PGPASSWORD="nasa"

# features
CREATE_DB=false
DOWNLOAD_DATA=false
COPY_DATA=false
TIDY=false

# Run the file in the directory with expanded .csv
TABLE_STRUCTURE_FILE="create_fia_tables.sql"
COPY_STATEMENTS_FILE="copy_to_fia_db.sql"


# Creation Variables	
while [ "$1" != "" ]; do
    case $1 in
	    -c | --createdb )
			CREATE_DB=true
			;;
	    -g | --getdata )
			DOWNLOAD_DATA=true
			;;
	    -i | --getdata )
			COPY_DATA=true
			;;
		-t | --tidy)
			TIDY=true
			;;
        -b | --builddb )
			CREATE_DB=true
			DOWNLOAD_DATA=true
			COPY_DATA=true
			;;
		-d | --dbname ) 
			shift
            export DBNAME=$1
            ;;
		-s | --dbschema)
			shift
            export DBSCHEMA=$1
            ;;
		-u | --user ) 
			shift
            export USERNAME=$1
            ;;
		-R | --host)
			shift
            export HOST=$1
            ;;
		-p | --port ) 
			shift
            export PORT=$1
            ;;
		-W | --password)
			shift
            export PGPASSWORD=$1
            ;;
        -h | --help )
			usage
            exit
            ;;
        * )
		usage
        exit 1
		;;
    esac
    shift
done

# Build the database and data schema
if [ "$CREATE_DB" == true ]; then

	echo "[SQL] Creating the DB .... "
	# Call create db function
	dbcreate
	
	echo "[OPS] Downloading table structure..."
	wget https://github.com/coatless/nasacms/blob/master/db_build/table_structure_sql.zip
	
	echo "[OPS] Extracting table structure..."
	# Extract the fia table structure sql files
	7z e table_structure_sql.zip -o fia_sql
	# Merge files together
	cat fia_sql/*.sql > $TABLE_STRUCTURE_FILE

fi

# Download and save data to current directory
if [ "$DOWNLOAD_DATA" == true ]; then
	echo "[OPS] Downloading Data..."
	wget http://apps.fs.fed.us/fiadb-downloads/ENTIRE.zip
fi

# Import data into postgres
if [ "$COPY_DATA" == true ]; then
	echo "[OPS] Extracting data..."
	7z e ENTIRE.zip -o fia
	
	echo "[DATA] Fixing Encoding Issue with POP_EVAL..."
	# Fix the file encoding issue with POP_EVAL
	sed -i "s/\x96/-/g" fia/POP_EVAL.CSV
	
	echo "[SQL] Creating copy sql..."
	# Obtain each .csv extracted and build a copy statement.
	for file in `find fia -name "*.csv"` 
	do
		table_name=${file%.csv}
		echo "COPY $DBSCHEMA.$table_name FROM '$file.csv' DELIMITER ',' CSV HEADER;" >> $COPY_STATEMENTS_FILE
	done
	
	echo "[SQL] Copying data into PostGres..."
	dbfile $COPY_STATEMENTS_FILE
fi;

if [ "$ERRORS" == false ]; then
	echo "No errors! The sql script was successful"

	if [ "$COPY_DATA" == true ]; then
		echo "Cleaning up... Removing master sql query..."
		rm -rf $TABLE_STRUCTURE_FILE
		rm -rf $COPY_STATEMENTS_FILE
	fi;

else
	echo "There were errors in the script! Not removing components."
fi;

exit 0

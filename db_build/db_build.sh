#!/bin/bash

# Extract all files from zip and place them in fia
7z e ENTIRE.zip -o fia

# Fix the file encoding issue with POP_EVAL
sed -i "s/\x96/-/g" fia/POP_EVAL.CSV

# Run the file in the directory with expanded .csv
OUTPUT_FILE="copy_to_fia_db.sql"

# Obtain each .csv extracted and build a copy statement.
for file in `find fia -name "*.csv"` 
do
	table_name=${file%.csv}
	echo "COPY FIA.$table_name FROM '$file.csv' DELIMITER ',' CSV HEADER;" >> $OUTPUT_FILE
done

# Extract the fia table structure sql files
7z e fia_sql.zip -o fia_sql

cat fia_sql/*.sql > create_fia_tables.sql

if [ $# != 2 ]; then
    echo "please enter a db host and a table suffix"
    exit 1
fi

export DBHOST=$1
export TSUFF=$2

psql \
    -X \
    -U postgres \
    -h $DBHOST \
    -f create_fia_tables.sql \
    --echo-all \
    --set AUTOCOMMIT=off \
    --set ON_ERROR_STOP=on \
    --set TSUFF=$TSUFF \
    --set QTSTUFF=\'$TSUFF\' \
    fia

psql_exit_status = $?

if [ $psql_exit_status != 0 ]; then
    echo "psql failed while trying to create table structure" 1>&2
    exit $psql_exit_status
fi


psql \
    -X \
    -U postgres \
    -h $DBHOST \
    -f copy_to_fia_db.sql \
    --echo-all \
    --set AUTOCOMMIT=off \
    --set ON_ERROR_STOP=on \
    --set TSUFF=$TSUFF \
    --set QTSTUFF=\'$TSUFF\' \
    fia

psql_exit_status = $?

if [ $psql_exit_status != 0 ]; then
    echo "psql failed while trying to run this sql script" 1>&2
    exit $psql_exit_status
fi

echo "No errors? Then the sql script was successful"
echo "Cleaning up... Removing master sql query..."
rm -rf create_fia_tables.sql
rm -rf copy_to_fia_db.sql

exit 0

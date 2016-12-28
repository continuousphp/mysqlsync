#!/bin/bash

rm schema.sql

MYSQLHOST=192.168.28.14
MYSQLPORT=3306
MYSQLUSER=awsdms
MYSQLPASS="AAAhz6ieja"

mysqldump  \
	--host=$MYSQLHOST \
	--port $MYSQLPORT \
	-u $MYSQLUSER \
	-p$MYSQLPASS \
	--all-databases \
	--single-transaction \
	--no-data \
	> schema.sql

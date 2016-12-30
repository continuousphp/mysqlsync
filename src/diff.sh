#!/bin/bash

DIFF_PATH="$MYSQLSYNC_PATH/.diff"

if [ ! -d $DIFF_PATH ]
  then
	mkdir $DIFF_PATH
fi

diff_ls_databases()
{
	echo "show databases" \
	  | mysql -h $DST_HOST -u $DST_USER -p$DST_PASSWORD \
	  | sed '1d' \
	  | sed 's/information_schema//g' \
	  | sed 's/performance_schema//g' \
	  | sed 's/awsdms_control//g' \
	  | sed 's/mysql//g' \
	  | tr "\\n" " " \
	> /dev/stdout
}

diff_schema()
{
	for dbname in $(diff_ls_databases)
	do
		echo -e "diff of ${GREEN}$dbname${NORMAL} started at `date +%c`"

		sqlfile=$DIFF_PATH/$dbname.diff.sql
		md5file=$DIFF_PATH/$dbname.diff.md5

		echo "use $dbname;" > $sqlfile

		$mysqldiffbin \
		  -i \
		  -d 1 \
		  --host2=$SRC_HOST --user2=$SRC_USER --password2 $SRC_PASSWORD \
		  --host1=$DST_HOST --user1=$DST_USER --password1 $DST_PASSWORD \
		  $dbname $dbname \
		| sed -e 's/#.*//g' \
		>> $sqlfile
        
        ec=$?
        
        if [ ! "0" == "$ec" ]
        then
            sns "mysqldiff have not ended sucessfully for database \`$dbname\`, exit code $ec"
            slack "mysqldiff have not ended sucessfully for database \`$dbname\`, exit code $ec" ":bangbang:"
        fi

		if [ ! -f $md5file ]
		    then
			touch $md5file
		fi

		md5=`md5sum $sqlfile | awk '{print $1}'`

		if [ "$md5" == "`cat $md5file`" ] 
		    then
			rm $sqlfile
			echo -e "${BLUE}diff has not change, skip $dbname${NORMAL}"
			continue
		fi

		echo $md5 > $md5file
	done
}

diff_raw_sql()
{
	target=$1

	if [ "" == "$target" ]
	  then
		echo -e "${RED}First param of diff_raw_sql function missing${NORMAL}"
		exit 3
	fi
	
	for dbname in $(diff_ls_databases)
	do
		echo -e "RAW SQL $target diff of ${GREEN}$dbname${NORMAL} started at `date +%c`"
		echo "use $dbname;" > $DIFF_PATH/$dbname.$target.sql

		cat $MYSQLSYNC_PATH/sql/$target.sql \
		| sed "s/:dbname:/$dbname/g" \
		| mysql -h $SRC_HOST -u $SRC_USER -p$SRC_PASSWORD \
		| sed '1d' \
		> $DIFF_PATH/$dbname.$target.src.diff

		cat $MYSQLSYNC_PATH/sql/$target.sql \
		| sed "s/:dbname:/$dbname/g" \
		| mysql -h $DST_HOST -u $DST_USER -p$DST_PASSWORD \
		| sed '1d' \
		> $DIFF_PATH/$dbname.$target.dst.diff

		diff -u \
		  $DIFF_PATH/$dbname.$target.dst.diff \
		  $DIFF_PATH/$dbname.$target.src.diff \
		| grep -E "^\+" \
		| sed '1d' \
		| cut -d "+" -f 2- \
		>> $DIFF_PATH/$dbname.$target.sql

		rm $DIFF_PATH/$dbname.$target.src.diff $DIFF_PATH/$dbname.$target.dst.diff

		if [ "1" == `cat $DIFF_PATH/$dbname.$target.sql | wc -l` ]
		  then
			rm $DIFF_PATH/$dbname.$target.sql
		fi
	done
}

diff_apply_change()
{
	if [ ! "$(ls -A $DIFF_PATH)" ]
	  then
		echo -e "${BLUE}Nothing to apply.${NORMAL}"
		return
	fi

	for file in `ls $DIFF_PATH/*.sql`
	do
		echo -e "Apply SQL change $file..."
		mysql -u $DST_USER -p$DST_PASSWORD -h $DST_HOST < $file
		ec=$?
		if [ ! "0" == $ec ]
		  then
			echo -e "${RED}Error during apply SQL change. Exit code:$ec.${NORMAL}"
			slack "Error during apply SQL PATCH \`$file\`, exit code $ec" ":bangbang:"
			mv $file "$file.err"
		else
			rm $file
			echo -e "${GREEN}$file Done.${NORMAL}"
		fi
	done
}


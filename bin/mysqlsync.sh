#!/bin/bash -
#title           :mysqlsync
#description     :Synchronize MYSQL DB Schema between two databases
#author          :© 2016 Continuous SA - Tomasina Pierre
#date            :20161219
#version         :0.1
#usage           :bash mysqlsync
#notes           :Requirement : git, mysqlclient, ruby2.4
#==============================================================================

pushd `dirname $0`/../ > /dev/null
MYSQLSYNC_PATH=`pwd -P`
popd > /dev/null

_term()
{
    unset sleep
    trap 'echo `date +%c`: SIGTERM signal received, TERMinated now; kill $sleep; exit 0' TERM
    sleep $1 & sleep=$!; wait
}

_foreground()
{
    if [ -n "$iflag" ]
    then
	_term $respawn
    else
	exit 0
    fi
}

GREEN="\\033[1;32m"
NORMAL="\\033[0;39m"
RED="\\033[1;31m"
PINK="\\033[1;35m"
BLUE="\\033[1;34m"
WHITE="\\033[0;02m"
YELLOW="\\033[1;33m"
CYAN="\\033[1;36m"

source $MYSQLSYNC_PATH/src/clean-sql.sh
source $MYSQLSYNC_PATH/src/diff.sh
source $MYSQLSYNC_PATH/src/alert.sh

# function for help output
function usage {
  echo -e "DESCRIPTION:\n\t $(basename "$0") - Synchronize MYSQL DB Schema between two databases.\n\t Project found at ${BLUE}https://github.com/continuousphp$NORMAL"
  echo -e "USAGE:\n\t [OPTIONS] ACTION\n
\033[1mOPTIONS\033[0m
  -h\t Displays this message.
  -b\t mysqlbinlog binary. (Default at /usr/bin/mysqlbinlog)
  -d\t mysqldiff binary. (Default at /usr/local/src/mysqldiff/bin/mysqldiff.sh)
  -c\t Credentials of Databases in string format \"${BLUE}SRC_HOST=x SRC_USER=x SRC_PASSWORD=x DST_HOST=x DST_USER=x DST_PASSWORD=x${NORMAL}\"
  -i\t Run the action infinitely with pause during respwan time between each execution
  -r\t Respawn time in minute to wait before re execution (use with -i default to 60).

\033[1mACTIONS\033[0m
  schema\t Update DST to have same mysql structure as SRC
  default\t Update DST to have same default columns as SRC
  ebinlog\t Export binlog
  ibinlog\t Import binlog

"
}

#Function for error handling
bail ()
{
  echo -e "${RED}Error code $1${NORMAL}"
  usage
  exit 1
}

credential_src_check()
{
	if [ -z ${SRC_HOST+x} ]
	  then
		echo -e "SRC_HOST must be in -c option."
		bail 1
	fi
	if [ -z ${SRC_USER+x} ]
	  then
		echo -e "SRC_USER must be in -c option."
		bail 1
	fi
	if [ -z ${SRC_PASSWORD+x} ]
	  then
		echo -e "SRC_PASSWORD must be in -c option."
		bail 1
	fi
}

credential_dst_check()
{
	if [ -z ${DST_HOST+x} ]
	  then
		echo -e "DST_HOST must be in -c option."
		bail 1
	fi
	if [ -z ${DST_USER+x} ]
	  then
		echo -e "DST_USER must be in -c option."
		bail 1
	fi
	if [ -z ${DST_PASSWORD+x} ]
	  then
		echo -e "DST_PASSWORD must be in -c option."
		bail 1
	fi
}

mbl=/usr/bin/mysqlbinlog
mysqldiffbin=/usr/local/src/mysqldiff/bin/mysqldiff.sh
respawn=3600

while getopts ":hb:c:ir:" opt; do
	case $opt in
	  h) usage && exit 0 ;;
	  b) mbl="$OPTARG" ;;
	  d) mysqldiffbin="$OPTARG" ;;
	  c) export $OPTARG
             credential_src_check
	     ;;
      	  i) iflag="defined" ; echo "$$" > /var/run/mysqlsync.pid ;;
      	  r) let respawn=60*$OPTARG ;;
	  \?) echo -e "${RED}Invalid option: -$OPTARG${NORMAL}" >&2 ; bail 1 ;;
	  :)  echo "Option -$OPTARG requires an argument." >&2 ; bail 2 
	esac
done

shift $((OPTIND-1))

if [[ ! $respawn =~ ^[1-9][0-9]*$ ]] 
  then
	echo -e "Option -r must be greater than 0."
	bail 2
fi



######
## Actions 
######

if [ "" == "$1" ]
  then
	echo -e "${RED}action parameter are missing${NORMAL}"
	bail 1
fi

if [ "schema" == "$1" ]
  then
	if [ ! -x $mysqldiffbin ]
  	  then
		echo -e "Option -d mysqldiff programm not found at $mysqldiffbin."
		bail 2
	fi

	credential_src_check
	credential_dst_check

	while true
    do
		echo -e "${BLUE}Synchronise schema from $SRC_HOST to $DST_HOST...${NORMAL}"
	   	diff_schema
	    diff_raw_sql "primary"
	    diff_raw_sql "index"
	    diff_apply_change

		_foreground
    done
fi

if [ "default" == "$1" ]
  then
	echo "Default not yet implemented"
    exit 0
fi

if [ "ebinlog" == "$1" ]
  then
    if [ ! -x $mbl ]
      then
        echo -e "Option -b mysqlbinlog programm not found at $mbl."
        bail 2
    fi

    while true
    do
        echo "Export binlog..."
	_foreground
    done
fi


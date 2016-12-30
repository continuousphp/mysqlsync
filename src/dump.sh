#!/bin/bash

cleandefiner()
{
    sed \
        -e 's/\/\*![[:digit:]]\{5\}\sDEFINER=.*\*\///g' \
        -e "s/'b'0''/b'0'/g" \
        -e "s/'b'1''/b'1'/g" \
    < /dev/stdin > /dev/stdout
}

dumpstruct()
{
    mysqldump  \
        --host=$SRC_HOST \
        -u $SRC_USER \
        -p$SRC_PASSWORD \
        --all-databases \
        --single-transaction \
        --no-data \
    | cleandefiner
}

dumpdata()
{
    echo "Not implemented"
}


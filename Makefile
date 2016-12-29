SHELL := /bin/bash
 
GREEN   := "\\033[1;32m"
NORMAL  := "\\033[0;39m"
RED     := "\\033[1;31m"
PINK    := "\\033[1;35m"
BLUE    := "\\033[1;34m"
WHITE   := "\\033[0;02m"
YELLOW  := "\\033[1;33m"
CYAN    := "\\033[1;36m"

PATH = $(shell pwd)

install:
	@if [ -d /etc/mysqlsync ] ; then \
		echo -e ${YELLOW}"Configuration already exists. keep actual."${NORMAL}; \
	else \
		/bin/cp -r ${PATH}/etc /etc/mysqlsync; \
	fi
	@echo '#!/bin/bash' > /usr/local/bin/mysqlsync
	@echo 'bash ${PATH}/bin/mysqlsync.sh "$$@" &' >> /usr/local/bin/mysqlsync
	/bin/chmod +x /usr/local/bin/mysqlsync
	/bin/cp ${PATH}/service/mysqlsync-schema /etc/init.d/
	mkdir /var/log/mysqlsync
	echo "TODO Must install rotated log"
	echo -e ${GREEN}"Install done."${NORMAL}
uninstall:
	/bin/rm -f /usr/local/bin/mysqlsync
	/bin/rm -f /etc/init.d/mysqlsync-schema
	
purge:
	/bin/rm -rf /etc/mysqlsync

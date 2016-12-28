#!/bin/bash

function cleansql {

sed \
	-e 's/\/\*![[:digit:]]\{5\}\sDEFINER=`root`@`localhost`\s*\*\///g' \
	-e 's/\/\*![[:digit:]]\{5\}\sDEFINER=`root`@`localhost` SQL SECURITY DEFINER\s*\*\///g' \
	-e 's/\/\*![[:digit:]]\{5\}\sDEFINER=`root`@`localhost` SQL SECURITY INVOKER\s*\*\///g' \
	-e 's/\/\*![[:digit:]]\{5\}\sDEFINER=`admindb1`@``\s*\*\///g' \
	-e 's/\/\*![[:digit:]]\{5\}\sDEFINER=`admindb1`@`` SQL SECURITY DEFINER\s*\*\///g' \
	-e 's/\/\*![[:digit:]]\{5\}\sDEFINER=`rachedi`@`%`\s*\*\///g' \
	-e 's/\/\*![[:digit:]]\{5\}\sDEFINER=`rachedi`@`%` SQL SECURITY DEFINER\s*\*\///g' \
	-e 's/\/\*![[:digit:]]\{5\}\sDEFINER=`rachedi`@``\s*\*\///g' \
	-e 's/\/\*![[:digit:]]\{5\}\sDEFINER=`rachedi`@`` SQL SECURITY DEFINER\s*\*\///g' \
	-e 's/\/\*![[:digit:]]\{5\}\sDEFINER=`hugues`@`%`\s*\*\///g' \
	-e 's/\/\*![[:digit:]]\{5\}\sDEFINER=`hugues`@`%` SQL SECURITY DEFINER\s*\*\///g' \
	-e 's/\/\*![[:digit:]]\{5\}\sDEFINER=`hugues`@``\s*\*\///g' \
	-e 's/\/\*![[:digit:]]\{5\}\sDEFINER=`hugues`@`` SQL SECURITY DEFINER\s*\*\///g' \
	-e 's/\/\*![[:digit:]]\{5\}\sDEFINER=`sql_admin`@`alain.astelys.fr`\s*\*\///g' \
	-e 's/\/\*![[:digit:]]\{5\}\sDEFINER=`sql_admin`@`alain.astelys.fr` SQL SECURITY DEFINER\s*\*\///g' \
	-e 's/\/\*![[:digit:]]\{5\}\sDEFINER=`hugues2`@``\s*\*\///g' \
	-e 's/DEFINER=`root`@`%`//g' \
	-e "s/'b'0''/b'0'/g" \
	-e "s/'b'1''/b'1'/g" \
	< /dev/stdin > /dev/stdout
}

#	-e 's//*!50017 DEFINER=`root`@`localhost`*///' \
#	-e 's//*!50017 DEFINER=`root`@`%`*///' \
#	-e 's//*!50020 DEFINER=`root`@`localhost`*///' \
#	-e 's//*!50020 DEFINER=`root`@`%`*///' \
#	-e 's//*!50017 DEFINER=`web`@`%`*///' \
#	-e 's//*!50017 DEFINER=`cron`@`%`*///' \
#	-e 's//*!50013 DEFINER=`cron`@`%` SQL SECURITY DEFINER *///' \
#	-e 's//*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER *///' \
#	-e 's//*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER *///' \
#	-e 's//*!50013 DEFINER=`web`@`%` SQL SECURITY DEFINER *///' \
#	-e 's//*!50017 DEFINER=`admindb1`@``*///' \
#	-e 's//*!50017 DEFINER=`sql_admin`@`alain.astelys.fr`*///' \
#	-e 's//*!50020 DEFINER=`admindb1`@``*///' \
#	-e 's//*!50020 DEFINER=`sql_admin`@`alain.astelys.fr`*///'

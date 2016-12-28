use carto;








ALTER TABLE `carto_main` DROP INDEX `projet_id`; 
ALTER TABLE `carto_main` ADD UNIQUE `projet_id` (`projet_id`);
ALTER TABLE `carto_session` ADD INDEX ((`session_id`)); 
ALTER TABLE `carto_session` DROP PRIMARY KEY; 
ALTER TABLE `carto_session` ENGINE=MyISAM DEFAULT CHARSET=latin1; 
ALTER TABLE `ellipsoid` CHANGE COLUMN `id` `id` int(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `ellipsoid` CHANGE COLUMN `name` `name` varchar(32) NOT NULL DEFAULT ''; 
ALTER TABLE `ellipsoid` CHANGE COLUMN `a` `a` double NOT NULL DEFAULT '0'; 
ALTER TABLE `ellipsoid` CHANGE COLUMN `e` `e` double NOT NULL DEFAULT '0'; 
ALTER TABLE `ellipsoid` ADD INDEX ((`id`)); 
ALTER TABLE `ellipsoid` DROP PRIMARY KEY; 
ALTER TABLE `ellipsoid` ENGINE=MyISAM DEFAULT CHARSET=latin1; 
ALTER TABLE `shp_commune` CHANGE COLUMN `NAME` `NAME` varchar(255) NOT NULL DEFAULT ''; 
ALTER TABLE `shp_commune` CHANGE COLUMN `geom` `geom` geometry DEFAULT NULL; 
ALTER TABLE `shp_commune` CHANGE COLUMN `AREA_ID` `AREA_ID` bigint(20) NOT NULL DEFAULT '0'; 
ALTER TABLE `shp_commune` CHANGE COLUMN `TYPE` `TYPE` varchar(255) NOT NULL DEFAULT ''; 
ALTER TABLE `shp_commune` CHANGE COLUMN `ID` `ID` bigint(20) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `shp_commune` CHANGE COLUMN `CODE_INSEE` `CODE_INSEE` varchar(10) NOT NULL DEFAULT ''; 
ALTER TABLE `shp_commune` ADD INDEX `NAME` (`NAME`);
ALTER TABLE `shp_commune` ENGINE=MyISAM DEFAULT CHARSET=latin1; 
ALTER TABLE `shp_street` CHANGE COLUMN `geom` `geom` geometry DEFAULT NULL; 
ALTER TABLE `shp_street` CHANGE COLUMN `R_POSTCODE` `R_POSTCODE` varchar(10) NOT NULL DEFAULT ''; 
ALTER TABLE `shp_street` CHANGE COLUMN `R_INSEE` `R_INSEE` varchar(10) NOT NULL DEFAULT ''; 
ALTER TABLE `shp_street` CHANGE COLUMN `ID` `ID` bigint(20) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `shp_street` CHANGE COLUMN `L_INSEE` `L_INSEE` varchar(10) NOT NULL DEFAULT ''; 
ALTER TABLE `shp_street` CHANGE COLUMN `L_POSTCODE` `L_POSTCODE` varchar(10) NOT NULL DEFAULT ''; 
ALTER TABLE `shp_street` ADD INDEX `ST_NAME` (`NOMVOIE`);
ALTER TABLE `shp_street` ADD INDEX `ORDER` (`L_POSTCODE`,`R_POSTCODE`);
ALTER TABLE `shp_street` ENGINE=MyISAM DEFAULT CHARSET=latin1; 

use :dbname:;
SELECT
  CONCAT(
    'ALTER TABLE `', TABLE_NAME, '` ',
    'MODIFY COLUMN `', COLUMN_NAME, '` ',

    IF(UPPER(DATA_TYPE) = 'INT',
      REPLACE(
        SUBSTRING_INDEX(
          UPPER(COLUMN_TYPE), ')', 2
        ),
        'INT',
        'INTEGER'
      ),
      UPPER(COLUMN_TYPE)
    ),
    ' NOT NULL AUTO_INCREMENT;'
  ) as patch
FROM
  information_schema.COLUMNS
WHERE
  TABLE_SCHEMA = ':dbname:'
  AND EXTRA = UPPER('AUTO_INCREMENT')
ORDER BY TABLE_NAME ASC;

OPTIONS (load=1)
LOAD DATA
INFILE "will sed the name for csv document"
TRUNCATE
INTO TABLE EBS_BSSHEET_SET
fields terminated by ","
optionally enclosed by '"'
trailing nullcols
(
    REPORT_ID,
    REPORT_FLAG,
    period_date,
    sys_date,
    com_code,
    dept_code,
    line_count_num,
    BSSHEET_SET_ID "EBS_PLSHEET_SET_S.nextval"
)
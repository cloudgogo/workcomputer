OPTIONS (skip=1,row=128)
LOAD DATA
INFILE "will sed the name for csv document"
TRUNCATE
INTO TABLE EBS_BSSHEET_SET
fields terminated by ","
optionally enclosed by '"'
trailing nullcols
(
    REPORT_ID,
    
    BSSHEET_SET_ID "EBS_PLSHEET_SET_S.nextval"
)
OPTIONS (load=1,skip=1,row=128)
LOAD DATA
INFILE "will sed the name for csv document"
TRUNCATE
INTO TABLE EBS_BSSHEET_SET
fields terminated by ","
optionally enclosed by '"'
trailing nullcols
(
    virtual_colum FILLER,
    user_id "to_number(:user_id)",
    user_name,
    login_times,
    last_login DATE"YYYY-MM-DD HH24:MI:SS",
    times "sysdate",
    id "test_user_s.nextval"
)
CREATE TABLE EBS_BSSHEET_SET(
BSSHEET_SET_ID NUMBER,
REPORT_ID  VARCHAR(15),
REPORT_FLAG VARCHAR2(15),
period_date date,
sys_date varchar2(15),
com_code VARCHAR2(50),
dept_code varchar2(50),
line_count_num NUMBER,
SEGMENT1 VARCHAR2(255),
SEGMENT2 VARCHAR2(255),
SEGMENT3 VARCHAR2(255),
SEGMENT4 VARCHAR2(255),
SEGMENT5 VARCHAR2(255),
SEGMENT6 VARCHAR2(255),
SEGMENT7 VARCHAR2(255),
SEGMENT8 VARCHAR2(255)
);

COMMENT ON table EBS_BSSHEET_SET IS '资产负债表头表';

comment on column EBS_BSSHEET_SET.BSSHEET_SET_ID is '集ID';
comment on column EBS_BSSHEET_SET.REPORT_ID is '表标识';
comment on column EBS_BSSHEET_SET.REPORT_FLAG is '报表标识';
comment on column EBS_BSSHEET_SET.period_date is '报表期间';
comment on column EBS_BSSHEET_SET.sys_date is '推送日期';
comment on column EBS_BSSHEET_SET.com_code is '报表所在公司';
comment on column EBS_BSSHEET_SET.dept_code is '报表所在部门';
comment on column EBS_BSSHEET_SET.line_count_num is '行记录数';
comment on column EBS_BSSHEET_SET.SEGMENT1 is '扩展字段';
comment on column EBS_BSSHEET_SET.SEGMENT2 is '扩展字段';
comment on column EBS_BSSHEET_SET.SEGMENT3 is '扩展字段';
comment on column EBS_BSSHEET_SET.SEGMENT4 is '扩展字段';
comment on column EBS_BSSHEET_SET.SEGMENT5 is '扩展字段';
comment on column EBS_BSSHEET_SET.SEGMENT6 is '扩展字段';
comment on column EBS_BSSHEET_SET.SEGMENT7 is '扩展字段';
comment on column EBS_BSSHEET_SET.SEGMENT8 is '扩展字段';

create sequence EBS_BSSHEET_SET_S
MINVALUE 1
MAXVALUE 99999999999999999
START WITH 100
INCREMENT BY 1
NOCACHE;

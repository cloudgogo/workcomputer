CREATE TABLE EBS_BSSHEET_LINE(
BSSHEET_LINE_ID NUMBER,
BSSHEET_SET_ID NUMBER,
REPORT_ID VARCHAR2(15),
ITEM_NAME VARCHAR2(100),
LINE_NUM VARCHAR(15),
BEGINNING_BALANCES NUMBER,
ENDING_BALANCES NUMBER,
SEGMENT1 VARCHAR2(255),
SEGMENT2 VARCHAR2(255),
SEGMENT3 VARCHAR2(255),
SEGMENT4 VARCHAR2(255),
SEGMENT5 VARCHAR2(255),
SEGMENT6 VARCHAR2(255),
SEGMENT7 VARCHAR2(255),
SEGMENT8 VARCHAR2(255)
);

COMMENT ON table EBS_BSSHEET_LINE IS '资产负债表行表';

comment on column EBS_BSSHEET_LINE.BSSHEET_LINE_ID is '行id';
comment on column EBS_BSSHEET_LINE.BSSHEET_SET_ID is '头id';
comment on column EBS_BSSHEET_LINE.REPORT_ID is '表标识';
comment on column EBS_BSSHEET_LINE.ITEM_NAME is '表项名称';
comment on column EBS_BSSHEET_LINE.LINE_NUM is '行次';
comment on column EBS_BSSHEET_LINE.BEGINNING_BALANCES is '期初数';
comment on column EBS_BSSHEET_LINE.ENDING_BALANCES is '期末数';
comment on column EBS_BSSHEET_LINE.SEGMENT1 is '扩展字段';
comment on column EBS_BSSHEET_LINE.SEGMENT2 is '扩展字段';
comment on column EBS_BSSHEET_LINE.SEGMENT3 is '扩展字段';
comment on column EBS_BSSHEET_LINE.SEGMENT4 is '扩展字段';
comment on column EBS_BSSHEET_LINE.SEGMENT5 is '扩展字段';
comment on column EBS_BSSHEET_LINE.SEGMENT6 is '扩展字段';
comment on column EBS_BSSHEET_LINE.SEGMENT7 is '扩展字段';
comment on column EBS_BSSHEET_LINE.SEGMENT8 is '扩展字段';

create sequence EBS_BSSHEET_LINE_S
MINVALUE 1
MAXVALUE 99999999999999999
START WITH 100
INCREMENT BY 1
NOCACHE;

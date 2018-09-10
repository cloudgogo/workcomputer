-- Create table
create table BASS_DW.DM_RES_OPERATE_PROPROJECTINFO
( ORG_CLASSIFY          VARCHAR2(36),
  BUID                  VARCHAR2(36),
  BUNAME                VARCHAR2(50),
  AREAID                VARCHAR2(36),
  AREANAME              VARCHAR2(50),
  ORGID                 VARCHAR2(36),
  ORGNAME               VARCHAR2(500),
  PROID                 VARCHAR2(36),
  PRONAME               VARCHAR2(4000),
  COVERAREA             NUMBER,
  ACREAGE               NUMBER,
  AVAILABLEACREAGE      NUMBER,
  TOTALVALUE            NUMBER,
  SURPLUSVALUE          NUMBER,
  BITCHPRICE            NUMBER,
  PLANNINGTIME          date,
  DIFFPLANNINGTIME      number,
  PLANNING_POINTS       number,
  DEALTIME              date,
  STARTTIME             date,
  DIFFSTARTTIME         number,
  DELISTING_PLANNING    number,
  PLANTIME              date,
  DIFFPLANTIME          number,
  DELISTING_PROGRAMME   number,
  DEMONSTRATIONTIME     DATE,
  DIFFDEMONSTRATIONTIME NUMBER,
  DELISTING_EMONSTRATION_PLO NUMBER,
  OPENINGTIME           DATE,
  DIFFOPENINGTIME       NUMBER,
  DELISTING_OPENING     NUMBER,
  CASHFLOWSBACKTIME     DATE,
  DIFFCASHFLOWSBACKTIME NUMBER,
  DELISTING_REFLOW      NUMBER,
  ETL_DATE            DATE
   
)
tablespace MCANALYSIS_01
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64
    next 8
    minextents 1
    maxextents unlimited
  );
-- Add comments to the columns 

comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.ORG_CLASSIFY
  is '区域类型';
comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.BUID
  is '事业部ID';
comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.BUNAME
  is '事业部名称';
comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.AREAID
  is '区域ID';
comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.AREANAME
  is '区域名称';
comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.ORGID
  is '分公司ID';
comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.ORGNAME
  is '分公司名称';
comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.PROID
  is '项目ID';
comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.PRONAME
  is '项目名称';
comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.COVERAREA
  is '占地面积';
comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.ACREAGE
  is '建筑面积';
comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.AVAILABLEACREAGE
  is '剩余可售面积';
comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.TOTALVALUE
  is '总货值';
comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.SURPLUSVALUE
  is '剩余库存';
comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.BITCHPRICE
  is '批次单价';
  comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.PLANNINGTIME
  is '规划要点日期';
  comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.DIFFPLANNINGTIME
  is '规划要点时长(天)';
  comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.PLANNING_POINTS
  is '规划要点标准工期';
  comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.DEALTIME
  is '摘牌日期';
  comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.STARTTIME
  is '土地及桩基进场日期';
  comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.DIFFSTARTTIME
  is '摘牌-土地及桩基进场时长(天)';
  comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.DELISTING_PLANNING
  is '摘牌-土地及桩基进场标准工期';
  comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.PLANTIME
  is '规划方案日期';
  comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.DIFFPLANTIME
  is '摘牌-规划方案时长(天)';
  comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.DELISTING_PROGRAMME
  is '摘牌-规划方案标准工期';
  comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.DEMONSTRATIONTIME
  is '示范区开放日期';
  comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.DIFFDEMONSTRATIONTIME
  is '摘牌-示范区开放时长(天)';
  comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.DELISTING_EMONSTRATION_PLO
  is '摘牌-示范区开放标准工期';
  comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.OPENINGTIME
  is '开盘日期';
  comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.DIFFOPENINGTIME
  is '摘牌-开盘时长(天)';
  comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.DELISTING_OPENING
  is '摘牌-开盘标准工期';
  comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.CASHFLOWSBACKTIME
  is '现金流回正日期';
  comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.DIFFCASHFLOWSBACKTIME
  is '摘牌-现金流回正时长(天)';
  comment on column BASS_DW.DM_RES_OPERATE_PROPROJECTINFO.DELISTING_REFLOW
  is '摘牌-现金流回正标准工期';
 
-- Grant/Revoke object privileges 
-- grant select, insert, update on BASS_DW.DM_RES_OPERATE_PROPROJECTINFO to BASS_DW;





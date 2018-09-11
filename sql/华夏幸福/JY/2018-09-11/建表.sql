-- Create table
create table DM_RES_OPERATE_PROPROJECTINFO
(
  org_classify               VARCHAR2(36),
  buid                       VARCHAR2(36),
  buname                     VARCHAR2(50),
  areaid                     VARCHAR2(36),
  areaname                   VARCHAR2(50),
  orgid                      VARCHAR2(36),
  orgname                    VARCHAR2(500),
  proid                      VARCHAR2(36),
  proname                    VARCHAR2(4000),
	BATCHID               VARCHAR2(36),
  BATCHNAME             VARCHAR2(2000),
	PROGRESS              VARCHAR2(500),
  coverarea                  NUMBER,
  acreage                    NUMBER,
  availableacreage           NUMBER,
  totalvalue                 NUMBER,
  surplusvalue               NUMBER,
  bitchprice                 NUMBER,
  planningtime               DATE,
  diffplanningtime           NUMBER,
  planning_points            NUMBER,
  dealtime                   DATE,
  starttime                  DATE,
  diffstarttime              NUMBER,
  delisting_planning         NUMBER,
  plantime                   DATE,
  diffplantime               NUMBER,
  delisting_programme        NUMBER,
  demonstrationtime          DATE,
  diffdemonstrationtime      NUMBER,
  delisting_emonstration_plo NUMBER,
  openingtime                DATE,
  diffopeningtime            NUMBER,
  delisting_opening          NUMBER,
  cashflowsbacktime          DATE,
  diffcashflowsbacktime      NUMBER,
  delisting_reflow           NUMBER,
	typename                VARCHAR2(500),
  etl_date                   DATE
)
tablespace MCANALYSIS_01
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 16K
    next 8K
    minextents 1
    maxextents unlimited
  );
-- Add comments to the columns 
comment on column DM_RES_OPERATE_PROPROJECTINFO.org_classify
  is '区域类型';
comment on column DM_RES_OPERATE_PROPROJECTINFO.buid
  is '事业部ID';
comment on column DM_RES_OPERATE_PROPROJECTINFO.buname
  is '事业部名称';
comment on column DM_RES_OPERATE_PROPROJECTINFO.areaid
  is '区域ID';
comment on column DM_RES_OPERATE_PROPROJECTINFO.areaname
  is '区域名称';
comment on column DM_RES_OPERATE_PROPROJECTINFO.orgid
  is '分公司ID';
comment on column DM_RES_OPERATE_PROPROJECTINFO.orgname
  is '分公司名称';
comment on column DM_RES_OPERATE_PROPROJECTINFO.proid
  is '项目ID';
comment on column DM_RES_OPERATE_PROPROJECTINFO.proname
  is '项目名称';
comment on column DM_RES_OPERATE_PROPROJECTINFO.BATCHID
  is '批次ID';
comment on column DM_RES_OPERATE_PROPROJECTINFO.BATCHNAME
  is '批次名称';
comment on column DM_RES_OPERATE_PROPROJECTINFO.PROGRESS
  is '进度';
comment on column DM_RES_OPERATE_PROPROJECTINFO.coverarea
  is '占地面积';
comment on column DM_RES_OPERATE_PROPROJECTINFO.acreage
  is '建筑面积';
comment on column DM_RES_OPERATE_PROPROJECTINFO.availableacreage
  is '剩余可售面积';
comment on column DM_RES_OPERATE_PROPROJECTINFO.totalvalue
  is '总货值';
comment on column DM_RES_OPERATE_PROPROJECTINFO.surplusvalue
  is '剩余库存';
comment on column DM_RES_OPERATE_PROPROJECTINFO.bitchprice
  is '批次单价';
comment on column DM_RES_OPERATE_PROPROJECTINFO.planningtime
  is '规划要点日期';
comment on column DM_RES_OPERATE_PROPROJECTINFO.diffplanningtime
  is '规划要点时长(天)';
comment on column DM_RES_OPERATE_PROPROJECTINFO.planning_points
  is '规划要点标准工期';
comment on column DM_RES_OPERATE_PROPROJECTINFO.dealtime
  is '摘牌日期';
comment on column DM_RES_OPERATE_PROPROJECTINFO.starttime
  is '土地及桩基进场日期';
comment on column DM_RES_OPERATE_PROPROJECTINFO.diffstarttime
  is '摘牌-土地及桩基进场时长(天)';
comment on column DM_RES_OPERATE_PROPROJECTINFO.delisting_planning
  is '摘牌-土地及桩基进场标准工期';
comment on column DM_RES_OPERATE_PROPROJECTINFO.plantime
  is '规划方案日期';
comment on column DM_RES_OPERATE_PROPROJECTINFO.diffplantime
  is '摘牌-规划方案时长(天)';
comment on column DM_RES_OPERATE_PROPROJECTINFO.delisting_programme
  is '摘牌-规划方案标准工期';
comment on column DM_RES_OPERATE_PROPROJECTINFO.demonstrationtime
  is '示范区开放日期';
comment on column DM_RES_OPERATE_PROPROJECTINFO.diffdemonstrationtime
  is '摘牌-示范区开放时长(天)';
comment on column DM_RES_OPERATE_PROPROJECTINFO.delisting_emonstration_plo
  is '摘牌-示范区开放标准工期';
comment on column DM_RES_OPERATE_PROPROJECTINFO.openingtime
  is '开盘日期';
comment on column DM_RES_OPERATE_PROPROJECTINFO.diffopeningtime
  is '摘牌-开盘时长(天)';
comment on column DM_RES_OPERATE_PROPROJECTINFO.delisting_opening
  is '摘牌-开盘标准工期';
comment on column DM_RES_OPERATE_PROPROJECTINFO.cashflowsbacktime
  is '现金流回正日期';
comment on column DM_RES_OPERATE_PROPROJECTINFO.diffcashflowsbacktime
  is '摘牌-现金流回正时长(天)';
comment on column DM_RES_OPERATE_PROPROJECTINFO.delisting_reflow
  is '摘牌-现金流回正标准工期';
comment on column DM_RES_OPERATE_PROPROJECTINFO.typename
  is '产品类型';

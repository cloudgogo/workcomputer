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
  is '��������';
comment on column DM_RES_OPERATE_PROPROJECTINFO.buid
  is '��ҵ��ID';
comment on column DM_RES_OPERATE_PROPROJECTINFO.buname
  is '��ҵ������';
comment on column DM_RES_OPERATE_PROPROJECTINFO.areaid
  is '����ID';
comment on column DM_RES_OPERATE_PROPROJECTINFO.areaname
  is '��������';
comment on column DM_RES_OPERATE_PROPROJECTINFO.orgid
  is '�ֹ�˾ID';
comment on column DM_RES_OPERATE_PROPROJECTINFO.orgname
  is '�ֹ�˾����';
comment on column DM_RES_OPERATE_PROPROJECTINFO.proid
  is '��ĿID';
comment on column DM_RES_OPERATE_PROPROJECTINFO.proname
  is '��Ŀ����';
comment on column DM_RES_OPERATE_PROPROJECTINFO.BATCHID
  is '����ID';
comment on column DM_RES_OPERATE_PROPROJECTINFO.BATCHNAME
  is '��������';
comment on column DM_RES_OPERATE_PROPROJECTINFO.PROGRESS
  is '����';
comment on column DM_RES_OPERATE_PROPROJECTINFO.coverarea
  is 'ռ�����';
comment on column DM_RES_OPERATE_PROPROJECTINFO.acreage
  is '�������';
comment on column DM_RES_OPERATE_PROPROJECTINFO.availableacreage
  is 'ʣ��������';
comment on column DM_RES_OPERATE_PROPROJECTINFO.totalvalue
  is '�ܻ�ֵ';
comment on column DM_RES_OPERATE_PROPROJECTINFO.surplusvalue
  is 'ʣ����';
comment on column DM_RES_OPERATE_PROPROJECTINFO.bitchprice
  is '���ε���';
comment on column DM_RES_OPERATE_PROPROJECTINFO.planningtime
  is '�滮Ҫ������';
comment on column DM_RES_OPERATE_PROPROJECTINFO.diffplanningtime
  is '�滮Ҫ��ʱ��(��)';
comment on column DM_RES_OPERATE_PROPROJECTINFO.planning_points
  is '�滮Ҫ���׼����';
comment on column DM_RES_OPERATE_PROPROJECTINFO.dealtime
  is 'ժ������';
comment on column DM_RES_OPERATE_PROPROJECTINFO.starttime
  is '���ؼ�׮����������';
comment on column DM_RES_OPERATE_PROPROJECTINFO.diffstarttime
  is 'ժ��-���ؼ�׮������ʱ��(��)';
comment on column DM_RES_OPERATE_PROPROJECTINFO.delisting_planning
  is 'ժ��-���ؼ�׮��������׼����';
comment on column DM_RES_OPERATE_PROPROJECTINFO.plantime
  is '�滮��������';
comment on column DM_RES_OPERATE_PROPROJECTINFO.diffplantime
  is 'ժ��-�滮����ʱ��(��)';
comment on column DM_RES_OPERATE_PROPROJECTINFO.delisting_programme
  is 'ժ��-�滮������׼����';
comment on column DM_RES_OPERATE_PROPROJECTINFO.demonstrationtime
  is 'ʾ������������';
comment on column DM_RES_OPERATE_PROPROJECTINFO.diffdemonstrationtime
  is 'ժ��-ʾ��������ʱ��(��)';
comment on column DM_RES_OPERATE_PROPROJECTINFO.delisting_emonstration_plo
  is 'ժ��-ʾ�������ű�׼����';
comment on column DM_RES_OPERATE_PROPROJECTINFO.openingtime
  is '��������';
comment on column DM_RES_OPERATE_PROPROJECTINFO.diffopeningtime
  is 'ժ��-����ʱ��(��)';
comment on column DM_RES_OPERATE_PROPROJECTINFO.delisting_opening
  is 'ժ��-���̱�׼����';
comment on column DM_RES_OPERATE_PROPROJECTINFO.cashflowsbacktime
  is '�ֽ�����������';
comment on column DM_RES_OPERATE_PROPROJECTINFO.diffcashflowsbacktime
  is 'ժ��-�ֽ�������ʱ��(��)';
comment on column DM_RES_OPERATE_PROPROJECTINFO.delisting_reflow
  is 'ժ��-�ֽ���������׼����';
comment on column DM_RES_OPERATE_PROPROJECTINFO.typename
  is '��Ʒ����';

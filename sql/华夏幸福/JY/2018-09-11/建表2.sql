-- Create table
create table DM_RES_OPERATE_PROPROJECTINFO
(
  ORG_CLASSIFY               VARCHAR2(36),
  BUID                       VARCHAR2(36),
  BUNAME                     VARCHAR2(50),
  AREAID                     VARCHAR2(36),
  AREANAME                   VARCHAR2(50),
  ORGID                      VARCHAR2(36),
  ORGNAME                    VARCHAR2(500),
  PROID                      VARCHAR2(36),
  PRONAME                    VARCHAR2(4000),
  BATCHID                    VARCHAR2(36),
  BATCHNAME                  VARCHAR2(2000),
  PROGRESS                   VARCHAR2(500),
  COVERAREA                  NUMBER,
  ACREAGE                    NUMBER,
  AVAILABLEACREAGE           NUMBER,
  TOTALVALUE                 NUMBER,
  SURPLUSVALUE               NUMBER,
  BITCHPRICE                 NUMBER,
  PERMITTIME               DATE,
  PLANNINGTIME               DATE,
  DIFFPLANNINGTIME           NUMBER,
  PLANNING_POINTS            NUMBER,
  DEALTIME                   DATE,
  STARTTIME                  DATE,
  DIFFSTARTTIME              NUMBER,
  DELISTING_PLANNING         NUMBER,
  PLANTIME                   DATE,
  DIFFPLANTIME               NUMBER,
  DELISTING_PROGRAMME        NUMBER,
  DEMONSTRATIONTIME          DATE,
  DIFFDEMONSTRATIONTIME      NUMBER,
  DELISTING_EMONSTRATION_PLO NUMBER,
  OPENINGTIME                DATE,
  DIFFOPENINGTIME            NUMBER,
  DELISTING_OPENING          NUMBER,
  CASHFLOWSBACKTIME          DATE,
  DIFFCASHFLOWSBACKTIME      NUMBER,
  DELISTING_REFLOW           NUMBER,
  TYPENAME                   VARCHAR2(500),
  ETL_DATE                   DATE
)
tablespace MCANALYSIS_01
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 16
    next 8
    minextents 1
    maxextents unlimited
  );
-- Add comments to the columns 
comment on column DM_RES_OPERATE_PROPROJECTINFO.ORG_CLASSIFY
  is '��������';
comment on column DM_RES_OPERATE_PROPROJECTINFO.BUID
  is '��ҵ��ID';
comment on column DM_RES_OPERATE_PROPROJECTINFO.BUNAME
  is '��ҵ������';
comment on column DM_RES_OPERATE_PROPROJECTINFO.AREAID
  is '����ID';
comment on column DM_RES_OPERATE_PROPROJECTINFO.AREANAME
  is '��������';
comment on column DM_RES_OPERATE_PROPROJECTINFO.ORGID
  is '�ֹ�˾ID';
comment on column DM_RES_OPERATE_PROPROJECTINFO.ORGNAME
  is '�ֹ�˾����';
comment on column DM_RES_OPERATE_PROPROJECTINFO.PROID
  is '��ĿID';
comment on column DM_RES_OPERATE_PROPROJECTINFO.PRONAME
  is '��Ŀ����';
comment on column DM_RES_OPERATE_PROPROJECTINFO.BATCHID
  is '����ID';
comment on column DM_RES_OPERATE_PROPROJECTINFO.BATCHNAME
  is '��������';
comment on column DM_RES_OPERATE_PROPROJECTINFO.PROGRESS
  is '����';
comment on column DM_RES_OPERATE_PROPROJECTINFO.COVERAREA
  is 'ռ�����';
comment on column DM_RES_OPERATE_PROPROJECTINFO.ACREAGE
  is '�������';
comment on column DM_RES_OPERATE_PROPROJECTINFO.AVAILABLEACREAGE
  is 'ʣ��������';
comment on column DM_RES_OPERATE_PROPROJECTINFO.TOTALVALUE
  is '�ܻ�ֵ';
comment on column DM_RES_OPERATE_PROPROJECTINFO.SURPLUSVALUE
  is 'ʣ����';
comment on column DM_RES_OPERATE_PROPROJECTINFO.BITCHPRICE
  is '���ε���';
comment on column DM_RES_OPERATE_PROPROJECTINFO.PERMITTIME
  is 'Ԥ��ʱ��';
comment on column DM_RES_OPERATE_PROPROJECTINFO.PLANNINGTIME
  is '�滮Ҫ������';
comment on column DM_RES_OPERATE_PROPROJECTINFO.DIFFPLANNINGTIME
  is '�滮Ҫ��ʱ��(��)';
comment on column DM_RES_OPERATE_PROPROJECTINFO.PLANNING_POINTS
  is '�滮Ҫ���׼����';
comment on column DM_RES_OPERATE_PROPROJECTINFO.DEALTIME
  is 'ժ������';
comment on column DM_RES_OPERATE_PROPROJECTINFO.STARTTIME
  is '���ؼ�׮����������';
comment on column DM_RES_OPERATE_PROPROJECTINFO.DIFFSTARTTIME
  is 'ժ��-���ؼ�׮������ʱ��(��)';
comment on column DM_RES_OPERATE_PROPROJECTINFO.DELISTING_PLANNING
  is 'ժ��-���ؼ�׮��������׼����';
comment on column DM_RES_OPERATE_PROPROJECTINFO.PLANTIME
  is '�滮��������';
comment on column DM_RES_OPERATE_PROPROJECTINFO.DIFFPLANTIME
  is 'ժ��-�滮����ʱ��(��)';
comment on column DM_RES_OPERATE_PROPROJECTINFO.DELISTING_PROGRAMME
  is 'ժ��-�滮������׼����';
comment on column DM_RES_OPERATE_PROPROJECTINFO.DEMONSTRATIONTIME
  is 'ʾ������������';
comment on column DM_RES_OPERATE_PROPROJECTINFO.DIFFDEMONSTRATIONTIME
  is 'ժ��-ʾ��������ʱ��(��)';
comment on column DM_RES_OPERATE_PROPROJECTINFO.DELISTING_EMONSTRATION_PLO
  is 'ժ��-ʾ�������ű�׼����';
comment on column DM_RES_OPERATE_PROPROJECTINFO.OPENINGTIME
  is '��������';
comment on column DM_RES_OPERATE_PROPROJECTINFO.DIFFOPENINGTIME
  is 'ժ��-����ʱ��(��)';
comment on column DM_RES_OPERATE_PROPROJECTINFO.DELISTING_OPENING
  is 'ժ��-���̱�׼����';
comment on column DM_RES_OPERATE_PROPROJECTINFO.CASHFLOWSBACKTIME
  is '�ֽ�����������';
comment on column DM_RES_OPERATE_PROPROJECTINFO.DIFFCASHFLOWSBACKTIME
  is 'ժ��-�ֽ�������ʱ��(��)';
comment on column DM_RES_OPERATE_PROPROJECTINFO.DELISTING_REFLOW
  is 'ժ��-�ֽ���������׼����';
comment on column DM_RES_OPERATE_PROPROJECTINFO.TYPENAME
  is '��Ʒ����';

select * from (
select result.*,sum(result.value)over(partition by result.area) sumvalue from (
SELECT     '�̰�'    area ,    '��������'    period,     2.15317403651287     VALUE FROM DUAL union all
SELECT     '����'    area ,    '��������'    period,     1.48053996183178     VALUE FROM DUAL union all
SELECT     '��'    area ,    '��������'    period,     3.36545144377409     VALUE FROM DUAL union all
SELECT     '���'    area ,    '��������'    period,     3.49218908652175     VALUE FROM DUAL union all
SELECT     '��ˮ'    area ,    '��������'    period,     3.39109718398345     VALUE FROM DUAL union all
SELECT     '�ȷ�'    area ,    '��������'    period,     3.24584525401567     VALUE FROM DUAL union all
SELECT     '����'    area ,    '��������'    period,     1.33902693706457     VALUE FROM DUAL union all
SELECT     '֣��'    area ,    '��������'    period,     1.43498066106726     VALUE FROM DUAL union all
SELECT     '����'    area ,    '��������'    period,     3.74900243445266     VALUE FROM DUAL union all
SELECT     '����'    area ,    '��������'    period,     3.06082470561932     VALUE FROM DUAL union all
SELECT     '�̰�'    area ,    '3-6��'       period,     2.31340412898754     VALUE FROM DUAL union all
SELECT     '����'    area ,    '3-6��'       period,     1.53772508368713     VALUE FROM DUAL union all
SELECT     '��'    area ,    '3-6��'       period,     2.22416816827672     VALUE FROM DUAL union all
SELECT     '���'    area ,    '3-6��'       period,     1.17071051187055     VALUE FROM DUAL union all
SELECT     '��ˮ'    area ,    '3-6��'       period,     2.60218803375042     VALUE FROM DUAL union all
SELECT     '�ȷ�'    area ,    '3-6��'       period,     2.93970078300598     VALUE FROM DUAL union all
SELECT     '����'    area ,    '3-6��'       period,     2.56316093442442     VALUE FROM DUAL union all
SELECT     '֣��'    area ,    '3-6��'       period,     1.8080653453019     VALUE FROM DUAL union all
SELECT     '����'    area ,    '3-6��'       period,     1.90354055831773     VALUE FROM DUAL union all
SELECT     '����'    area ,    '3-6��'       period,     2.8955637303441     VALUE FROM DUAL union all
SELECT     '�̰�'    area ,    '6-12��'      period,     1.11378387244262     VALUE FROM DUAL union all
SELECT     '����'    area ,    '6-12��'      period,     3.1272060553192     VALUE FROM DUAL union all
SELECT     '��'    area ,    '6-12��'      period,     1.00230277195033     VALUE FROM DUAL union all
SELECT     '���'    area ,    '6-12��'      period,     1.86973414882983     VALUE FROM DUAL union all
SELECT     '��ˮ'    area ,    '6-12��'      period,     1.79049828976744     VALUE FROM DUAL union all
SELECT     '�ȷ�'    area ,    '6-12��'      period,     3.83510478857909     VALUE FROM DUAL union all
SELECT     '����'    area ,    '6-12��'      period,     1.2275558847835     VALUE FROM DUAL union all
SELECT     '֣��'    area ,    '6-12��'      period,     3.01166182625107     VALUE FROM DUAL union all
SELECT     '����'    area ,    '6-12��'      period,     2.51918356829828     VALUE FROM DUAL union all
SELECT     '����'    area ,    '6-12��'      period,     1.84600313065422     VALUE FROM DUAL union all
SELECT     '�̰�'    area ,    'һ������'    period,     2.74987563550265     VALUE FROM DUAL union all
SELECT     '����'    area ,    'һ������'    period,     2.9267647686415     VALUE FROM DUAL union all
SELECT     '��'    area ,    'һ������'    period,     1.98264145803888     VALUE FROM DUAL union all
SELECT     '���'    area ,    'һ������'    period,     2.56411425553007     VALUE FROM DUAL union all
SELECT     '��ˮ'    area ,    'һ������'    period,     2.36343523496541     VALUE FROM DUAL union all
SELECT     '�ȷ�'    area ,    'һ������'    period,     3.05561671566605     VALUE FROM DUAL union all
SELECT     '����'    area ,    'һ������'    period,     3.84710288335613     VALUE FROM DUAL union all
SELECT     '֣��'    area ,    'һ������'    period,     1.95413154172313     VALUE FROM DUAL union all
SELECT     '����'    area ,    'һ������'    period,     3.54530393618927     VALUE FROM DUAL union all
SELECT     '����'    area ,    'һ������'    period,     2.38171508014326     VALUE FROM DUAL )
result) A order  by sumVALUE DESC

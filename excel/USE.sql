select * from (
select result.*,sum(result.value)over(partition by result.area) sumvalue from (
SELECT     '固安'    area ,    '三月以内'    period,     2.15317403651287     VALUE FROM DUAL union all
SELECT     '嘉善'    area ,    '三月以内'    period,     1.48053996183178     VALUE FROM DUAL union all
SELECT     '大厂'    area ,    '三月以内'    period,     3.36545144377409     VALUE FROM DUAL union all
SELECT     '南浔'    area ,    '三月以内'    period,     3.49218908652175     VALUE FROM DUAL union all
SELECT     '溧水'    area ,    '三月以内'    period,     3.39109718398345     VALUE FROM DUAL union all
SELECT     '廊坊'    area ,    '三月以内'    period,     3.24584525401567     VALUE FROM DUAL union all
SELECT     '霸州'    area ,    '三月以内'    period,     1.33902693706457     VALUE FROM DUAL union all
SELECT     '郑州'    area ,    '三月以内'    period,     1.43498066106726     VALUE FROM DUAL union all
SELECT     '来安'    area ,    '三月以内'    period,     3.74900243445266     VALUE FROM DUAL union all
SELECT     '永清'    area ,    '三月以内'    period,     3.06082470561932     VALUE FROM DUAL union all
SELECT     '固安'    area ,    '3-6月'       period,     2.31340412898754     VALUE FROM DUAL union all
SELECT     '嘉善'    area ,    '3-6月'       period,     1.53772508368713     VALUE FROM DUAL union all
SELECT     '大厂'    area ,    '3-6月'       period,     2.22416816827672     VALUE FROM DUAL union all
SELECT     '南浔'    area ,    '3-6月'       period,     1.17071051187055     VALUE FROM DUAL union all
SELECT     '溧水'    area ,    '3-6月'       period,     2.60218803375042     VALUE FROM DUAL union all
SELECT     '廊坊'    area ,    '3-6月'       period,     2.93970078300598     VALUE FROM DUAL union all
SELECT     '霸州'    area ,    '3-6月'       period,     2.56316093442442     VALUE FROM DUAL union all
SELECT     '郑州'    area ,    '3-6月'       period,     1.8080653453019     VALUE FROM DUAL union all
SELECT     '来安'    area ,    '3-6月'       period,     1.90354055831773     VALUE FROM DUAL union all
SELECT     '永清'    area ,    '3-6月'       period,     2.8955637303441     VALUE FROM DUAL union all
SELECT     '固安'    area ,    '6-12月'      period,     1.11378387244262     VALUE FROM DUAL union all
SELECT     '嘉善'    area ,    '6-12月'      period,     3.1272060553192     VALUE FROM DUAL union all
SELECT     '大厂'    area ,    '6-12月'      period,     1.00230277195033     VALUE FROM DUAL union all
SELECT     '南浔'    area ,    '6-12月'      period,     1.86973414882983     VALUE FROM DUAL union all
SELECT     '溧水'    area ,    '6-12月'      period,     1.79049828976744     VALUE FROM DUAL union all
SELECT     '廊坊'    area ,    '6-12月'      period,     3.83510478857909     VALUE FROM DUAL union all
SELECT     '霸州'    area ,    '6-12月'      period,     1.2275558847835     VALUE FROM DUAL union all
SELECT     '郑州'    area ,    '6-12月'      period,     3.01166182625107     VALUE FROM DUAL union all
SELECT     '来安'    area ,    '6-12月'      period,     2.51918356829828     VALUE FROM DUAL union all
SELECT     '永清'    area ,    '6-12月'      period,     1.84600313065422     VALUE FROM DUAL union all
SELECT     '固安'    area ,    '一年以上'    period,     2.74987563550265     VALUE FROM DUAL union all
SELECT     '嘉善'    area ,    '一年以上'    period,     2.9267647686415     VALUE FROM DUAL union all
SELECT     '大厂'    area ,    '一年以上'    period,     1.98264145803888     VALUE FROM DUAL union all
SELECT     '南浔'    area ,    '一年以上'    period,     2.56411425553007     VALUE FROM DUAL union all
SELECT     '溧水'    area ,    '一年以上'    period,     2.36343523496541     VALUE FROM DUAL union all
SELECT     '廊坊'    area ,    '一年以上'    period,     3.05561671566605     VALUE FROM DUAL union all
SELECT     '霸州'    area ,    '一年以上'    period,     3.84710288335613     VALUE FROM DUAL union all
SELECT     '郑州'    area ,    '一年以上'    period,     1.95413154172313     VALUE FROM DUAL union all
SELECT     '来安'    area ,    '一年以上'    period,     3.54530393618927     VALUE FROM DUAL union all
SELECT     '永清'    area ,    '一年以上'    period,     2.38171508014326     VALUE FROM DUAL )
result) A order  by sumVALUE DESC

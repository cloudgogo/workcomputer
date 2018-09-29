
select '['''||listagg(org_id,''',''') within group(order by order_key)||''']'
  from (SELECT o.org_id,order_key
          FROM DIM_ORG O
         START WITH O.ORG_ID = 'C200FC04-16FC-DFC0-5589-A64C2EA49DE2'
        connect by prior o.father_id = o.org_id
        )

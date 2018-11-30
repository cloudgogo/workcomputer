with
-- 取得用户角色关系
user_role as
 (select u."id"       id,
         u."username" username,
         u."password" password,
         u."realname" realname
    from MCAnalysis.FR_T_USER u, MCAnalysis."FR_T_CustomRole_User" uc
   where u."id" = uc."Userid"),
use_user as
 (select distinct username
    from (select username
            from user_role
          union all
          select u."username" username
            from MCAnalysis.FR_T_USER u, MCAnalysis.FR_T_UEP ut
           where u."id" = ut."userid") a)
select distinct *
  from (select rank() over(partition by u.LOGINNAME order by length(UD.FULLPATHTEXT), J.stockrank desc) a,
               u.LOGINNAME,
               UD.FULLPATHTEXT, --  全组织部门
               J.ORGANIZATIONNAME, --部门
               J.JOBINFONAME, --职务
               A.orgid, --权限
               J.stockrank
          FROM (select a.*
                  from bass_dw.UDMUSER a
                 inner join use_user b
                    on b.username = a.LOGINNAME) U --用户表
          JOIN bass_dw.UDMJOB J --工作信息表
            ON U.ID = J.USERID
          LEFT JOIN bass_dw.DM_HX_DATA_AUT A --数据权限
            ON U.LOGINNAME = A.USERID
          LEFT JOIN bass_dw.UDMORGANIZATION UD --组织信息表 
            ON UD.ID = J.ORGANIZATIONID) t
 where t.a = 1

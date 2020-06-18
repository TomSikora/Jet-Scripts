
declare @devEnvironemnt as nvarchar(64) = 'Jet_Dev_projectRepository'
	, @prodEnvironemnt as nvarchar(64) = 'Jet_projectRepository_Prod'
	, @sql nvarchar(max)

set @sql = ''
set @sql += 'with cte_prod as (
			  SELECT ou.[Name] as [Role Name]
				  , c.[Name] as [Cube Name]
				  , e.[Name] as [Environment Name]
				  , orm.[Member]
				  , cur.UserRight ' +char(13)
set @sql += 'FROM ' + quotename(@prodEnvironemnt) + '.[dbo].[OlapRoleMembers] orm ' + char(13)
set @sql += 'JOIN ' + quotename(@prodEnvironemnt) + '.[dbo].[OlapUsers] ou on ou.OlapUserID = orm.[OlapRoleId] and ou.ValidTo = ''99999999'' ' + char(13)
set @sql += 'JOIN ' + quotename(@prodEnvironemnt) + '.[dbo].[CubeUserRights] cur on ou.[OlapUserId] = cur.[OlapUserId] and cur.ValidTo = ''99999999'' ' + char(13) 
set @sql += 'JOIN ' + quotename(@prodEnvironemnt) + '.[dbo].[Cubes] c on c.[CubeId] = cur.[CubeId] and c.ValidTo  = ''99999999'' ' + char(13) 
set @sql += 'JOIN ' + quotename(@prodEnvironemnt) + '.[dbo].[Environments] e on e.EnvironmentId = orm.[EnvironmentId] ' + char(13) 
set @sql += 'WHERE orm.[ValidTo] = 99999999 ' + char(13) 
set @sql += ')
, cte_dev as (
  SELECT ou.[Name] as [Role Name]
	  ,c.[Name] as [Cube Name]
      ,e.[Name] as [Environment Name]
      ,orm.[Member] 
	  , cur.UserRight ' +char(13)
set @sql += 'FROM ' + quotename(@prodEnvironemnt) + '.[dbo].[OlapRoleMembers] orm ' + char(13)
set @sql += 'JOIN ' + quotename(@prodEnvironemnt) + '.[dbo].[OlapUsers] ou on ou.OlapUserID = orm.[OlapRoleId] and ou.ValidTo = ''99999999'' ' + char(13)
set @sql += 'JOIN ' + quotename(@prodEnvironemnt) + '.[dbo].[CubeUserRights] cur on ou.[OlapUserId] = cur.[OlapUserId] and cur.ValidTo = ''99999999'' ' + char(13) 
set @sql += 'JOIN ' + quotename(@prodEnvironemnt) + '.[dbo].[Cubes] c on c.[CubeId] = cur.[CubeId] and c.ValidTo  = ''99999999'' ' + char(13) 
set @sql += 'JOIN ' + quotename(@devEnvironemnt) + '.[dbo].[Environments] e on e.EnvironmentId = orm.[EnvironmentId] ' + char(13) 
set @sql += 'WHERE orm.[ValidTo] = 99999999 ' + char(13) 
set @sql += ') 

select coalesce(p.[Role Name], d.[Role Name]) as [Role Name]
	, coalesce(p.[Cube Name], d.[Cube Name]) as [Cube Name]
	, coalesce(p.[Member], d.[Member]) as [Member]
	, p.[UserRight] as [Prod]
	, d.[UserRight] as [Dev]
from cte_prod p
full join cte_dev d on p.[Cube Name] = d.[Cube Name] and p.[Role Name] = d.[Role Name] and p.Member = d.Member'

print @sql
exec sp_executesql @sql
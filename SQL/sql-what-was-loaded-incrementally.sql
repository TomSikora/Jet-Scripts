use JetNavDwhProd
go
declare incremental_cur cursor for
select t.name
from sys.tables t
where t.name like '%_I'

declare @tablename as nvarchar(64)
declare @sql as nvarchar(max)

open incremental_cur

fetch next from incremental_cur into @tablename
	while @@FETCH_STATUS = 0
		begin 
			set @sql = ''
			set @sql += 'select ' + char(39) + quotename(replace(@tablename, '_I', '_R')) + char(39)
			set @sql += ', sum(p.rows) from sys.partitions as p '
			set @sql += 'join sys.tables as t on p.[object_id] = t.[object_id] '
			set @sql += 'join sys.schemas as s on t.[schema_id] = s.[schema_id] '
			set @sql += 'where p.index_id IN (0,1)  ' -- heap or clustered index
			set @sql += ' and t.name = N''' +replace(@tablename, '_I', '_R') + ''''
			set @sql += ' and s.name = N''dbo'''

			exec (@sql)

			set @sql = ''
			set @sql += 'select ' + char(39) + quotename(replace(@tablename, '_I', '_V')) + char(39)
			set @sql += ', sum(p.rows) from sys.partitions as p '
			set @sql += 'join sys.tables as t on p.[object_id] = t.[object_id] '
			set @sql += 'join sys.schemas as s on t.[schema_id] = s.[schema_id] '
			set @sql += 'where p.index_id IN (0,1)  ' -- heap or clustered index
			set @sql += ' and t.name = N''' + replace(@tablename, '_I', '_V') + ''''
			set @sql += ' and s.name = N''dbo'''

			exec (@sql)



		fetch next from incremental_cur into @tablename
		end
close incremental_cur
deallocate incremental_cur

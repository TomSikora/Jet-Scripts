use JetNavDwhDev
go

drop table if exists dbo.AListOfTables
go


create table dbo.AListOfTables 
(
	[database name] nvarchar(128) not null,
	[table name] nvarchar(128) not null,
	[row count] bigint not null
)
go

declare @sql as nvarchar(max)
declare @params as nvarchar(max)
declare @db_name as nvarchar(128)
declare @table_name as nvarchar(128)
declare @row_count as bigint

declare table_cur cursor for
select t.name
from sys.tables t 
where t.name like '%_R'

open table_cur

fetch next from table_cur into @table_name
	while @@FETCH_STATUS = 0
		begin

		set @sql = ''
		set @sql += 'select '
		set @sql += '''' + db_name(db_id()) + ''', '
		set @sql += '''' + quotename(@table_name) + ''', '
		set @sql += ' count(*) '
		set @sql += 'from ' + quotename(@table_name) 

		print @sql

		insert into dbo.AListOfTables ([database name], [table name], [row count])
		exec sp_executesql @sql

		fetch next from table_cur into @table_name
	end

close table_cur
deallocate table_cur
		

select * from dbo.AListOfTables

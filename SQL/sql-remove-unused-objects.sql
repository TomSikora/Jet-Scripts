
declare @log_obj_name as nvarchar(64) = 'Budget Fact Table2'
declare @ph_obj_name as nvarchar(64)
declare @sql as nvarchar(max)
declare @debug as bit = 0

set @ph_obj_name = concat('[dbo].', quotename(concat(@log_obj_name, '_F')))
set @sql = ''
set @sql += 'drop function if exists ' + @ph_obj_name
if @debug = 1
	print @sql
else 
	exec sp_executesql @sql

set @ph_obj_name = concat('[dbo].', quotename(concat('usp_', @log_obj_name, '_Clean')))
set @sql = ''
set @sql += 'drop proc if exists ' + @ph_obj_name
if @debug = 1
	print @sql
else 
	exec sp_executesql @sql

set @ph_obj_name = concat('[dbo].', quotename(concat(@log_obj_name, '_T')))
set @sql = ''
set @sql += 'drop view if exists ' + @ph_obj_name
if @debug = 1
	print @sql
else 
	exec sp_executesql @sql

set @ph_obj_name = concat('[dbo].', quotename(concat(@log_obj_name, '_R')))
set @sql = ''
set @sql += 'drop table if exists ' + @ph_obj_name
if @debug = 1
	print @sql
else 
	exec sp_executesql @sql

set @ph_obj_name = concat('[dbo].', quotename(concat(@log_obj_name, '_M')))
set @sql = ''
set @sql += 'drop table if exists ' + @ph_obj_name
if @debug = 1
	print @sql
else 
	exec sp_executesql @sql

set @ph_obj_name = concat('[dbo].', quotename(concat(@log_obj_name, '_L')))
set @sql = ''
set @sql += 'drop table if exists ' + @ph_obj_name
if @debug = 1
	print @sql
else 
	exec sp_executesql @sql

set @ph_obj_name = concat('[dbo].', quotename(@log_obj_name))
set @sql = ''
set @sql += 'drop table if exists ' + @ph_obj_name
if @debug = 1
	print @sql
else 
	exec sp_executesql @sql
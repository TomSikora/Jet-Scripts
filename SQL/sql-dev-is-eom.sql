declare @getdate datetime = '2018-05-09';

with cte_days_calc as (
	select @getdate as [Current Date], eomonth(@getdate) as [Month End Date]
	, (datediff(dd, @getdate, eomonth(@getdate)) + 1)
		-(datediff(wk, @getdate, eomonth(@getdate)) * 2)
		-(case when datename(dw, @getdate) = 'Sunday' then 1 else 0 end)
		-(case when datename(dw, eomonth(@getdate)) = 'Saturday' then 1 else 0 end) as [Days to Month End]
	, (datediff(dd, @getdate, eomonth(@getdate,-1)) + 1)
		-(datediff(wk, @getdate, eomonth(@getdate,-1)) * 2)
		-(case when datename(dw, eomonth(@getdate,-1)) = 'Sunday' then 1 else 0 end)
		-(case when datename(dw, eomonth(@getdate,-1)) = 'Saturday' then 1 else 0 end) as [Days from Month End]
)


select case when [Days to Month End] between 0 and 3 or [Days from Month End] between -5 and -1 then 1 else 0 end as result
from cte_days_calc

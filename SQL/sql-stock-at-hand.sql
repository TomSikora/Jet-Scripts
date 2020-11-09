; with cte as (
select [Entry No], [Item No], [Posting Date]
, sum(Sold) over (partition by [Item No], [Posting Date]) as soldtillnow
, sum(Quantity) over (partition by [Item No] order by [Posting Date] rows between unbounded preceding and current row) as incrkathand
from [JetNavDwh_InsideNAV]..[Inventory Transactions_V]
cross apply(values(case when [Item Ledger Entry Type] = 1 then Quantity end)) as Qty(Sold)
)

 

select distinct [Item No], [Posting Date]
, - last_value(soldtillnow) over (partition by [Item No], [Posting Date] order by [Posting Date]) as QtySold
, last_value(incrkathand) over (partition by [Item No], [Posting Date] order by [Posting Date]) as Qty
into nazwa_tabeli
from cte
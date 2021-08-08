-- look for gaps
select * from (
	select top 100000000 branchId, ticketNumber, ticketNumber - (lag(ticketNumber, 1, 1) over (order by branchid, ticketNumber)) as [GAP]
	from dbo.TicketEntry
	order by branchId, ticketNumber 
) [t]
where [gap] != 1
go

-- rows in the table
select count_big(*) from dbo.TicketEntry (nolock)

-- last ticket number per branch 
select branchId, max(ticketNumber) from dbo.TicketEntry group by branchId

-- tickets per branch
select branchId, count_big(*) from dbo.TicketEntry (nolock) group by branchId order by 2


-- run this code from mulitple sessions
-- in parallel to cause concurrency 
-- and try to force a gap in the sequence

set nocount on 
go
declare @loop int = 0;
declare @rollback int;
declare @branchId int;
declare @ticketNumber int = 0;

while @loop < 100000000 -- one hundred million rows
begin 
	begin tran
	set @branchId = cast( (rand() * 100) as int);
	exec dbo.ticketing @branchID = @branchId, @ticketNumber = @ticketNumber OUTPUT;

	insert into TicketEntry values (@branchId, @ticketNumber, N'Filler ...');

	set @rollback = cast( (RAND() * 10) as int);
	if @rollback < 3
		begin
		rollback;
		end
	else 
		begin
		commit;
		end

	set @loop = @loop + 1
end

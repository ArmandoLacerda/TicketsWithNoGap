declare @loop int = 0;
declare @rollback int;
declare @branchId int;
declare @ticketNumber int = 0;
declare @startDate date;
declare @endDate date;
declare @startTime time;
declare @endTime time;
declare @durationMs int;

while @loop < 100000000
begin 
  set @startDate = cast(getdate() as date);
  set @startTime = cast(getdate() as time);

  begin tran
  set @branchId = cast( (rand() * 100) as int);
  exec dbo.ticketingTable @branchID = @branchId, @ticketNumber = @ticketNumber OUTPUT;

  if @ticketNumber > 0
    begin
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
        exec dbo.addTicketToThePool @branchID = @branchId;
    end
  else
    begin
      rollback
    end

  set @endDate = cast(getdate() as date);
  set @endTime = cast(getdate() as time);
  set @durationMs = DATEDIFF(ms, @startTime, @endTime)
  insert into transactionTiming ([branchId], [ticketNumber], [startDate], [endDate], [startTime], [endTime], [durationMs], [rollback]) values (@branchID, @ticketNumber, @startDate, @endDate, @startTime, @endTime, @durationMs, iif(@ticketNumber = -1, 'X', iif(@rollback < 3, 'Y', 'N')))

  set @loop = @loop + 1
end

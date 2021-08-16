create or alter procedure ticketingTable (@branchId int, @ticketNumber int OUTPUT) 
as
begin
  declare @branchTable nvarchar(100);
  declare @retrieveTicketNumber nvarchar(300);
  declare @parameters nvarchar(300);
  declare @returnedValue int = 0;
  declare @claimTicket nvarchar(300);
  declare @sequenceName nvarchar(100);

  set @sequenceName = N'branchTicketTable_' + cast(@branchId as varchar);
  set @branchTable = N'branchTicketTable_' + cast(@branchId as nvarchar);
  set @retrieveTicketNumber = N'select @availableTicketOut = min([ticketNumber]) from branchTicket.' + @branchTable + N' (tablockx) where used = ''N''';
  set @parameters = N'@availableTicketOut int output';
  set @claimTicket = 'update [branchTicket].[' + @branchTable + N'] set used = ''Y'' where ticketNumber = '; --@availableTicketOut';

  exec sp_executesql @retrieveTicketNumber, @parameters, @availableTicketOut = @returnedValue OUTPUT;
  if @returnedValue is null
  begin
    set @returnedValue = -1;
  end
  else 
  begin
    set @claimTicket = @claimTicket + cast(@returnedValue as nvarchar)
    exec (@claimTicket);
  end

  set @ticketNumber = @returnedValue;
end
go

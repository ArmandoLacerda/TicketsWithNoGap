create or alter procedure addTicketToThePool (@branchId int)
as
begin
  declare @sequenceName nvarchar(100);
  declare @insertNewTicketsStmt nvarchar(300);
  set @sequenceName = N'branchTicketTable_' + cast(@branchId as varchar);
  set @insertNewTicketsStmt =  N'if( (select count(*) from [branchTicket].[' + @sequenceName + N'] where [used] = ''N'') < 1000) begin insert into [branchTicket].[' + @sequenceName + N'] (used) values (''N'') end ;';
  exec (@insertNewTicketsStmt)
end
go

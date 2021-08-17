create or alter procedure cleanUsedTickets
as
begin
  declare @sequenceName nvarchar(100);
  declare @branchId int = 0;
  declare @deleteUsedTicketsStmt nvarchar(300);

  while @branchId < 101
  begin
    set @sequenceName = N'branchTicketTable_' + cast(@branchId as varchar);
    set @deleteUsedTicketsStmt = N'declare @dummy int; select @dummy = count(*) from [branchTicket].[' + @sequenceName + N'] (tablockx); delete from [branchTicket].[' + @sequenceName + N'] where used = ''Y'';';

    begin tran
    exec (@deleteUsedTicketsStmt);
    commit;

    set @branchId = @branchId + 1;
  end
  set @branchId = 0;
end

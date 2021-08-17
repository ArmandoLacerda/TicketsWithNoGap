set nocount on 
go 

declare @counter int = 0;
declare @poolSize int = 1000;
declare @sequenceName nvarchar(100);
declare @branchId int = 0;
declare @dropSeqStmt nvarchar(300);
declare @createSeqStmt nvarchar(300) ;
declare @insertNewTicketsStmt nvarchar(300);

while @branchId < 101
begin
  set @sequenceName = N'branchTicketTable_' + cast(@branchId as varchar);
  set @dropSeqStmt = 'drop table if exists [branchTicket].[' + @sequenceName + N'];';
  set @createSeqStmt = N'CREATE TABLE branchTicket.[' + @sequenceName + N'] (ticketNumber bigint identity(1,1) not null, used nchar(1) not null);';
  set @insertNewTicketsStmt =  N'insert into [branchTicket].[' + @sequenceName + N'] (used) values (''N''); ';

  exec (@dropSeqStmt);
  exec (@createSeqStmt);

  begin tran
  while @counter < @poolSize
  begin
    exec (@insertNewTicketsStmt);
    set @counter = @counter + 1;
  end
  commit

  set @branchId = @branchId + 1;
  set @counter = 0;
end;

create table [dbo].[transactionTiming](
	[branchId] [int] not null,
	[ticketNumber] [int] not null,
	[startDate] [date] not null,
	[endDate] [date] not null,
	[startTime] [time](7) not null,
	[endTime] [time](7) not null,
	[durationMs] [int] not null,
	[rollback] [nchar](1) not null
) on [PRIMARY]


create table [dbo].[TicketEntry](
	[branchId] [int] not null,
	[ticketNumber] [int] not null,
	[filler] [nvarchar](300) null
) on [PRIMARY]


create or alter procedure ticketing (@branchId int, @ticketNumber int OUTPUT) 
as
begin
	declare @sequenceName nvarchar(100);
	set @sequenceName = N'branchSequence_' + cast(@branchId as varchar);

	declare @returnedValue int = 0;
	declare @parameters nvarchar(300) = N'@returnedValueOUT int output';
	declare @createSeqStmt nvarchar(300) = N'CREATE SEQUENCE dbo.' + @sequenceName + N' START WITH 1 INCREMENT BY 1 ;';
	declare @returnTicketNumberStmt nvarchar(300) = N'set @returnedValueOUT = next value for dbo.' + @sequenceName

	if not exists (select * from sys.sequences where [name] = @sequenceName)
	begin
		exec sp_executesql @createSeqStmt;
	end

	exec sp_executesql @returnTicketNumberStmt, @parameters, @returnedValueOUT = @returnedValue OUTPUT;
	set @ticketNumber = @returnedValue;
end

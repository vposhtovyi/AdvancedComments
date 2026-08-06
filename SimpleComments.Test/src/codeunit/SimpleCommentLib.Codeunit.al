codeunit 50130 SimpleCommentLib
{
    Permissions = tabledata "Comment Line" = RI,
        tabledata "Service Zone" = RI;

    var
        LibraryService: codeunit "Library - Service";
        SCTHelper: Codeunit SCTHelper;

    procedure Initialize()
    begin
        //ToDo: Add initialization code if needed
    end;

    procedure CreateServiceZone(var ServiceZone: Record "Service Zone")
    begin
        Clear(ServiceZone);
        this.LibraryService.CreateServiceZone(ServiceZone);
    end;

    procedure CreateServiceZoneCommentLine(ServiceZoneCode: Code[10]; Date: Date; Comment: Text[80])
    var
        CommentLine: Record "Comment Line";
    begin
        this.CreateCommentLine("Comment Line Table Name"::"Service Zone", ServiceZoneCode, Date, Comment, CommentLine);
    end;

    procedure CreateCommentLine(TableName: Enum "Comment Line Table Name"; No: Code[10]; Date: Date; Comment: Text[80]; var CommentLine: Record "Comment Line")
    var
        LineNo: Integer;
    begin
        Clear(CommentLine);
        CommentLine.SetRange("Table Name", TableName);
        CommentLine.SetRange("No.", No);
        LineNo := CommentLine.FindLast() ? CommentLine."Line No." : 0;
        CommentLine.Init();
        CommentLine.Validate("Table Name", TableName);
        CommentLine.Validate("No.", No);
        CommentLine.Validate("Line No.", LineNo + 10000);
        CommentLine.Date := Date;
        CommentLine.Validate(Comment, Comment);
        CommentLine.Insert(true);
    end;

    procedure CopyCommentLines(TableName: Enum "Comment Line Table Name"; SourceNo: Code[10]; TargetNo: Code[10]; Replace: Boolean)
    begin
        this.SCTHelper.CopyCommentLines(TableName, SourceNo, TargetNo, Replace);
    end;
}

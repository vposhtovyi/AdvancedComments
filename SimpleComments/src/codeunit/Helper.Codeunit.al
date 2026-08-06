codeunit 50100 SCTHelper
{
    Permissions =
        tabledata "Comment Line" = RID,
        tabledata User = R;

    var
        EmptyTargetCodeErr: Label 'Target Code is empty. Cannot copy comments.';

    internal procedure GetUserName(UserSecurityId: Guid): Text
    var
        User: Record User;
    begin
        if IsNullGuid(UserSecurityId) then
            exit('');

        User.ReadIsolation(IsolationLevel::ReadCommitted);
        User.SetLoadFields("User Name");
        if User.Get(UserSecurityId) then
            exit(User."User Name");

        exit('');
    end;

    internal procedure CopyServiceZoneCommentDialog(TargetNo: Code[10]): Boolean
    var
        CopyCommentDialog: Page SCTCopyCommentDlg;
        Replace: Boolean;
        SourceNo: Code[10];
    begin
        if TargetNo = '' then
            Error(this.EmptyTargetCodeErr);

        CopyCommentDialog.SetTargetNo(TargetNo);
        if not (CopyCommentDialog.RunModal() = Action::OK) then
            exit(false);

        CopyCommentDialog.GetParameters(SourceNo, Replace);
        this.CopyCommentLines("Comment Line Table Name"::"Service Zone", SourceNo, TargetNo, Replace);
        exit(true);
    end;

    internal procedure CopyCommentLines(TableName: Enum "Comment Line Table Name"; FromNo: Code[20]; ToNo: Code[20]; Replace: Boolean)
    var
        FromCommentLine: Record "Comment Line";
        ToCommentLine: Record "Comment Line";
        LineNo: Integer;
    begin
        if (FromNo = '') or (FromNo = ToNo) then
            exit;

        ToCommentLine.SetRange("Table Name", TableName);
        ToCommentLine.SetRange("No.", ToNo);
        if Replace then begin
            ToCommentLine.DeleteAll(true);
            LineNo := 0;
        end else
            LineNo := ToCommentLine.FindLast() ? ToCommentLine."Line No." : 0;

        FromCommentLine.SetRange("Table Name", TableName);
        FromCommentLine.SetRange("No.", FromNo);
        if not FromCommentLine.FindSet(false) then
            exit;

        repeat
            LineNo += 10000;
            ToCommentLine.Init();
            ToCommentLine := FromCommentLine;
            ToCommentLine.Validate("No.", ToNo);
            ToCommentLine.Validate("Line No.", LineNo);
            ToCommentLine.Insert(true);
        until FromCommentLine.Next() = 0;
    end;
}

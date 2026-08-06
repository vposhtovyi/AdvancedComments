page 50101 SCTCopyCommentDlg
{
    Caption = 'Copy Comments';
    PageType = StandardDialog;

    layout
    {
        area(Content)
        {
            group(Options)
            {
                ShowCaption = false;

                field(FromSourceNo; this.SourceNo)
                {
                    ApplicationArea = Service;
                    Caption = 'From Source';
                    TableRelation = "Service Zone".Code;
                    ToolTip = 'Specifies the source to copy comments from.';

                    //ToDo: Make UNIVERSAL lookup trigger instead of TableRelation
                    trigger OnValidate()
                    begin
                        if this.SourceNo = this.TargetNo then
                            Error(this.SourceTargetSameErr);
                    end;
                }
                field(ReplaceExisting; this.ReplaceExisting)
                {
                    ApplicationArea = Service;
                    Caption = 'Replace Existing Comments';
                    ToolTip = 'Specifies whether to delete existing comments in the target before copying.';
                }
            }
        }
    }

    var
        ReplaceExisting: Boolean;
        SourceNo: Code[10];
        TargetNo: Code[10];
        SelectSourceErr: Label 'Please select a source.';
        SourceTargetSameErr: Label 'Source and target cannot be the same.';

    internal procedure SetTargetNo(NewTargetNo: Code[20])
    begin
        this.TargetNo := CopyStr(NewTargetNo, 1, 10);
    end;

    internal procedure GetParameters(var SourceCode: Code[10]; var Replace: Boolean)
    begin
        SourceCode := this.SourceNo;
        Replace := this.ReplaceExisting;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = Action::OK then begin
            if this.SourceNo = '' then
                Error(this.SelectSourceErr);
            if this.SourceNo = this.TargetNo then
                Error(this.SourceTargetSameErr);
        end;
    end;
}

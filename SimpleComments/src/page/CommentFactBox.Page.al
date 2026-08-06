page 50100 SCTCommentFactBox
{
    ApplicationArea = All;
    AutoSplitKey = true;
    Caption = 'Comments';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Comment Line";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the date of the comment line.';
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies the comment line.';
                }
                field(ModifiedBy; this.SCTHelper.GetUserName(Rec.SystemModifiedBy))
                {
                    Caption = 'Modified By';
                    ToolTip = 'Specifies the user who last modified the comment line.';
                }
                field(ModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'Modified At';
                    ToolTip = 'Specifies the date and time when the comment line was last modified.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(SCTCopyComments)
            {
                ApplicationArea = Comments;
                Caption = 'Copy Comments';
                Image = CopyWorksheet;
                ToolTip = 'Copy comments from the record.';

                trigger OnAction()
                begin
                    if this.SCTHelper.CopyServiceZoneCommentDialog(CopyStr(Rec."No.", 1, 10)) then
                        CurrPage.Update(false);
                end;
            }
            action(SCTViewComments)
            {
                ApplicationArea = Comments;
                Caption = 'Comments';
                Image = ViewComments;
                RunObject = page "Comment Sheet";
                RunPageLink = "Table Name" = const("Service Zone"), "No." = field("No.");
                ToolTip = 'View or add comments for the record.';
            }
        }
    }

    var
        SCTHelper: Codeunit SCTHelper;
}

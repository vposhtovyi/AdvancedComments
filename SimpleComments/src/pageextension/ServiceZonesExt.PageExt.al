pageextension 50101 SCTServiceZonesExt extends "Service Zones"
{
    layout
    {
        addfirst(factboxes)
        {
            part(SCTCommentFactBox; SCTCommentFactBox)
            {
                ApplicationArea = Service;
                Caption = 'Comments';
                SubPageLink = "Table Name" = const("Service Zone"), "No." = field("Code");
            }
        }
    }
    actions
    {
        addlast(Promoted)
        {
            actionref(CTSComments_Promoted; SCTViewComments) { }
        }
        addlast(Processing)
        {
            group(SCTCommentsGroup)
            {
                Caption = 'Comments';
                Image = ViewComments;

                action(SCTCopyComments)
                {
                    ApplicationArea = Comments;
                    Caption = 'Copy Comments';
                    Image = CopyWorksheet;
                    ToolTip = 'Copy comments from the record.';

                    trigger OnAction()
                    begin
                        if SCTHelper.CopyServiceZoneCommentDialog(Rec.Code) then
                            CurrPage.SCTCommentFactBox.Page.Update(false);
                    end;
                }
            }
            action(SCTViewComments)
            {
                ApplicationArea = Comments;
                Caption = 'Comments';
                Image = ViewComments;
                RunObject = page "Comment Sheet";
                RunPageLink = "Table Name" = const("Service Zone"), "No." = field("Code");
                ToolTip = 'View or add comments for the record.';
            }
        }
    }
    var
        SCTHelper: Codeunit SCTHelper;
}

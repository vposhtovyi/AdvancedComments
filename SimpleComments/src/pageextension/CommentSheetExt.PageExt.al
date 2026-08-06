pageextension 50100 SCTCommentSheetExt extends "Comment Sheet"
{
    layout
    {
        addlast(Control1)
        {
            field(SCTADCModifiedBy; SCTHelper.GetUserName(Rec.SystemModifiedBy))
            {
                ApplicationArea = All;
                Caption = 'Modified By';
                Editable = false;
                ToolTip = 'Specifies the user who last modified the comment line.';
            }
            field(SCTADCModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
                Caption = 'Modified At';
                Editable = false;
                ToolTip = 'Specifies the date and time when the comment line was last modified.';
            }
        }
    }

    var
        SCTHelper: Codeunit SCTHelper;
}

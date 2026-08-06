permissionset 50100 SCTSimpleComment
{
    Assignable = true;
    Caption = 'Simple Comment', MaxLength = 30;
    Permissions = codeunit SCTHelper = X,
        page SCTCommentFactBox = X,
        page SCTCopyCommentDlg = X,
        table "Comment Line" = X,
        table User = X,
        tabledata "Comment Line" = rimd,
        tabledata User = R;
}
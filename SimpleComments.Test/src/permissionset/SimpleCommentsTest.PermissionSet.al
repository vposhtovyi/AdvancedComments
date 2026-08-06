permissionset 50130 SimpleCommentsTest
{
    Access = Internal;
    Assignable = true;
    Caption = 'Simple Comments Test', MaxLength = 30, Locked = true;
    Permissions =
         codeunit SimpleCommentTest = X,
         codeunit SimpleCommentLib = X;
}
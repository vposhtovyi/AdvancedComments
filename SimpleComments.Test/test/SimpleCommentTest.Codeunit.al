codeunit 50131 SimpleCommentTest
{
    Subtype = Test;

    var
        SCTLib: Codeunit SimpleCommentLib;
        LibRandom: Codeunit "Library - Random";
        LibAssert: Codeunit "Library Assert";
        LibStorage: Codeunit "Library - Variable Storage";
        IsInitialized: Boolean;

    trigger OnRun()
    begin
        // [FEATURE] Simple Comments
    end;

    local procedure Initialize()
    begin
        if this.IsInitialized then
            exit;

        this.SCTLib.Initialize();
        this.SetTestPermissions();
        Commit();
        this.IsInitialized := true;
    end;

    local procedure SetTestPermissions();
    var
        LibraryLowerPermissions: Codeunit "Library - Lower Permissions";
    begin
        LibraryLowerPermissions.AddO365BusinessPremium();
        LibraryLowerPermissions.AddO365Full();
        LibraryLowerPermissions.AddPermissionSet('SUPER');
    end;

    [Test]
    procedure T1001_CopyServiceZoneCommentsWithReplaceWithoutPage()
    var
        ServiceZone: array[2] of Record "Service Zone";
        Comment: array[3] of Text[80];
    begin
        // [USER STORY] Service Zone Comments
        // [SCENARIO #1001] Copy Service Zone Comments with Replace without Page
        this.Initialize();
        //[GIVEN] Service Zone exists with code 'SZ-01'
        this.SCTLib.CreateServiceZone(ServiceZone[1]);
        //[GIVEN] Service Zone exists with code 'SZ-02'
        this.SCTLib.CreateServiceZone(ServiceZone[2]);
        //[GIVEN] Comment Line exists with Service Zone 'SZ-01', Date = CurrentDate, Comment = 'CZ1 Comment 1'
        Comment[1] := StrSubstNo('%1 %2', ServiceZone[1].Code, Format(this.LibRandom.RandText(10)));
        this.SCTLib.CreateServiceZoneCommentLine(ServiceZone[1].Code, CurrentDateTime().Date(), Comment[1]);
        //[GIVEN] Comment Line exists with Service Zone 'SZ-01', Date = CurrentDate, Comment = 'CZ1 Comment 2'
        Comment[2] := StrSubstNo('%1 %2', ServiceZone[1].Code, Format(this.LibRandom.RandText(10)));
        this.SCTLib.CreateServiceZoneCommentLine(ServiceZone[1].Code, CurrentDateTime().Date(), Comment[2]);
        //[GIVEN] Comment Line exists with Service Zone 'SZ-01', Date = CurrentDate, Comment = 'CZ1 Comment 3'
        Comment[3] := StrSubstNo('%1 %2', ServiceZone[1].Code, Format(this.LibRandom.RandText(10)));
        this.SCTLib.CreateServiceZoneCommentLine(ServiceZone[1].Code, CurrentDateTime().Date(), Comment[3]);
        //[WHEN] Copy Comment Lines from Service Zone 'SZ-01' to 'SZ-02' with Replace = true
        this.SCTLib.CopyCommentLines("Comment Line Table Name"::"Service Zone", ServiceZone[1].Code, ServiceZone[2].Code, true);
        //[THEN] Comment Line exist with Service Zone 'SZ-02', Date = CurrentDate, Comment = 'CZ1 Comment 1'
        this.VerifyServiceZoneCommentLineExists(ServiceZone[2].Code, CurrentDateTime().Date(), Comment[1]);
        //[THEN] Comment Line exist with Service Zone 'SZ-02', Date = CurrentDate, Comment = 'CZ1 Comment 2'
        this.VerifyServiceZoneCommentLineExists(ServiceZone[2].Code, CurrentDateTime().Date(), Comment[2]);
        //[THEN] Comment Line exist with Service Zone 'SZ-02', Date = CurrentDate, Comment = 'CZ1 Comment 3'
        this.VerifyServiceZoneCommentLineExists(ServiceZone[2].Code, CurrentDateTime().Date(), Comment[3]);
    end;

    [Test]
    procedure T1002_CopyServiceZoneCommentsWithoutReplaceWithoutPage()
    var
        ServiceZone: array[2] of Record "Service Zone";
        Comment: array[4] of Text[80];
    begin
        // [USER STORY] Service Zone Comments
        // [SCENARIO #1002] Copy Service Zone Comments without Replace without Page
        this.Initialize();
        //[GIVEN] Service Zone exists with code 'SZ-01'
        this.SCTLib.CreateServiceZone(ServiceZone[1]);
        //[GIVEN] Service Zone exists with code 'SZ-02'
        this.SCTLib.CreateServiceZone(ServiceZone[2]);
        //[GIVEN] Comment Line exists with Service Zone 'SZ-01', Date = CurrentDate, Comment = 'CZ1 Comment 1'
        Comment[1] := StrSubstNo('%1 %2', ServiceZone[1].Code, Format(this.LibRandom.RandText(10)));
        this.SCTLib.CreateServiceZoneCommentLine(ServiceZone[1].Code, CurrentDateTime().Date(), Comment[1]);
        //[GIVEN] Comment Line exists with Service Zone 'SZ-01', Date = CurrentDate, Comment = 'CZ1 Comment 2'
        Comment[2] := StrSubstNo('%1 %2', ServiceZone[1].Code, Format(this.LibRandom.RandText(10)));
        this.SCTLib.CreateServiceZoneCommentLine(ServiceZone[1].Code, CurrentDateTime().Date(), Comment[2]);
        //[GIVEN] Comment Line exists with Service Zone 'SZ-01', Date = CurrentDate, Comment = 'CZ1 Comment 3'
        Comment[3] := StrSubstNo('%1 %2', ServiceZone[1].Code, Format(this.LibRandom.RandText(10)));
        this.SCTLib.CreateServiceZoneCommentLine(ServiceZone[1].Code, CurrentDateTime().Date(), Comment[3]);
        //[GIVEN] Comment Line exists with Service Zone 'SZ-02', Date = CurrentDate, Comment = 'CZ2 Comment 4'
        Comment[4] := StrSubstNo('%1 %2', ServiceZone[2].Code, Format(this.LibRandom.RandText(10)));
        this.SCTLib.CreateServiceZoneCommentLine(ServiceZone[2].Code, CurrentDateTime().Date(), Comment[4]);
        //[WHEN] Copy Comment Lines from Service Zone 'SZ-01' to 'SZ-02' with Replace = false
        this.SCTLib.CopyCommentLines("Comment Line Table Name"::"Service Zone", ServiceZone[1].Code, ServiceZone[2].Code, false);
        //[THEN] Comment Line exist with Service Zone 'SZ-02', Date = CurrentDate, Comment = 'CZ1 Comment 1'
        this.VerifyServiceZoneCommentLineExists(ServiceZone[2].Code, CurrentDateTime().Date(), Comment[1]);
        //[THEN] Comment Line exist with Service Zone 'SZ-02', Date = CurrentDate, Comment = 'CZ1 Comment 2'
        this.VerifyServiceZoneCommentLineExists(ServiceZone[2].Code, CurrentDateTime().Date(), Comment[2]);
        //[THEN] Comment Line exist with Service Zone 'SZ-02', Date = CurrentDate, Comment = 'CZ1 Comment 3'
        this.VerifyServiceZoneCommentLineExists(ServiceZone[2].Code, CurrentDateTime().Date(), Comment[3]);
        //[THEN] Comment Line exist with Service Zone 'SZ-02', Date = CurrentDate, Comment = 'CZ2 Comment 4'
        this.VerifyServiceZoneCommentLineExists(ServiceZone[2].Code, CurrentDateTime().Date(), Comment[4]);
    end;

    [Test]
    // Run ONLY in "AL Test Runner", because it uses TestPage and TestPart objects
    procedure T1003_ServiceZoneCommentsFactBoxVisible()
    var
        ServiceZone: array[2] of Record "Service Zone";
        ServiceZones: TestPage "Service Zones";
        Comment: array[4] of Text[80];
    begin
        // [USER STORY] Service Zone Comments
        // [SCENARIO #1003] Service Zone Comments FactBox Visible
        this.Initialize();
        //[GIVEN] Service Zone exists with code 'SZ-01'
        this.SCTLib.CreateServiceZone(ServiceZone[1]);
        //[GIVEN] Comment Line exists with Service Zone 'SZ-01', Date = CurrentDate, Comment = 'CZ1 Comment 1'
        Comment[1] := StrSubstNo('%1 %2', ServiceZone[1].Code, Format(this.LibRandom.RandText(10)));
        this.SCTLib.CreateServiceZoneCommentLine(ServiceZone[1].Code, CurrentDateTime().Date(), Comment[1]);
        //[GIVEN] Comment Line exists with Service Zone 'SZ-01', Date = CurrentDate, Comment = 'CZ1 Comment 2'
        Comment[2] := StrSubstNo('%1 %2', ServiceZone[1].Code, Format(this.LibRandom.RandText(10)));
        this.SCTLib.CreateServiceZoneCommentLine(ServiceZone[1].Code, CurrentDateTime().Date(), Comment[2]);
        //[GIVEN] Comment Line exists with Service Zone 'SZ-01', Date = CurrentDate, Comment = 'CZ1 Comment 3'
        Comment[3] := StrSubstNo('%1 %2', ServiceZone[1].Code, Format(this.LibRandom.RandText(10)));
        this.SCTLib.CreateServiceZoneCommentLine(ServiceZone[1].Code, CurrentDateTime().Date(), Comment[3]);
        // [WHEN] Open Service Zone page 'SZ-01' and click on Comments action
        ServiceZones.OpenView();
        ServiceZones.GoToRecord(ServiceZone[1]);
        // [THEN] Comment FactBox is visible
        this.LibAssert.IsTrue(ServiceZones.SCTCommentFactBox.Visible(), '');
        // [THEN] Comment FactBox contains 1 line with Comment = 'CZ1 Comment 1'
        ServiceZones.SCTCommentFactBox.First();
        this.LibAssert.AreEqual(ServiceZones.SCTCommentFactBox.Comment.Value(), Comment[1], '');
        // [THEN] Comment FactBox contains 2 line with Comment = 'CZ1 Comment 2'
        ServiceZones.SCTCommentFactBox.Next();
        this.LibAssert.AreEqual(ServiceZones.SCTCommentFactBox.Comment.Value(), Comment[2], '');
        // [THEN] Comment FactBox contains 3 line with Comment = 'CZ1 Comment 3'
        ServiceZones.SCTCommentFactBox.Next();
        this.LibAssert.AreEqual(ServiceZones.SCTCommentFactBox.Comment.Value(), Comment[3], '');
    end;

    [Test]
    procedure T1004_ServiceZoneCommentsPageExists()
    var
        ServiceZone: array[2] of Record "Service Zone";
        CommentSheet: TestPage "Comment Sheet";
        ServiceZones: TestPage "Service Zones";
        Comment: array[4] of Text[80];
    begin
        // [USER STORY] Service Zone Comments
        // [SCENARIO #1004] Service Zone Comments Page Exists
        this.Initialize();
        //[GIVEN] Service Zone exists with code 'SZ-01'
        this.SCTLib.CreateServiceZone(ServiceZone[1]);
        //[GIVEN] Comment Line exists with Service Zone 'SZ-01', Date = CurrentDate, Comment = 'CZ1 Comment 1'
        Comment[1] := StrSubstNo('%1 %2', ServiceZone[1].Code, Format(this.LibRandom.RandText(10)));
        this.SCTLib.CreateServiceZoneCommentLine(ServiceZone[1].Code, CurrentDateTime().Date(), Comment[1]);
        //[GIVEN] Comment Line exists with Service Zone 'SZ-01', Date = CurrentDate, Comment = 'CZ1 Comment 2'
        Comment[2] := StrSubstNo('%1 %2', ServiceZone[1].Code, Format(this.LibRandom.RandText(10)));
        this.SCTLib.CreateServiceZoneCommentLine(ServiceZone[1].Code, CurrentDateTime().Date(), Comment[2]);
        //[GIVEN] Comment Line exists with Service Zone 'SZ-01', Date = CurrentDate, Comment = 'CZ1 Comment 3'
        Comment[3] := StrSubstNo('%1 %2', ServiceZone[1].Code, Format(this.LibRandom.RandText(10)));
        this.SCTLib.CreateServiceZoneCommentLine(ServiceZone[1].Code, CurrentDateTime().Date(), Comment[3]);
        // [WHEN] Open Service Zone page 'SZ-01' and click on Comments action
        ServiceZones.OpenView();
        ServiceZones.GoToRecord(ServiceZone[1]);
        CommentSheet.Trap();
        ServiceZones.SCTViewComments.Invoke();
        // [THEN] Comment Sheet page is opened and editable
        CommentSheet.First();
        this.LibAssert.IsTrue(CommentSheet.Editable(), '');
    end;

    [Test]
    // Run ONLY in "AL Test Runner", because it uses ModalPageHandler
    [HandlerFunctions('ModalCopyCommentDlgHandler')]
    procedure T1005_CopyServiceZoneCommentsWithReplaceUsingCopyCommentDlg()
    var
        ServiceZone: array[2] of Record "Service Zone";
        ServiceZones: TestPage "Service Zones";
        Comment: array[3] of Text[80];
    begin
        // [USER STORY] Service Zone Comments
        // [SCENARIO #1005] Copy Service Zone Comments with Replace using CopyCommentDlg
        this.Initialize();
        //[GIVEN] Service Zone exists with code 'SZ-01'
        this.SCTLib.CreateServiceZone(ServiceZone[1]);
        //[GIVEN] Service Zone exists with code 'SZ-02'
        this.SCTLib.CreateServiceZone(ServiceZone[2]);
        //[GIVEN] Comment Line exists with Service Zone 'SZ-01', Date = CurrentDate, Comment = 'CZ1 Comment 1'
        Comment[1] := StrSubstNo('%1 %2', ServiceZone[1].Code, Format(this.LibRandom.RandText(10)));
        this.SCTLib.CreateServiceZoneCommentLine(ServiceZone[1].Code, CurrentDateTime().Date(), Comment[1]);
        //[GIVEN] Comment Line exists with Service Zone 'SZ-01', Date = CurrentDate, Comment = 'CZ1 Comment 2'
        Comment[2] := StrSubstNo('%1 %2', ServiceZone[1].Code, Format(this.LibRandom.RandText(10)));
        this.SCTLib.CreateServiceZoneCommentLine(ServiceZone[1].Code, CurrentDateTime().Date(), Comment[2]);
        //[GIVEN] Comment Line exists with Service Zone 'SZ-01', Date = CurrentDate, Comment = 'CZ1 Comment 3'
        Comment[3] := StrSubstNo('%1 %2', ServiceZone[1].Code, Format(this.LibRandom.RandText(10)));
        this.SCTLib.CreateServiceZoneCommentLine(ServiceZone[1].Code, CurrentDateTime().Date(), Comment[3]);
        //[WHEN] Copy Comment Lines from Service Zone 'SZ-01' to 'SZ-02' with Replace = true
        this.LibStorage.Clear();
        this.LibStorage.Enqueue(ServiceZone[1].Code);
        this.LibStorage.Enqueue(true);
        ServiceZones.OpenView();
        ServiceZones.GoToRecord(ServiceZone[2]);
        ServiceZones.SCTCopyComments.Invoke();
        //[THEN] Comment Line exist with Service Zone 'SZ-02', Date = CurrentDate, Comment = 'CZ1 Comment 1'
        this.VerifyServiceZoneCommentLineExists(ServiceZone[2].Code, CurrentDateTime().Date(), Comment[1]);
        //[THEN] Comment Line exist with Service Zone 'SZ-02', Date = CurrentDate, Comment = 'CZ1 Comment 2'
        this.VerifyServiceZoneCommentLineExists(ServiceZone[2].Code, CurrentDateTime().Date(), Comment[2]);
        //[THEN] Comment Line exist with Service Zone 'SZ-02', Date = CurrentDate, Comment = 'CZ1 Comment 3'
        this.VerifyServiceZoneCommentLineExists(ServiceZone[2].Code, CurrentDateTime().Date(), Comment[3]);
    end;

    [Test]
    // Run ONLY in "AL Test Runner", because it uses ModalPageHandler
    [HandlerFunctions('ModalCopyCommentDlgHandler')]
    procedure T1006_CopyServiceZoneCommentsWithoutReplaceUsingCopyCommentDlg()
    var
        ServiceZone: array[2] of Record "Service Zone";
        ServiceZones: TestPage "Service Zones";
        Comment: array[4] of Text[80];
    begin
        // [USER STORY] Service Zone Comments
        // [SCENARIO #1006] Copy Service Zone Comments without Replace using CopyCommentDlg
        this.Initialize();
        //[GIVEN] Service Zone exists with code 'SZ-01'
        this.SCTLib.CreateServiceZone(ServiceZone[1]);
        //[GIVEN] Service Zone exists with code 'SZ-02'
        this.SCTLib.CreateServiceZone(ServiceZone[2]);
        //[GIVEN] Comment Line exists with Service Zone 'SZ-01', Date = CurrentDate, Comment = 'CZ1 Comment 1'
        Comment[1] := StrSubstNo('%1 %2', ServiceZone[1].Code, Format(this.LibRandom.RandText(10)));
        this.SCTLib.CreateServiceZoneCommentLine(ServiceZone[1].Code, CurrentDateTime().Date(), Comment[1]);
        //[GIVEN] Comment Line exists with Service Zone 'SZ-01', Date = CurrentDate, Comment = 'CZ1 Comment 2'
        Comment[2] := StrSubstNo('%1 %2', ServiceZone[1].Code, Format(this.LibRandom.RandText(10)));
        this.SCTLib.CreateServiceZoneCommentLine(ServiceZone[1].Code, CurrentDateTime().Date(), Comment[2]);
        //[GIVEN] Comment Line exists with Service Zone 'SZ-01', Date = CurrentDate, Comment = 'CZ1 Comment 3'
        Comment[3] := StrSubstNo('%1 %2', ServiceZone[1].Code, Format(this.LibRandom.RandText(10)));
        this.SCTLib.CreateServiceZoneCommentLine(ServiceZone[1].Code, CurrentDateTime().Date(), Comment[3]);
        //[GIVEN] Comment Line exists with Service Zone 'SZ-02', Date = CurrentDate, Comment = 'CZ2 Comment 4'
        Comment[4] := StrSubstNo('%1 %2', ServiceZone[2].Code, Format(this.LibRandom.RandText(10)));
        this.SCTLib.CreateServiceZoneCommentLine(ServiceZone[2].Code, CurrentDateTime().Date(), Comment[4]);
        //[WHEN] Copy Comment Lines from Service Zone 'SZ-01' to 'SZ-02' with Replace = false
        this.LibStorage.Clear();
        this.LibStorage.Enqueue(ServiceZone[1].Code);
        this.LibStorage.Enqueue(false);
        ServiceZones.OpenView();
        ServiceZones.GoToRecord(ServiceZone[2]);
        ServiceZones.SCTCopyComments.Invoke();
        //[THEN] Comment Line exist with Service Zone 'SZ-02', Date = CurrentDate, Comment = 'CZ1 Comment 1'
        this.VerifyServiceZoneCommentLineExists(ServiceZone[2].Code, CurrentDateTime().Date(), Comment[1]);
        //[THEN] Comment Line exist with Service Zone 'SZ-02', Date = CurrentDate, Comment = 'CZ1 Comment 2'
        this.VerifyServiceZoneCommentLineExists(ServiceZone[2].Code, CurrentDateTime().Date(), Comment[2]);
        //[THEN] Comment Line exist with Service Zone 'SZ-02', Date = CurrentDate, Comment = 'CZ1 Comment 3'
        this.VerifyServiceZoneCommentLineExists(ServiceZone[2].Code, CurrentDateTime().Date(), Comment[3]);
        //[THEN] Comment Line exist with Service Zone 'SZ-02', Date = CurrentDate, Comment = 'CZ2 Comment 4'
        this.VerifyServiceZoneCommentLineExists(ServiceZone[2].Code, CurrentDateTime().Date(), Comment[4]);
    end;

    [ModalPageHandler]
    procedure ModalCopyCommentDlgHandler(var SCTCopyCommentDlg: TestPage SCTCopyCommentDlg)
    begin
        SCTCopyCommentDlg.FromSourceNo.SetValue(this.LibStorage.DequeueText());
        SCTCopyCommentDlg.ReplaceExisting.SetValue(this.LibStorage.DequeueBoolean());
        SCTCopyCommentDlg.OK().Invoke();
    end;

    local procedure VerifyServiceZoneCommentLineExists(No: Code[10]; Date: Date; Comment: Text[80])
    var
        CommentLine: Record "Comment Line";
    begin
        CommentLine.SetRange("Table Name", "Comment Line Table Name"::"Service Zone");
        CommentLine.SetRange("No.", No);
        CommentLine.SetRange("Date", Date);
        CommentLine.SetRange(Comment, Comment);
        this.LibAssert.RecordIsNotEmpty(CommentLine);
    end;
}

{ Resolve runtime paths from the one loaded script project with this name. }
function AstraWorkspacePath(ProjectName, RelativePath : String) : String;
var
    Workspace : IWorkspace;
    Project : IProject;
    Index, Matches : Integer;
    ScriptDirectory, WorkspaceDirectory : String;
begin
    Workspace := GetWorkspace;
    if Workspace = nil then
        Raise('No Altium workspace is available.');
    Matches := 0;
    for Index := 0 to Workspace.DM_ProjectCount - 1 do
    begin
        Project := Workspace.DM_Projects(Index);
        if UpperCase(ExtractFileName(Project.DM_ProjectFullPath)) = UpperCase(ProjectName) then
        begin
            Matches := Matches + 1;
            ScriptDirectory := ExtractFilePath(Project.DM_ProjectFullPath);
            ScriptDirectory := Copy(ScriptDirectory, 1, Length(ScriptDirectory) - 1);
            WorkspaceDirectory := ExtractFilePath(ScriptDirectory);
        end;
    end;
    if Matches <> 1 then
        Raise('Open exactly one ' + ProjectName + ' from this checkout.');
    Result := WorkspaceDirectory + RelativePath;
end;

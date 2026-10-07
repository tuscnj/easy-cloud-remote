; Inno Setup Script for Easy Cloud Remote
#define MyAppName "Easy Cloud Remote"
#define MyAppVersion "1.5.0"
#define MyAppPublisher "Easy Cloud ERP"
#define MyAppURL "https://easyclouderp.com"
#define MyAppExeName "EasyCloudRemote.exe"
#define MyAppSourceDir "C:\Users\tuscn\easy-cloud-remote\dist_win"

[Setup]
AppId={{5B2A6B29-41BE-48A6-8805-4ACBF947265A}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}/remote
AppUpdatesURL={#MyAppURL}/remote
DefaultDirName={autopf}\EasyCloudRemote
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
LicenseFile=
OutputDir=C:\Users\tuscn\easy-cloud-remote\dist_setup
OutputBaseFilename=EasyCloudRemote-Setup
SetupIconFile=C:\Users\tuscn\easy-cloud-remote\res\icon.ico
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=admin
UninstallDisplayIcon={app}\{#MyAppExeName}
VersionInfoVersion={#MyAppVersion}
VersionInfoCompany={#MyAppPublisher}
VersionInfoDescription=Easy Cloud Remote Desktop
VersionInfoCopyright=Copyright (C) 2026 {#MyAppPublisher}
VersionInfoProductName={#MyAppName}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "{#MyAppSourceDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Registry]
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\Uninstall\{#SetupSetting("AppId")}_is1"; ValueType: string; ValueName: "Host"; ValueData: "165.99.219.50"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\Uninstall\{#SetupSetting("AppId")}_is1"; ValueType: string; ValueName: "Relay"; ValueData: "165.99.219.50"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\Uninstall\{#SetupSetting("AppId")}_is1"; ValueType: string; ValueName: "Key"; ValueData: "RWfX3htUy3jt6eVQHEJgBJ5WbTMcJdP5GyvWB4buNZ8="; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\EasyCloudRemote\InstallState\EasyCloudRemote"; ValueType: string; ValueName: "Host"; ValueData: "165.99.219.50"; Flags: uninsdeletekeyifempty
Root: HKLM; Subkey: "Software\EasyCloudRemote\InstallState\EasyCloudRemote"; ValueType: string; ValueName: "Relay"; ValueData: "165.99.219.50"; Flags: uninsdeletekeyifempty
Root: HKLM; Subkey: "Software\EasyCloudRemote\InstallState\EasyCloudRemote"; ValueType: string; ValueName: "Key"; ValueData: "RWfX3htUy3jt6eVQHEJgBJ5WbTMcJdP5GyvWB4buNZ8="; Flags: uninsdeletekeyifempty

[Code]
procedure WriteConfigToFile(FilePath: String);
var
  ConfigContent: String;
begin
  ConfigContent := 
    'rendezvous_server = ''165.99.219.50:21116''' + #13#10 +
    'nat_type = 1' + #13#10 +
    'serial = 0' + #13#10 +
    '' + #13#10 +
    '[options]' + #13#10 +
    'custom-rendezvous-server = ''165.99.219.50''' + #13#10 +
    'relay-server = ''165.99.219.50''' + #13#10 +
    'key = ''RWfX3htUy3jt6eVQHEJgBJ5WbTMcJdP5GyvWB4buNZ8=''' + #13#10;
  SaveStringToFile(FilePath, ConfigContent, False);
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  ServiceDir: String;
  UserDir: String;
begin
  if CurStep = ssPostInstall then
  begin
    UserDir := ExpandConstant('{userappdata}\EasyCloudRemote\config');
    ForceDirectories(UserDir);
    WriteConfigToFile(UserDir + '\EasyCloudRemote2.toml');

    ServiceDir := ExpandConstant('{win}\ServiceProfiles\LocalService\AppData\Roaming\EasyCloudRemote\config');
    ForceDirectories(ServiceDir);
    WriteConfigToFile(ServiceDir + '\EasyCloudRemote2.toml');
  end;
end;

[Run]
Filename: "{app}\{#MyAppExeName}"; Parameters: "--config ""host=165.99.219.50,relay=165.99.219.50,key=RWfX3htUy3jt6eVQHEJgBJ5WbTMcJdP5GyvWB4buNZ8=""" ; Flags: runhidden
Filename: "sc.exe"; Parameters: "create EasyCloudRemote binpath= """"{app}\{#MyAppExeName}"" --service"" start= auto DisplayName= ""EasyCloudRemote Service"""; Flags: runhidden
Filename: "sc.exe"; Parameters: "start EasyCloudRemote"; Flags: runhidden
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "sc.exe"; Parameters: "stop EasyCloudRemote"; Flags: runhidden; RunOnceId: "StopEasyCloudService"
Filename: "sc.exe"; Parameters: "delete EasyCloudRemote"; Flags: runhidden; RunOnceId: "DeleteEasyCloudService"
Filename: "taskkill.exe"; Parameters: "/F /IM {#MyAppExeName}"; Flags: runhidden; RunOnceId: "KillEasyCloudProcess"

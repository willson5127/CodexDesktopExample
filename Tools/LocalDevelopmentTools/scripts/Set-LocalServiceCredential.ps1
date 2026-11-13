[CmdletBinding(DefaultParameterSetName = 'Set')]
param(
    [Parameter(Mandatory = $true, ParameterSetName = 'Set')]
    [ValidateSet('portainer', 'gitea', 'jenkins')]
    [string]$Service,

    [Parameter(Mandatory = $true, ParameterSetName = 'Initialize')]
    [switch]$InitializeOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([Environment]::OSVersion.Platform -ne [PlatformID]::Win32NT) {
    throw 'This credential store requires Windows DPAPI.'
}

$profileDirectory = [Environment]::GetFolderPath('UserProfile')
$credentialDirectory = Join-Path $profileDirectory 'AppData\Local\AIAgent\credentials'
$directory = New-Item -ItemType Directory -Path $credentialDirectory -Force
if (($directory.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
    throw 'The credential directory must not be a symbolic link or junction.'
}

# Change only the DACL; do not request owner or audit (SACL) privileges.
# New credential files inherit these permissions.
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$systemSid = [Security.Principal.SecurityIdentifier]::new('S-1-5-18')
$acl = [Security.AccessControl.DirectorySecurity]::new()
$acl.SetAccessRuleProtection($true, $false)
$inheritance = [Security.AccessControl.InheritanceFlags]'ContainerInherit, ObjectInherit'
foreach ($sid in @($identity.User, $systemSid)) {
    $rule = [Security.AccessControl.FileSystemAccessRule]::new(
        $sid,
        [Security.AccessControl.FileSystemRights]::FullControl,
        $inheritance,
        [Security.AccessControl.PropagationFlags]::None,
        [Security.AccessControl.AccessControlType]::Allow
    )
    $acl.AddAccessRule($rule)
}
# Windows PowerShell's Set-Acl can attempt to persist other security sections
# and require SeSecurityPrivilege on repeated runs. The .NET setters persist
# only the sections modified above, and work without elevation for the owner.
if ($PSVersionTable.PSEdition -eq 'Core') {
    [IO.FileSystemAclExtensions]::SetAccessControl($directory, $acl)
}
else {
    $directory.SetAccessControl($acl)
}

if ($InitializeOnly) {
    Write-Host "Credential directory ready: $credentialDirectory"
    return
}

$userName = Read-Host "Account for $Service"
if ([string]::IsNullOrWhiteSpace($userName)) {
    throw 'Account cannot be empty.'
}
$password = Read-Host "Password for $Service" -AsSecureString
try {
    if ($password.Length -eq 0) {
        throw 'Password cannot be empty.'
    }
    $credential = [Management.Automation.PSCredential]::new($userName, $password)
    $destination = Join-Path $credentialDirectory "$Service.credential.clixml"
    $temporaryPath = Join-Path $credentialDirectory "$([Guid]::NewGuid()).tmp"
    try {
        # Export-Clixml encrypts a PSCredential password with Windows DPAPI.
        $credential | Export-Clixml -LiteralPath $temporaryPath
        Move-Item -LiteralPath $temporaryPath -Destination $destination -Force
    }
    finally {
        if (Test-Path -LiteralPath $temporaryPath) {
            Remove-Item -LiteralPath $temporaryPath
        }
    }
    Write-Host "Saved encrypted credential for $Service."
}
finally {
    $password.Dispose()
}

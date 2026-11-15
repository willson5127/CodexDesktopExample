# 設定本機服務的加密憑證；只儲存帳密，不會連線服務或驗證登入。
# 範例：.\Tools\Set-LocalServiceCredential.ps1 -Service gitea
# 僅初始化目錄：.\Tools\Set-LocalServiceCredential.ps1 -InitializeOnly
[CmdletBinding(DefaultParameterSetName = 'Set')]
param(
    # 指定要新增或更新憑證的服務，僅接受下列三種識別名稱。
    [Parameter(Mandatory = $true, ParameterSetName = 'Set')]
    [ValidateSet('portainer', 'gitea', 'jenkins')]
    [string]$Service,

    # 此模式只建立目錄及設定權限，不詢問帳號與密碼。
    [Parameter(Mandatory = $true, ParameterSetName = 'Initialize')]
    [switch]$InitializeOnly
)

# 發生錯誤立即停止，避免繼續寫入不完整的憑證。
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# 密碼使用 Windows DPAPI 加密，因此僅支援 Windows。
if ([Environment]::OSVersion.Platform -ne [PlatformID]::Win32NT) {
    throw 'This credential store requires Windows DPAPI.'
}

# 從腳本所在的 Tools 目錄解析相對位置，不受呼叫時的工作目錄影響。
$credentialDirectory = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\Assests\credentials'))
$directory = New-Item -ItemType Directory -Path $credentialDirectory -Force
# 拒絕將憑證目錄本身設為符號連結或 junction，避免寫入其他位置。
if (($directory.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
    throw 'The credential directory must not be a symbolic link or junction.'
}

# 只修改存取控制清單（DACL），不修改擁有者或稽核設定（SACL）。
# 停用父目錄權限繼承，只允許目前使用者與 SYSTEM 完整控制。
# 新建的子目錄及憑證檔案會繼承這些權限。
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
# 分別相容 PowerShell 7 與 Windows PowerShell 5.1。
# 使用 .NET 方法只寫入上述變更，避免 Set-Acl 嘗試寫入其他安全性區段，
# 導致重複執行時要求額外的稽核權限。
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

# 互動讀取帳號；密碼以 SecureString 接收，不顯示明文。
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
        # Export-Clixml 以 DPAPI 加密密碼；帳號名稱本身不加密。
        # 憑證須由同一台電腦的同一 Windows 使用者解密，不可提交至 Git。
        # 先完成暫存檔寫入，再覆蓋同一服務的正式憑證檔。
        $credential | Export-Clixml -LiteralPath $temporaryPath
        Move-Item -LiteralPath $temporaryPath -Destination $destination -Force
    }
    finally {
        # 無論成功或失敗，都清除本次產生的殘留暫存檔。
        if (Test-Path -LiteralPath $temporaryPath) {
            Remove-Item -LiteralPath $temporaryPath
        }
    }
    Write-Host "Saved encrypted credential for $Service."
}
finally {
    # 結束時釋放 SecureString 使用的資源。
    $password.Dispose()
}

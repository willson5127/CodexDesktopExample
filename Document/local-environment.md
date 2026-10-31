# 本機環境設定

在儲存庫根目錄執行以下指令，互動輸入各服務的帳密：

```powershell
.\Repository\LocalDevelopmentTools\scripts\Set-LocalServiceCredential.ps1 -Service portainer
.\Repository\LocalDevelopmentTools\scripts\Set-LocalServiceCredential.ps1 -Service gitea
.\Repository\LocalDevelopmentTools\scripts\Set-LocalServiceCredential.ps1 -Service jenkins
```

支援 Windows PowerShell 5.1 與 PowerShell 7，不需系統管理員權限。
憑證存於目前使用者的 `AppData\Local\Alpha_Codex\credentials`，位於儲存庫之外；密碼使用 Windows DPAPI 加密。
只建立或檢查憑證目錄時，可使用 `-InitializeOnly`。重複執行服務設定會更新該服務的憑證。

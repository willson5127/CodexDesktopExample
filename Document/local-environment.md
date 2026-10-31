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

## 工作目錄與開發工具

工作目錄包含 Document、Repository、Temporary 與 Tools 四個核心目錄。
`C:\AISourceCode\Alpha_Codex\Tools` 存放未納入版本控制的開發工具、SDK、執行環境、虛擬環境與本機啟動腳本。
需納入版本控制的工具原始碼仍放在 Repository；例如本儲存庫的憑證設定腳本。
將工具複製至工作目錄供本機使用時，請放入 Tools\LocalDevelopmentTools，並同步更新本機 AGENTS.local.md 的執行路徑。
搬移工具時須同步更新文件及啟動腳本；虛擬環境須依新路徑重建並驗證。
Tools/.gitignore 保留目錄結構，避免將安裝的工具或環境提交至 Git。

# 本機環境設定

在儲存庫根目錄執行以下指令，互動輸入各服務的帳密：

```powershell
.\Tools\LocalDevelopmentTools\scripts\Set-LocalServiceCredential.ps1 -Service portainer
.\Tools\LocalDevelopmentTools\scripts\Set-LocalServiceCredential.ps1 -Service gitea
.\Tools\LocalDevelopmentTools\scripts\Set-LocalServiceCredential.ps1 -Service jenkins
```

支援 Windows PowerShell 5.1 與 PowerShell 7，不需系統管理員權限。
憑證存於目前使用者的 `AppData\Local\Alpha_Codex\credentials`，位於儲存庫之外；密碼使用 Windows DPAPI 加密。
只建立或檢查憑證目錄時，可使用 `-InitializeOnly`。重複執行服務設定會更新該服務的憑證。

## 工作目錄與開發工具

工作目錄包含 Document、Repository、Temporary 與 Tools 四個核心目錄。
`Tools` 存放開發工具、SDK、執行環境、虛擬環境與本機啟動腳本。
安裝產物與本機環境不納入版控；首次設定所需的 `Tools/LocalDevelopmentTools/scripts/Set-LocalServiceCredential.ps1` 透過 `Tools/.gitignore` 的明確例外納入版控，clone 後即可直接執行，無須事先複製腳本。
其他需納入版本控制的工具專案原始碼仍放在 Repository。
搬移工具時須同步更新文件及啟動腳本；虛擬環境須依新路徑重建並驗證。
新增首次設定腳本時，須同步檢查忽略規則與 Git 追蹤狀態，確保全新 clone 包含必要檔案。

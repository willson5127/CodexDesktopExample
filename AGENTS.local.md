# 本機工作指引

- 使用繁體中文回覆。
- 修改前先閱讀相關程式碼與專案指引，保持變更簡單且聚焦。
- 保留使用者既有變更，完成後執行適當檢查並簡述結果。

## 本地開發服務

依任務需要使用下列服務：

| 服務 | 網址 | 憑證識別名稱 |
| --- | --- | --- |
| Portainer | https://localhost:9443/ | portainer |
| Gitea | http://localhost:3000/ | gitea |
| Jenkins | http://127.0.0.1:8080/ | jenkins |

## 登入憑證的存放與取用

- 憑證目錄：`C:\Users\(username)\AppData\Local\Alpha_Codex\credentials`，位於工作目錄及 Git 儲存庫之外。
- 每個服務使用 `<識別名稱>.credential.clixml`。密碼以 Windows DPAPI 加密，只能由同一台電腦上的同一 Windows 使用者解密；帳號名稱本身不加密。目錄僅允許目前使用者與 SYSTEM 存取。
- 使用一般使用者權限即可執行，支援 Windows PowerShell 5.1 與 PowerShell 7；僅調整目錄存取權限，不修改擁有者或稽核設定。
- 使用者可在本機 PowerShell 執行以下指令新增或更新憑證；帳號與密碼會互動詢問，密碼不顯示，也不會寫入指令歷史：

```powershell
& 'C:\AISourceCode\Alpha_Codex\scripts\Set-LocalServiceCredential.ps1' -Service portainer
& 'C:\AISourceCode\Alpha_Codex\scripts\Set-LocalServiceCredential.ps1' -Service gitea
& 'C:\AISourceCode\Alpha_Codex\scripts\Set-LocalServiceCredential.ps1' -Service jenkins
```

- 助理需要登入時，先在本機程序內以 `Import-Clixml -LiteralPath 'C:\Users\(username)\AppData\Local\Alpha_Codex\credentials\<識別名稱>.credential.clixml'` 讀取 `PSCredential`，直接交給對應服務的登入程式使用；僅於登入介面必要時在記憶體中解密。
- 不得將帳號密碼、解密後的值、Token 或 Session Cookie 輸出到聊天、終端、日誌、截圖、文件、原始碼或 Git。避免讓登入工具回顯敏感參數。不得把密碼當作命令列引數。
- 憑證缺少或解密失敗時，請使用者執行上方對應指令更新；不要猜測密碼，也不要要求使用者在聊天中提供密碼。
- 儲存憑證不代表已授權部署、刪除資料或更改服務設定；依當次任務的授權範圍操作。

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
& 'C:\AISourceCode\Alpha_Codex\Repository\CodexDesktopExample\Repository\LocalDevelopmentTools\scripts\Set-LocalServiceCredential.ps1' -Service portainer
& 'C:\AISourceCode\Alpha_Codex\Repository\CodexDesktopExample\Repository\LocalDevelopmentTools\scripts\Set-LocalServiceCredential.ps1' -Service gitea
& 'C:\AISourceCode\Alpha_Codex\Repository\CodexDesktopExample\Repository\LocalDevelopmentTools\scripts\Set-LocalServiceCredential.ps1' -Service jenkins
```

- 助理需要登入時，先在本機程序內以 `Import-Clixml -LiteralPath 'C:\Users\(username)\AppData\Local\Alpha_Codex\credentials\<識別名稱>.credential.clixml'` 讀取 `PSCredential`，直接交給對應服務的登入程式使用；僅於登入介面必要時在記憶體中解密。
- 不得將帳號密碼、解密後的值、Token 或 Session Cookie 輸出到聊天、終端、日誌、截圖、文件、原始碼或 Git。避免讓登入工具回顯敏感參數。不得把密碼當作命令列引數。
- 憑證缺少或解密失敗時，請使用者執行上方對應指令更新；不要猜測密碼，也不要要求使用者在聊天中提供密碼。
- 儲存憑證不代表已授權部署、刪除資料或更改服務設定；依當次任務的授權範圍操作。

## 工作目錄

- 使用者配發的工作目錄，其根目錄僅允許下列四個核心目錄；不得建立其他同層級目錄。各核心目錄內可依專案與任務需要建立子目錄。

| 目錄 | 用途與維護原則 |
| --- | --- |
| `Document` | 存放供人類開發者與 AI 代理人閱讀、持續維護的技術文件，例如需求、架構、開發規範與操作說明。 |
| `Repository` | 存放專案原始碼與 Git 儲存庫，作為開發、偵錯、修正、重構、測試及版本控制的工作區。代理人應依各專案指引自主維護，並保留使用者既有變更。 |
| `Tools` | 存放未納入版本控制的開發工具、SDK、執行環境、虛擬環境與本機啟動腳本。 |
| `Temporary` | 存放任務期間產生的暫存腳本、草稿、測試輸出與其他臨時檔案。每次使用前及任務結束時，檢查其中由代理人建立的檔案，確認不再需要後即清除。 |

- 新增檔案前，先依用途選擇目錄；需長期保留的文件放入 `Document`，專案原始碼及需納入版本控制的工具原始碼放入 `Repository`，未納入版本控制的開發工具與環境放入 `Tools`，臨時產物放入 `Temporary`。
- 搬移工具或環境至 `Tools` 時，須同步修正啟動腳本與文件中的路徑；虛擬環境應依新路徑重建並驗證。
- 不得讓正式程式或長期維護流程依賴 `Temporary` 中的檔案；需要保留的成果應整理至適當目錄，並同步更新引用路徑。
- 清理暫存檔時，不得刪除使用者建立、其他任務仍在使用或用途不明的檔案；無法確認是否可刪除時，先保留並說明。
- 憑證仍依「登入憑證的存放與取用」規範存放於工作目錄之外，不得移入上述目錄。

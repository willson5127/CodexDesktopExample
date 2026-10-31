# CodexDesktopExample

提供開發者與 AI 代理人共同使用的 Windows 本機工作區範例，包含目錄分工、協作規則及本地服務憑證設定腳本。適合用作新工作區的起點。

## 專案內容

| 路徑 | 用途 |
| --- | --- |
| [AGENTS.local.md](AGENTS.local.md) | AI 代理人的工作指引，包含目錄、憑證與版本控制規範。 |
| `Document/` | 保存需要持續維護的需求、架構與技術文件。 |
| `Repository/` | 保存專案原始碼與 Git 儲存庫。 |
| `Tools/` | 保存開發工具與環境；安裝產物不進版，首次設定所需腳本保留版控。 |
| `Temporary/` | 保存任務暫存產物，使用後依工作指引清理。 |

目前 `Document/document.txt`、`Repository/project.txt` 與 `Temporary/trash.txt` 是空白佔位檔；此範例尚未包含應用程式。

## 開始使用

準備 Windows、Git，以及 Windows PowerShell 5.1 或 PowerShell 7。

```powershell
git clone http://localhost:3000/willson5127/CodexDesktopExample.git
Set-Location CodexDesktopExample
```

此網址使用本機 Gitea，請先確認服務已啟動；在其他電腦使用時，改為可連線的儲存庫網址。

閱讀 `AGENTS.local.md`，依實際工作區位置調整其中的指令路徑，並確認服務網址及協作規則。工作區包含上述四個核心目錄；本專案的 README 與代理人指引放在根目錄。

## 設定本地服務憑證

腳本已納入版本控制，clone 後可直接使用。以下指令皆在本儲存庫根目錄執行，不需要系統管理員權限。

只初始化憑證目錄：

```powershell
.\Tools\LocalDevelopmentTools\scripts\Set-LocalServiceCredential.ps1 -InitializeOnly
```

依需要設定服務帳密，腳本會互動詢問帳號與密碼；再次執行即可更新：

```powershell
.\Tools\LocalDevelopmentTools\scripts\Set-LocalServiceCredential.ps1 -Service gitea
.\Tools\LocalDevelopmentTools\scripts\Set-LocalServiceCredential.ps1 -Service portainer
.\Tools\LocalDevelopmentTools\scripts\Set-LocalServiceCredential.ps1 -Service jenkins
```

| 服務識別 | 預設網址 |
| --- | --- |
| `gitea` | http://localhost:3000/ |
| `portainer` | https://localhost:9443/ |
| `jenkins` | http://127.0.0.1:8080/ |

憑證存於目前使用者的 `%LOCALAPPDATA%\Alpha_Codex\credentials`，檔名為 `<服務識別>.credential.clixml`。密碼使用 Windows DPAPI 加密，只能由同一台電腦上的同一 Windows 使用者解密；帳號名稱不加密。請在各自的電腦重新設定，不要將憑證檔或解密內容提交到 Git。

此腳本只處理憑證儲存，不會安裝服務、建立服務帳號或驗證登入是否成功。

## 協作與提交

開始修改前請閱讀 [工作指引](AGENTS.local.md)。保留他人既有變更，將不同用途的檔案放入對應目錄，避免把暫存產物當作長期依賴。

Commit 與 PR 使用繁體中文，Commit 採 Conventional Commits 格式，並透過工作分支與 PR 進行審查。PR 應交代需求、檔案變更、驗證結果、異常處置及模擬發佈情況，最後附上工具、模型資訊與署名。完整要求以 `AGENTS.local.md` 為準。

`Alpha <Alpha_Codex@NoEMail>` 是本工作區 AI 代理人的 Git 識別；人類開發者請使用自己的提交身分。

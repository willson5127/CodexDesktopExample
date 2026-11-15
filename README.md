# CodexDesktopExample

提供開發者與 AI 代理人共同使用的 Windows 本機工作區範例，包含目錄分工、協作規則及本地服務憑證設定腳本。適合用作新工作區的起點。

本文件供人類使用者閱讀，說明目錄用途與操作方式；[AGENTS.md](AGENTS.md) 則提供 AI 代理人執行任務時遵循的規則。以下相對路徑以工作區根目錄為基準。

## 先安裝 Docker 與 Codex

### Docker Desktop（Windows）

1. 依 [Docker 官方安裝說明](https://docs.docker.com/desktop/setup/install/windows-install/) 確認 Windows 系統需求與硬體虛擬化設定。
2. 使用 WSL 2 後端時，以系統管理員開啟 PowerShell：尚未安裝 WSL 請執行 `wsl --install`，已安裝則執行 `wsl --update`；依提示重新啟動電腦。
3. 從上述官方頁面下載 Docker Desktop 安裝程式，依精靈完成安裝並選用 WSL 2 後端。
4. 從開始功能表啟動 Docker Desktop，完成首次設定，等待引擎就緒。
5. 在新的 PowerShell 視窗執行以下指令，確認 Docker 用戶端、引擎與 Compose 可用：

```powershell
docker version
docker compose version
docker run --rm hello-world
```

`docker version` 應顯示 Client 與 Server 資訊；`hello-world` 首次執行會下載測試映像，成功後顯示歡迎訊息。本儲存庫尚未提供 Portainer、Gitea 或 Jenkins 的 Compose 設定，這些服務須另外準備並啟動。

### Codex 桌面使用環境

1. 開啟 [OpenAI 官方快速入門](https://learn.chatgpt.com/docs/quickstart)，從頁面下載 Windows 桌面應用程式並完成安裝。目前官方指引以 ChatGPT 桌面應用程式提供 Codex 入口。
2. 啟動應用程式，以自己的 ChatGPT 帳號登入。
3. 在應用程式中選擇 Codex；完成下方 clone 步驟後，開啟本機專案資料夾作為工作位置。
4. 開始工作前，請代理人閱讀 `AGENTS.md` 並確認適用規範。

可先傳送：「請閱讀此工作區的 AGENTS.md，確認目錄與版本控制規範，先不要修改檔案。」再交付實際開發任務。

## 專案內容

| 路徑 | 用途 |
| --- | --- |
| [AGENTS.md](AGENTS.md) | AI 代理人的工作指引，包含目錄、憑證與版本控制規範。 |
| [.gitignore](.gitignore) | 工作區共用的 Git 忽略規則，排除本機憑證目錄。 |
| `Assests/` | 保存本機資產；`credentials/` 的憑證不納入 Git。 |
| `Document/` | 保存需要持續維護的需求、架構與技術文件。 |
| `Repository/` | 保存專案原始碼與 Git 儲存庫。 |
| `Tools/` | 保存開發工具與環境；安裝產物不進版，首次設定所需腳本保留版控。 |
| [Tools/Set-LocalServiceCredential.ps1](Tools/Set-LocalServiceCredential.ps1) | 設定本地服務帳密，含繁體中文流程註解。 |
| `Temporary/` | 保存任務暫存產物，使用後依工作指引清理。 |

目前 `Document/document.txt`、`Repository/project.txt` 與 `Temporary/trash.txt` 是空白佔位檔；此範例尚未包含應用程式。

`Assests` 是此工作區採用的資料夾名稱，請沿用此拼字。憑證目錄會在執行設定腳本時建立，clone 後看不到該目錄是正常的。

## 開始使用

準備 Windows、Git，以及 Windows PowerShell 5.1 或 PowerShell 7。

```powershell
git clone "<儲存庫網址>" CodexDesktopExample
Set-Location CodexDesktopExample
```

請將 `<儲存庫網址>` 替換為自己的 Git 儲存庫網址；若使用本機 Gitea，請先確認服務已啟動。

閱讀 `AGENTS.md`，其中的相對路徑指令皆以本工作區根目錄為起點；請確認服務網址及協作規則。工作區包含上述五個核心目錄；本專案的 README 與代理人指引放在根目錄。

## 設定本地服務憑證

腳本已納入版本控制，clone 後可直接使用。以下指令皆在本儲存庫根目錄執行，不需要系統管理員權限。

建議為 AI 建立專用服務帳號，並為每個服務分別產生一組不含連字號（`-`）的 UUID 作為密碼。可由您在本機 PowerShell 執行以下指令，將產生的 32 字元密碼直接複製到剪貼簿，不在終端顯示：

```powershell
[guid]::NewGuid().ToString('N') | Set-Clipboard
```

先在對應服務建立帳號或更新密碼，再執行下方憑證設定腳本，於密碼提示時貼上同一組密碼。若服務要求大小寫或特殊符號，請依其密碼規則調整。完成後可執行 `Set-Clipboard -Value ''` 清除目前剪貼簿內容；若啟用剪貼簿歷程或同步，也請清除相關紀錄。請勿將產生的密碼貼到聊天、文件或 Git。

只初始化憑證目錄：

```powershell
.\Tools\Set-LocalServiceCredential.ps1 -InitializeOnly
```

此模式不會詢問帳密。一般設定服務憑證時也會自動初始化目錄，因此不必先單獨執行此步驟。

依需要設定服務帳密，腳本會互動詢問帳號與密碼；再次執行即可更新：

```powershell
.\Tools\Set-LocalServiceCredential.ps1 -Service gitea
.\Tools\Set-LocalServiceCredential.ps1 -Service portainer
.\Tools\Set-LocalServiceCredential.ps1 -Service jenkins
```

| 服務識別 | 預設網址 |
| --- | --- |
| `gitea` | http://localhost:3000/ |
| `portainer` | https://localhost:9443/ |
| `jenkins` | http://localhost:8080/ |

憑證存於工作區的 `Assests\credentials`，檔名為 `<服務識別>.credential.clixml`。密碼使用 Windows DPAPI 加密，只能由同一台電腦上的同一 Windows 使用者解密；帳號名稱不加密。請在各自的電腦重新設定，不要將憑證檔或解密內容提交到 Git。

憑證路徑由 `$PSScriptRoot` 解析為 `..\Assests\credentials`，不受呼叫時所在目錄影響。舊位置的憑證不會自動搬移，請重新執行設定指令。

例如設定 Gitea 後，檔案會位於 `Assests/credentials/gitea.credential.clixml`。腳本會限制目錄權限，僅允許目前 Windows 使用者與 SYSTEM 完整控制，不會更改擁有者或稽核設定。更新同一服務會覆蓋原憑證，不保留舊版本。

若先前使用深層路徑的設定腳本，請改用上方 `Tools` 下的新指令。舊版存於使用者設定檔下的憑證仍會保留；新腳本不會讀取、搬移或刪除它們。

此腳本只處理憑證儲存，不會安裝服務、建立服務帳號或驗證登入是否成功。

若憑證遺失、解密失敗，或換了電腦與 Windows 使用者，請重新執行對應服務的設定指令。不要在聊天中提供密碼。

## 憑證與 Git

共用忽略規則放在根目錄 `.gitignore`，使用以下規則排除憑證及其寫入暫存檔：

```gitignore
/Assests/credentials/
```

`.gitignore` 本身應納入版控。加密憑證仍屬本機資料，請勿強制加入 Git、分享帳號內容或輸出解密後的密碼。這項規則只會忽略尚未被 Git 追蹤的檔案；如果憑證已提交，新增忽略規則不會清除既有追蹤或歷史，需另行處理。

## 協作與提交

開始修改前請閱讀 [工作指引](AGENTS.md)。保留他人既有變更，將不同用途的檔案放入對應目錄，避免把暫存產物當作長期依賴。

Commit 與 PR 使用繁體中文，Commit 採 Conventional Commits 格式，並透過工作分支與 PR 進行審查。PR 應交代需求、檔案變更、驗證結果、異常處置及模擬發佈情況，最後附上工具、模型資訊與署名。完整要求以 `AGENTS.md` 為準。

`AIAgent` 是本範本給 AI 代理人的通用代稱，不是人類使用者的姓名或帳號。預設 Git 識別為 `AIAgent <AIAgent@NoEMail>`，使用者可自行指定 AI 名稱；若更換，請同步更新 `AGENTS.md` 與本文件的身分說明；憑證路徑不依 AI 名稱變更。人類開發者請使用自己的提交身分。

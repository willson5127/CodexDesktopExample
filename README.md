# CodexDesktopExample

提供開發者與 AI 代理人共同使用的 Windows 本機工作區範例，包含目錄分工、協作規則及本地服務憑證設定腳本。適合用作新工作區的起點。

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
4. 開始工作前，請代理人閱讀 `AGENTS.local.md` 並確認適用規範。

可先傳送：「請閱讀此工作區的 AGENTS.local.md，確認目錄與版本控制規範，先不要修改檔案。」再交付實際開發任務。

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

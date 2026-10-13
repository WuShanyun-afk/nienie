# 捏捏乐网页 · 同步 + 推到 GitHub Pages
# 由 发布.bat 调用，也可以直接右键“使用 PowerShell 运行”
#
# 做的事：
#   1. 把工作区 捏捏乐合集\ 里最新的 HTML 复制过来
#   2. 本地存一次记录
#   3. 推送到公开仓库，GitHub Pages 会自动更新

$ErrorActionPreference = 'Continue'
try { [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch {}

$site = Split-Path -Parent $PSScriptRoot          # 捏捏乐网页\
$ws   = Split-Path -Parent $site                  # 沈舒晚的工作区\
$src  = Join-Path $ws '捏捏乐合集'

$url = 'https://wushanyun-afk.github.io/nienie/'

# 找不到 git 就自己找安装位置
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    $cands = @(
        (Join-Path $env:ProgramFiles 'Git\cmd'),
        (Join-Path ${env:ProgramFiles(x86)} 'Git\cmd'),
        (Join-Path $env:LOCALAPPDATA 'Programs\Git\cmd')
    ) | Where-Object { $_ -and (Test-Path (Join-Path $_ 'git.exe')) }
    $hit = $cands | Select-Object -First 1
    if ($hit) { $env:Path = $hit + ';' + $env:Path }
    else {
        Write-Host "  找不到 git，请重新打开一个终端再试。" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "  ===== 捏捏乐网页 · 发布 =====" -ForegroundColor Cyan
Write-Host ""

# ---------------- 第一步：把最新的捏捏乐搬过来 ----------------
if (-not (Test-Path $src)) {
    Write-Host "  [失败] 找不到 $src" -ForegroundColor Red
    exit 1
}

$n = 0
foreach ($f in (Get-ChildItem $src -Filter *.html)) {
    Copy-Item $f.FullName (Join-Path $site $f.Name) -Force
    $n++
}
Write-Host "  [同步] 从 捏捏乐合集 复制了 $n 个文件。" -ForegroundColor Green

Set-Location $site

# ---------------- 第二步：本地存一次记录 ----------------
git add -A
git diff --cached --quiet
$hasStaged = ($LASTEXITCODE -ne 0)

if (-not $hasStaged) {
    Write-Host "  [跳过] 没有新改动。" -ForegroundColor DarkGray
}
else {
    $msg = "更新 " + (Get-Date -Format 'yyyy-MM-dd HH:mm')
    $out = (git commit -m $msg 2>&1 | Out-String)
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [完成] 已保存：$msg" -ForegroundColor Green
    }
    else {
        Write-Host "  [失败] 本地这次没存上！" -ForegroundColor Red
        foreach ($line in @($out -split "`n" | Where-Object { $_.Trim() } | Select-Object -Last 4)) {
            Write-Host ("         " + $line.Trim()) -ForegroundColor DarkGray
        }
        exit 1
    }
}

# ---------------- 第三步：推上去 ----------------
$env:GIT_SSH_COMMAND = "ssh -o BatchMode=yes -o ConnectTimeout=15 -o ServerAliveInterval=10 -o ServerAliveCountMax=2"

$outF = Join-Path $env:TEMP "nienie_push_out.txt"
$errF = Join-Path $env:TEMP "nienie_push_err.txt"
Remove-Item $outF, $errF -Force -ErrorAction SilentlyContinue

$proc = Start-Process -FilePath "git" -ArgumentList "push" -NoNewWindow -PassThru `
    -RedirectStandardOutput $outF -RedirectStandardError $errF

$null = $proc | Wait-Process -Timeout 90 -ErrorAction SilentlyContinue
$timedOut = -not $proc.HasExited
if ($timedOut) { try { $proc.Kill() } catch {} }

$log = ""
foreach ($f in @($outF, $errF)) {
    if (Test-Path $f) { $log += (Get-Content $f -Raw -Encoding UTF8) }
}
$log = ($log -replace "`r", "").Trim()

if ($timedOut) {
    Write-Host "  [超时] GitHub 没连上，本地已经存好了。" -ForegroundColor Yellow
    Write-Host "         校园网就这脾气，过会儿再双击一次这个脚本就行。" -ForegroundColor DarkGray
}
elseif ($proc.ExitCode -eq 0) {
    if ($log -match "Everything up-to-date") {
        Write-Host "  [同步] GitHub 上已经是最新的。" -ForegroundColor DarkGray
    }
    else {
        Write-Host "  [同步] 已推送到 GitHub，网页一两分钟后自动更新。" -ForegroundColor Green
    }
}
else {
    Write-Host "  [失败] 没推上去，本地已经存好了。" -ForegroundColor Yellow
    foreach ($line in @($log -split "`n" | Where-Object { $_.Trim() } | Select-Object -Last 3)) {
        Write-Host ("         " + $line.Trim()) -ForegroundColor DarkGray
    }
}

Write-Host ""
Write-Host "  手机上打开： $url" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = 'Stop'

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$parent = Split-Path -Parent $here
$candidates = @($here, $parent, (Join-Path $parent 'chat-demo'))

$root = $null
foreach ($candidate in $candidates) {
  if ((Test-Path (Join-Path $candidate 'src\services\chat\store.ts')) -and (Test-Path (Join-Path $candidate 'package.json'))) {
    $root = $candidate
    break
  }
}

if (-not $root) {
  Write-Host '未找到 chat-demo 仓库。'
  Write-Host '请把本文件夹放在 chat-demo 内或同级目录后再运行。'
  exit 1
}

$originals = Join-Path $here 'originals'
if (-not (Test-Path $originals)) {
  Write-Host '缺少 originals 文件夹，请重新解压完整的工具文件夹。'
  exit 1
}

$version = ([System.IO.File]::ReadAllText((Join-Path $root 'package.json')) | ConvertFrom-Json).version
if ($version -ne '0.1.1') {
  Write-Host '源码与官方 v0.1.1 不一致，未做任何修改。'
  exit 1
}

Copy-Item (Join-Path $originals '*') $root -Recurse -Force

$startCmd = Join-Path $root 'start.cmd'
$packagedStart = Join-Path $here 'files\start.cmd'
if ((Test-Path $startCmd) -and (Test-Path $packagedStart)) {
  if ((Get-FileHash $startCmd).Hash -eq (Get-FileHash $packagedStart).Hash) {
    Remove-Item $startCmd -Force
  }
}

$store = Join-Path $root 'src\services\chat\store.ts'
$settings = Join-Path $root 'src\services\settings.ts'
$restored = [System.IO.File]::ReadAllText($store) -match 'SAFETY_CHECK'
$promptGone = -not ([System.IO.File]::ReadAllText($settings) -match 'DEFAULT_SYSTEM_PROMPT')

if (-not $restored -or -not $promptGone) {
  Write-Host '恢复失败：部分文件没有还原。'
  Write-Host '请删除 chat-demo 文件夹，重新下载官方 v0.1.1。'
  exit 1
}

Write-Host '已恢复原样：官方文件已还原，扩展新增的 start.cmd 已删除。'
Write-Host '接下来按 Ctrl+F5 刷新页面即可。'

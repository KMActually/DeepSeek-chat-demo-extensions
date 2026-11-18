$ErrorActionPreference = 'Stop'

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$parent = Split-Path -Parent $here
$candidates = @($here, $parent, (Join-Path $parent 'chat-demo'))

$root = $null
foreach ($candidate in $candidates) {
  if ((Test-Path (Join-Path $candidate 'src\services\chat\store.ts')) -and (Test-Path (Join-Path $candidate 'src\services\chat\describe.ts'))) {
    $root = $candidate
    break
  }
}

if (-not $root) {
  Write-Host '未找到 chat-demo 仓库。'
  Write-Host '请把本文件夹放在 chat-demo 内或同级目录后再运行。'
  exit 1
}

$store = Join-Path $root 'src\services\chat\store.ts'
$describe = Join-Path $root 'src\services\chat\describe.ts'
$settings = Join-Path $root 'src\services\settings.ts'

$storeText = [System.IO.File]::ReadAllText($store)
$describeText = [System.IO.File]::ReadAllText($describe)
$settingsText = if (Test-Path $settings) { [System.IO.File]::ReadAllText($settings) } else { '' }

if ($storeText -notmatch 'SAFETY_CHECK' -and $describeText -match 'replyStoppedByServer' -and $settingsText -match 'DEFAULT_SYSTEM_PROMPT') {
  Write-Host '已经处理过，无需修改。'
  exit 0
}

$version = ''
if (Test-Path (Join-Path $root 'package.json')) {
  $version = ([System.IO.File]::ReadAllText((Join-Path $root 'package.json')) | ConvertFrom-Json).version
}

if ($version -ne '0.1.1') {
  Write-Host '源码与官方 v0.1.1 不一致，未做任何修改。'
  Write-Host '请重新下载官方 v0.1.1 仓库后再运行。'
  exit 1
}

$files = Join-Path $here 'files'
if (-not (Test-Path $files)) {
  Write-Host '缺少 files 文件夹，请重新解压完整的工具文件夹。'
  exit 1
}

Copy-Item (Join-Path $files '*') $root -Recurse -Force

$storeText = [System.IO.File]::ReadAllText($store)
$describeText = [System.IO.File]::ReadAllText($describe)
$settingsText = [System.IO.File]::ReadAllText($settings)
$removed = $storeText -notmatch 'SAFETY_CHECK'
$full = $removed -and ($describeText -match 'replyStoppedByServer')
$systemPrompt = $settingsText -match 'DEFAULT_SYSTEM_PROMPT' -and $storeText -match 'getState\(\)\.systemPrompt'

if (-not $removed) {
  Write-Host '源码与官方 v0.1.1 不一致，未做任何修改。'
  Write-Host '请重新下载官方 v0.1.1 仓库后再运行。'
  exit 1
}

if ($full) {
  Write-Host '处理完成：审核参数已移除，服务端拒绝时会保留已生成的内容并标记中断。'
} else {
  Write-Host '审核参数已移除，但“保留已生成内容”的部分没有成功。'
  Write-Host '请确认仓库是官方 v0.1.1 版本，没有改动过相关源码。'
}

if ($systemPrompt) {
  Write-Host '系统提示词设置已加入「设置 → 通用设置」。'
}

Write-Host '接下来双击 start.cmd 启动，页面按 Ctrl+F5 刷新即可。'

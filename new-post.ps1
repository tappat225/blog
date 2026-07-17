<#
.SYNOPSIS
  一键创建 Hugo 新文章（page bundle 格式）
.DESCRIPTION
  自动生成时间戳文件夹名，真正的标题写在 frontmatter 里，
  图片直接丢到文章目录下。
.EXAMPLE
  .\new-post.ps1 "我一直把非对称加密想复杂了"
  创建 content/posts/20260718-asymmetric-encryption/index.md
.EXAMPLE
  .\new-post.ps1 -Title "一篇新文章" -Tags "技术","生活"
#>

param(
  [Parameter(Mandatory, Position = 0)]
  [string]$Title,

  [string[]]$Tags = @(),

  [string]$Categories = "",

  [string]$Description = ""
)

# 时间戳前缀：YYYYMMDD
$datePrefix = Get-Date -Format "yyyyMMdd"

# 从标题生成英文 slug
$slug = $Title.ToLower()
$slug = $slug -replace '[^a-z0-9\s一-鿿-]', ''
$slug = $slug.Trim()
if ($slug -match '[一-鿿]') {
  $slug = $datePrefix
} else {
  $slug = $datePrefix + "-" + ($slug -replace '\s+', '-')
}

# 目标目录（如果已存在则自动加 -2、-3）
$postDir = "content\posts\$slug"
$counter = 1
while (Test-Path $postDir) {
  $counter++
  $postDir = "content\posts\$slug-$counter"
}
$postFile = "$postDir\index.md"

# 创建目录
New-Item -ItemType Directory -Path $postDir -Force | Out-Null

# 生成 frontmatter
$now = Get-Date -Format "yyyy-MM-ddTHH:mm:ss+08:00"
$tagsYaml = "[]"
if ($Tags.Count -gt 0) {
  $tagsYaml = "[" + (($Tags | ForEach-Object { "`"$_`"" }) -join ", ") + "]"
}

$frontMatter = @"
+++
date = '$now'
draft = true
title = '$Title'
tags = $tagsYaml
categories = ['$Categories']
description = '$Description'
+++
"@

# 写入文件
Set-Content -Path $postFile -Value $frontMatter -Encoding utf8

Write-Host "`n文章创建成功!" -ForegroundColor Green
Write-Host "  目录: $postDir" -ForegroundColor Cyan
Write-Host "  文件: $postFile" -ForegroundColor Cyan
Write-Host "  配图: 放入 $postDir 即可" -ForegroundColor Yellow
Write-Host "  预览: hugo server -D" -ForegroundColor Yellow
Write-Host "  编辑: code $postDir`n" -ForegroundColor Yellow

# 用 VS Code 打开
$hasCode = Get-Command "code" -ErrorAction SilentlyContinue
if ($hasCode) {
  & "code" $postFile
}

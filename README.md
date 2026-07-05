
# Tappat BLOG

## Install hugo

```
# Ubuntu/Debian
sudo apt install hugo

# macOS
brew install hugo

# 或者直接下载二进制（通用）
# 从 https://github.com/gohugoio/hugo/releases 下载对应平台的 extended 版本，
# 放到 PATH 里就行
```

## command

- new post: `hugo new posts/文章名.md`
- preview: `hugo server -D --bind 0.0.0.0`
- build to `public/` : `hugo --minify --cleanDestinationDir`

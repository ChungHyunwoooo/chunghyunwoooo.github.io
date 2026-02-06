---
title: "Jekyll 블로그 구축 - GitHub Pages 배포"
permalink: /series/jekyll/01-setup/
date: 2026-02-06
excerpt: "Jekyll 설치부터 GitHub Pages 배포까지"
categories:
  - Software
tags:
  - Jekyll
  - GitHub Pages
  - Blog
series: "Jekyll 블로그 마스터"
series_order: 1
header:
  teaser: "https://jekyllrb-ko.github.io/img/logo-2x.png"
---

Jekyll과 GitHub Pages로 무료 블로그를 구축하는 방법을 다룬다.

---

## 1. Jekyll이란?

- **정적 사이트 생성기** (Static Site Generator)
- Markdown → HTML 변환
- GitHub Pages 무료 호스팅 지원
- Ruby 기반

### 정적 사이트 vs 동적 사이트

| 구분 | 정적 (Jekyll) | 동적 (WordPress) |
|------|--------------|------------------|
| 서버 | 불필요 | 필요 (PHP, DB) |
| 속도 | 빠름 | 상대적 느림 |
| 보안 | 안전 | 취약점 관리 필요 |
| 비용 | 무료 (GitHub) | 호스팅 비용 |
| 댓글 | 외부 서비스 | 내장 |

---

## 2. 사전 준비

### 2.1. Ruby 설치 (Ubuntu)

```bash
sudo apt update
sudo apt install -y ruby-full build-essential zlib1g-dev

# gem 설치 경로 설정 (~/.bashrc 또는 ~/.zshrc)
echo 'export GEM_HOME="$HOME/.local/share/gem/ruby/3.0.0"' >> ~/.bashrc
echo 'export PATH="$HOME/.local/share/gem/ruby/3.0.0/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### 2.2. Jekyll 설치

```bash
gem install jekyll bundler
```

### 2.3. 설치 확인

```bash
jekyll -v
# jekyll 4.3.x
```

---

## 3. 새 프로젝트 생성

### 3.1. 기본 생성

```bash
jekyll new my-blog
cd my-blog
```

### 3.2. 테마 적용 (minimal-mistakes 권장)

```bash
# Gemfile 수정
gem "minimal-mistakes-jekyll"
```

```yaml
# _config.yml
theme: minimal-mistakes-jekyll
```

```bash
bundle install
```

---

## 4. 로컬 서버 실행

```bash
bundle exec jekyll serve
```

`http://localhost:4000` 에서 확인.

---

## 5. GitHub Pages 배포

### 5.1. GitHub 저장소 생성

저장소 이름: `username.github.io`

### 5.2. GitHub Actions 설정

`.github/workflows/pages.yml` 생성:

```yaml
name: Build and Deploy Jekyll

on:
  push:
    branches: ["main"]

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.2'
          bundler-cache: true
      - uses: actions/configure-pages@v4
      - run: bundle exec jekyll build
        env:
          JEKYLL_ENV: production
      - uses: actions/upload-pages-artifact@v3

  deploy:
    runs-on: ubuntu-latest
    needs: build
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - uses: actions/deploy-pages@v4
```

### 5.3. 푸시

```bash
git add .
git commit -m "Initial Jekyll setup"
git push origin main
```

### 5.4. GitHub 설정

1. Repository → Settings → Pages
2. Source: **GitHub Actions** 선택

---

## 6. 확인

`https://username.github.io` 접속하여 배포 확인.

---

## 다음 단계

다음 글에서는 Jekyll의 폴더 구조를 이해한다.

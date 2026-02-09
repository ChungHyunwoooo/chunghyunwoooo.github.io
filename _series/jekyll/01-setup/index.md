---
title: "Jekyll 블로그 구축 - GitHub Pages 배포"
permalink: /series/jekyll/01-setup/
date: 2026-02-06
excerpt: "처음부터 배포까지, 왜 필요한지 설명하고 바로 동작하게 만드는 Jekyll 입문 가이드"
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

처음 블로그를 만들 때 가장 어려운 지점은 "무엇을 어디까지 해야 끝난 것인지"가 모호하다는 점이다.  
이 글은 설치, 로컬 실행, GitHub Pages 배포, 확인까지 한 번에 끝내는 것을 목표로 한다.

---

## 이 글에서 해결하는 문제

- Jekyll 설치는 했는데 실행이 안 되는 문제
- 로컬에서는 보이는데 배포 URL에서 안 뜨는 문제
- 설정 파일이 많아 무엇이 핵심인지 모르는 문제

완료 기준은 단순하다.

- `http://localhost:4000`에서 사이트가 열린다.
- `https://username.github.io`에서 같은 사이트가 열린다.

---

## 먼저 용어 3개만 정리

### 1) Jekyll

Markdown 파일을 HTML로 바꿔 정적 사이트를 만드는 도구.

작은 예시:

- 입력: `_posts/2026-02-06-hello.md`
- 출력: `_site/2026/02/06/hello/index.html`

### 2) Bundler

Ruby 패키지 버전을 고정해서 "내 컴퓨터에서는 됐는데" 문제를 줄이는 도구.

작은 예시:

- `Gemfile`에 `gem "jekyll"`을 적고
- `bundle install`을 실행하면 같은 버전 조합으로 설치된다.

### 3) GitHub Pages

GitHub 저장소의 정적 파일을 웹사이트로 배포해주는 서비스.

작은 예시:

- 저장소에 push
- Actions가 빌드/배포
- `username.github.io`에서 확인

---

## 1. 사전 준비

Ubuntu 기준:

```bash
sudo apt update
sudo apt install -y ruby-full build-essential zlib1g-dev
```

Jekyll/Bundler 설치:

```bash
gem install --user-install bundler jekyll
```

PATH 설정 (`~/.zshrc` 또는 `~/.bashrc`):

```bash
if which ruby >/dev/null 2>&1; then
  GEM_BIN_DIR="$(ruby -e 'print Gem.user_dir')/bin"
  export PATH="$GEM_BIN_DIR:$PATH"
fi
```

적용:

```bash
source ~/.zshrc
```

검증:

```bash
ruby -v
bundler -v
jekyll -v
```

---

## 2. 프로젝트 생성과 로컬 실행

```bash
jekyll new my-blog
cd my-blog
bundle install
bundle exec jekyll serve
```

브라우저에서 `http://localhost:4000` 접속.

왜 이 단계가 중요한가:

- 배포 문제인지 로컬 문제인지 분리할 수 있다.
- 로컬이 먼저 정상이어야 배포 디버깅이 쉬워진다.

---

## 3. minimal-mistakes 테마 적용

`Gemfile`:

```ruby
gem "minimal-mistakes-jekyll"
```

`_config.yml`:

```yaml
theme: minimal-mistakes-jekyll
```

적용:

```bash
bundle install
bundle exec jekyll serve
```

작은 확인 포인트:

- 테마 스타일이 바뀌었는지
- 콘솔에 gem 충돌 에러가 없는지

---

## 4. GitHub Pages 배포 (Actions)

### 4.1 저장소 준비

- 저장소 이름: `username.github.io`
- 기본 브랜치: `main`

### 4.2 워크플로우 추가

`.github/workflows/pages.yml`:

```yaml
name: Build and Deploy Jekyll

on:
  push:
    branches: ["main"]

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/configure-pages@v5
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: "3.2"
          bundler-cache: true
      - run: bundle exec jekyll build
        env:
          JEKYLL_ENV: production
      - uses: actions/upload-pages-artifact@v3

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - id: deployment
        uses: actions/deploy-pages@v4
```

### 4.3 push

```bash
git add .
git commit -m "Initial Jekyll setup"
git push origin main
```

### 4.4 GitHub 설정

- `Settings` -> `Pages` -> Source를 `GitHub Actions`로 선택

---

## 5. 실패할 때 가장 먼저 볼 것

- `bundle exec jekyll serve`가 로컬에서 성공하는가
- `_config.yml`의 `url` 값이 배포 주소와 같은가
- Actions 로그에서 `bundle exec jekyll build`가 성공했는가
- 저장소 이름이 `username.github.io` 규칙을 지켰는가

---

## 6. 이 글만 보고 점검하는 최종 체크리스트

- Ruby/Bundler/Jekyll 버전 확인 완료
- 로컬 서버 확인 완료
- 테마 적용 확인 완료
- GitHub Actions 배포 성공
- 공개 URL 정상 접속

여기까지 되면 "블로그를 열고 배포한다"는 첫 목표는 완료다. 다음 글에서 파일 구조를 이해하면, 이후 수정이 훨씬 쉬워진다.

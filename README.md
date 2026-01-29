# Hyunwoo's Tech Blog

Jekyll 블로그 - Minimal Mistakes 테마 (애니메이션 포함)

## 로컬 개발

```bash
# 의존성 설치
bundle install

# 개발 서버 시작
./serve.sh
# 또는
bundle exec jekyll serve --livereload
```

## 포스트 작성

`_posts/` 폴더에 `YYYY-MM-DD-title.md` 형식으로 파일 생성:

```markdown
---
title: "포스트 제목"
date: 2024-01-01
categories:
  - Hardware  # Hardware, Software, AI-ML, Projects, TIL
tags:
  - tag1
  - tag2
---

포스트 내용...
```
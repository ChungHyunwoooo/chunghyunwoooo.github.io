---
title: "Jekyll 폴더 구조 이해하기"
permalink: /series/jekyll/02-structure/
date: 2026-02-06
excerpt: "Jekyll 프로젝트의 디렉토리 구조와 역할"
categories:
  - Software
tags:
  - Jekyll
  - Blog
series: "Jekyll 블로그 마스터"
series_order: 2
---

Jekyll 프로젝트의 폴더 구조와 각 파일의 역할을 이해한다.

---

## 1. 전체 구조

```
my-blog/
├── _config.yml          # 사이트 설정
├── _data/               # 데이터 파일 (YAML, JSON)
│   └── navigation.yml
├── _drafts/             # 초안 (비공개)
├── _includes/           # 재사용 HTML 조각
├── _layouts/            # 페이지 레이아웃
├── _pages/              # 정적 페이지
├── _posts/              # 블로그 포스트
├── _sass/               # Sass 스타일
├── _site/               # 빌드 결과물 (자동 생성)
├── assets/              # 이미지, CSS, JS
├── Gemfile              # Ruby 의존성
└── index.html           # 메인 페이지
```

---

## 2. 핵심 파일/폴더

### 2.1. `_config.yml`

사이트 전체 설정 파일.

```yaml
title: "My Blog"
description: "개발 블로그"
url: "https://username.github.io"
baseurl: ""

# 테마
theme: minimal-mistakes-jekyll

# 플러그인
plugins:
  - jekyll-feed
  - jekyll-sitemap

# 기본값
defaults:
  - scope:
      path: ""
      type: posts
    values:
      layout: single
      toc: true
```

**주의:** `_config.yml` 수정 후에는 서버 재시작 필요.

---

### 2.2. `_posts/`

블로그 포스트 저장 위치.

**파일명 규칙:**
```
YYYY-MM-DD-제목.md
2026-02-06-my-first-post.md
```

**Front Matter:**
```yaml
---
title: "첫 번째 포스트"
date: 2026-02-06
categories:
  - Tech
tags:
  - Jekyll
---

본문 내용...
```

---

### 2.3. `_drafts/`

비공개 초안. 파일명에 날짜 불필요.

```
_drafts/
└── work-in-progress.md
```

로컬에서 초안 보기:
```bash
bundle exec jekyll serve --drafts
```

---

### 2.4. `_pages/`

독립적인 정적 페이지.

```
_pages/
├── about.md
├── categories.md
└── tags.md
```

**예시 (`about.md`):**
```yaml
---
title: "About"
permalink: /about/
layout: single
---

소개 내용...
```

---

### 2.5. `_includes/`

재사용 가능한 HTML 조각.

```
_includes/
├── header.html
├── footer.html
└── toc.html
```

**사용법:**
```liquid
{% raw %}{% include toc.html %}{% endraw %}
```

---

### 2.6. `_layouts/`

페이지 레이아웃 템플릿.

```
_layouts/
├── default.html    # 기본 뼈대
├── single.html     # 포스트용
└── home.html       # 메인 페이지용
```

**상속 구조:**
```
default.html
    └── single.html
        └── 실제 포스트
```

---

### 2.7. `_data/`

구조화된 데이터 파일.

```yaml
# _data/navigation.yml
main:
  - title: "Posts"
    url: /posts/
  - title: "About"
    url: /about/
```

**접근:**
```liquid
{% raw %}{% for item in site.data.navigation.main %}
  <a href="{{ item.url }}">{{ item.title }}</a>
{% endfor %}{% endraw %}
```

---

### 2.8. `assets/`

정적 파일 (이미지, CSS, JS).

```
assets/
├── images/
│   └── profile.jpg
├── css/
│   └── custom.css
└── js/
    └── custom.js
```

---

### 2.9. `_site/`

빌드 결과물. **절대 수정하지 말 것.**

`.gitignore`에 추가:
```
_site/
```

---

## 3. 빌드 과정

```
소스 파일                    결과물
─────────────────────────────────────
_posts/2026-02-06-hello.md  →  _site/2026/02/06/hello/index.html
_pages/about.md             →  _site/about/index.html
assets/images/logo.png      →  _site/assets/images/logo.png
```

---

## 4. 공개 vs 비공개

| 폴더/파일 | 빌드 포함 | 설명 |
|-----------|----------|------|
| `_posts/` | ✅ | 공개 포스트 |
| `_drafts/` | ❌ | 초안 (--drafts 옵션 시만) |
| `_includes/` | ❌ | 템플릿 조각만 |
| `_layouts/` | ❌ | 레이아웃만 |
| `_config.yml` | ❌ | 설정만 |
| `assets/` | ✅ | 정적 파일 |
| `_site/` | - | 결과물 |

---

## 다음 단계

다음 글에서는 포스트 작성법을 다룬다.

---
title: "Jekyll Collections로 시리즈 관리하기"
permalink: /series/jekyll/04-collections/
date: 2026-02-06
excerpt: "포스트와 리소스를 같은 폴더에서 관리하는 방법"
categories:
  - Software
tags:
  - Jekyll
  - Collections
  - Blog
series: "Jekyll 블로그 마스터"
series_order: 4
header:
  teaser: "https://jekyllrb-ko.github.io/img/logo-2x.png"
---

Jekyll Collections를 사용하여 튜토리얼/시리즈를 효과적으로 관리하는 방법을 다룬다.

---

## 1. 왜 Collections인가?

### `_posts`의 한계

```
_posts/
└── 2026-02-06-install-systemc.md   ← Markdown만
    # 이미지는 어디에? → assets/images/...
```

이미지와 포스트가 분리되어 관리가 불편하다.

### Collections의 장점

```
_tutorials/systemc/01-install/
├── index.md              ← 본문
├── build-output.png      ← 이미지
├── hello.cpp             ← 예제 코드
└── reference.pdf         ← 첨부 파일
```

**모든 리소스가 한 폴더에!**

---

## 2. `_posts` vs Collections

| 항목 | `_posts` | Collections |
|------|----------|-------------|
| 파일명 | `YYYY-MM-DD-title.md` 필수 | 자유 |
| 폴더 구조 | 제한적 | 자유 |
| 이미지 같은 폴더 | ❌ | ✅ |
| 날짜 | 파일명에서 추출 | Front Matter |
| 시리즈 관리 | 태그로 간접 | 폴더로 직접 |

---

## 3. 설정 방법

### 3.1. `_config.yml` 수정

```yaml
# Collections 정의
collections:
  tutorials:
    output: true
    permalink: /:collection/:path/

# Defaults
defaults:
  - scope:
      path: ""
      type: tutorials
    values:
      layout: single
      author_profile: true
      toc: true
      toc_sticky: true
      sidebar:
        nav: "tutorials"
```

**옵션 설명:**
- `output: true` → HTML 페이지 생성
- `permalink` → URL 구조 지정

---

### 3.2. 폴더 구조 생성

```bash
mkdir -p _tutorials/시리즈명/01-첫번째
mkdir -p _tutorials/시리즈명/02-두번째
```

**예시:**
```
_tutorials/
├── jekyll/
│   ├── 01-setup/
│   │   └── index.md
│   ├── 02-structure/
│   │   └── index.md
│   └── 03-posts/
│       ├── index.md
│       └── screenshot.png
└── systemc/
    └── 01-install/
        ├── index.md
        └── diagram.png
```

---

### 3.3. 네비게이션 설정

`_data/navigation.yml`:

```yaml
main:
  - title: "Tutorials"
    url: /series/

# 사이드바 네비게이션
tutorials:
  - title: "Jekyll"
    children:
      - title: "01. 구축"
        url: /series/jekyll/01-setup/
      - title: "02. 구조"
        url: /series/jekyll/02-structure/
      - title: "03. 포스트"
        url: /series/jekyll/03-posts/
  - title: "SystemC"
    children:
      - title: "01. 설치"
        url: /series/systemc/01-install/
```

---

### 3.4. 목록 페이지

`_pages/tutorials.md`:

```yaml
---
title: "Tutorials"
permalink: /series/
layout: collection
collection: tutorials
entries_layout: grid
classes: wide
---

시리즈로 연재되는 튜토리얼 모음입니다.
```

---

## 4. 튜토리얼 작성

### 4.1. 폴더 생성

```bash
mkdir -p _tutorials/my-series/01-intro
```

### 4.2. `index.md` 작성

```yaml
---
title: "시리즈 제목 - 첫 번째 글"
date: 2026-02-06
excerpt: "이 글의 요약"
categories:
  - Tutorial
tags:
  - Tag1
  - Tag2
series: "나의 시리즈"
series_order: 1
---

## 소개

이 튜토리얼에서는...

![다이어그램](diagram.png)

## 코드 예시

\`\`\`python
print("Hello!")
\`\`\`
```

### 4.3. 리소스 추가

```
_tutorials/my-series/01-intro/
├── index.md
├── diagram.png       ← 이미지
├── teaser.png        ← 썸네일
├── example.py        ← 코드 파일
└── slides.pdf        ← 첨부 파일
```

### 4.4. 상대 경로 참조

```markdown
![다이어그램](diagram.png)
[예제 코드 다운로드](example.py)
```

---

## 5. 여러 Collections 사용

### 5.1. 확장 구조

```yaml
# _config.yml
collections:
  tutorials:
    output: true
    permalink: /:collection/:path/
  projects:
    output: true
    permalink: /:collection/:path/
  notes:
    output: true
    permalink: /:collection/:path/
```

### 5.2. 용도별 분리

| Collection | 용도 |
|------------|------|
| `_tutorials/` | 시리즈 연재 |
| `_projects/` | 프로젝트 소개 |
| `_notes/` | 짧은 메모 |
| `_posts/` | 단독 글 |

---

## 6. 시리즈 네비게이션

### 6.1. Include 생성

`_includes/series-nav.html`:

```html
{% raw %}{% if page.series %}
<div class="series-nav">
  <h4>📚 {{ page.series }}</h4>
  <ol>
  {% assign series_posts = site.[page.collection] | where: "series", page.series | sort: "series_order" %}
  {% for post in series_posts %}
    <li {% if post.url == page.url %}class="current"{% endif %}>
      <a href="{{ post.url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
  </ol>
</div>
{% endif %}{% endraw %}
```

### 6.2. 스타일 추가

```css
.series-nav {
  background: #f5f5f5;
  padding: 1rem;
  margin-bottom: 2rem;
  border-radius: 5px;
}
.series-nav .current {
  font-weight: bold;
}
```

---

## 7. 정리

| 파일 | 역할 |
|------|------|
| `_config.yml` | Collections 정의 |
| `_data/navigation.yml` | 사이드바 메뉴 |
| `_pages/tutorials.md` | 목록 페이지 |
| `_tutorials/*/index.md` | 실제 콘텐츠 |

**장점:**
- 포스트 + 리소스 = 한 폴더
- 시리즈 구조 직관적
- 이전/다음 네비게이션 쉬움

---

## 다음 단계

다음 글에서는 테마 커스터마이징을 다룬다.

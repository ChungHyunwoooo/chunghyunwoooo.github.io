---
title: "Jekyll 테마 커스터마이징"
permalink: /series/jekyll/05-customization/
date: 2026-02-06
excerpt: "minimal-mistakes 테마 스킨, 레이아웃, 스타일 수정"
categories:
  - Software
tags:
  - Jekyll
  - CSS
  - Customization
series: "Jekyll 블로그 마스터"
series_order: 5
---

minimal-mistakes 테마를 기준으로 Jekyll 블로그를 커스터마이징하는 방법을 다룬다.

---

## 1. 스킨 변경

### 1.1. 기본 제공 스킨

`_config.yml`:

```yaml
minimal_mistakes_skin: "dark"
```

**사용 가능한 스킨:**

| 스킨 | 설명 |
|------|------|
| `default` | 기본 흰색 |
| `air` | 밝은 파란색 |
| `aqua` | 청록색 |
| `contrast` | 고대비 |
| `dark` | 다크 모드 |
| `dirt` | 갈색 톤 |
| `neon` | 네온 느낌 |
| `mint` | 민트색 |
| `plum` | 자주색 |
| `sunrise` | 따뜻한 톤 |

---

## 2. CSS 오버라이드

### 2.1. 커스텀 CSS 파일 생성

`assets/css/main.scss`:

```scss
---
# Front matter 필수
---

@import "minimal-mistakes/skins/{{ site.minimal_mistakes_skin | default: 'default' }}";
@import "minimal-mistakes";

// 커스텀 스타일
.page__content {
  font-size: 1rem;
}

// 코드 블록 스타일
div.highlighter-rouge {
  margin: 1em 0;
}

// 링크 색상
a {
  color: #1e90ff;
  &:hover {
    color: #ff6347;
  }
}
```

---

### 2.2. 변수 오버라이드

`_sass/_variables.scss`:

```scss
// 폰트
$serif: Georgia, Times, serif;
$sans-serif: -apple-system, BlinkMacSystemFont, "Roboto", "Segoe UI", sans-serif;
$monospace: "Fira Code", Consolas, Monaco, monospace;

// 색상
$primary-color: #1e90ff;
$background-color: #1a1a2e;
$text-color: #e0e0e0;
$link-color: #00d9ff;

// 크기
$max-width: 1400px;
```

---

## 3. 폰트 변경

### 3.1. Google Fonts 추가

`_includes/head/custom.html`:

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700&family=Fira+Code&display=swap" rel="stylesheet">
```

### 3.2. CSS 적용

```scss
body {
  font-family: 'Noto Sans KR', sans-serif;
}

code, pre {
  font-family: 'Fira Code', monospace;
}
```

---

## 4. 레이아웃 수정

### 4.1. 레이아웃 오버라이드

테마 레이아웃을 수정하려면 복사 후 수정:

```bash
# 테마 위치 확인
bundle info minimal-mistakes-jekyll

# 필요한 파일 복사
cp /path/to/theme/_layouts/single.html _layouts/
```

### 4.2. 예: 포스트 하단에 시리즈 네비게이션 추가

`_layouts/single.html` 수정:

```html
{% raw %}<!-- 본문 끝 부분에 추가 -->
{% if page.series %}
  {% include series-nav.html %}
{% endif %}{% endraw %}
```

---

## 5. 사이드바 커스터마이징

### 5.1. 프로필 정보

`_config.yml`:

```yaml
author:
  name: "Hyunwoo"
  avatar: "/assets/images/bio-photo.jpg"
  bio: "HW/SW 공동설계 & AI/ML"
  location: "Korea"
  links:
    - label: "GitHub"
      icon: "fab fa-fw fa-github"
      url: "https://github.com/username"
    - label: "LinkedIn"
      icon: "fab fa-fw fa-linkedin"
      url: "https://linkedin.com/in/username"
```

### 5.2. 커스텀 사이드바

`_includes/sidebar.html` 오버라이드 또는 `_data/navigation.yml` 수정.

---

## 6. 네비게이션 메뉴

### 6.1. 상단 메뉴

`_data/navigation.yml`:

```yaml
main:
  - title: "Posts"
    url: /posts/
  - title: "Tutorials"
    url: /series/
  - title: "Categories"
    url: /categories/
  - title: "Tags"
    url: /tags/
  - title: "About"
    url: /about/
```

### 6.2. 드롭다운 메뉴

```yaml
main:
  - title: "Posts"
    url: /posts/
  - title: "Tutorials"
    url: /series/
    children:
      - title: "Jekyll"
        url: /series/jekyll/01-setup/
      - title: "SystemC"
        url: /series/systemc/01-install/
```

---

## 7. 댓글 시스템

### 7.1. Utterances (GitHub Issues 기반)

`_config.yml`:

```yaml
comments:
  provider: "utterances"
  utterances:
    theme: "github-dark"
    issue_term: "pathname"
    repo: "username/username.github.io"
```

### 7.2. Disqus

```yaml
comments:
  provider: "disqus"
  disqus:
    shortname: "your-disqus-shortname"
```

---

## 8. 검색 기능

### 8.1. 내장 검색

```yaml
search: true
search_full_content: true
```

### 8.2. Algolia 검색

```yaml
search: true
search_provider: algolia
algolia:
  application_id: YOUR_APP_ID
  index_name: YOUR_INDEX_NAME
  search_only_api_key: YOUR_API_KEY
```

---

## 9. SEO 최적화

### 9.1. 메타 태그

`_config.yml`:

```yaml
title: "Hyunwoo's Tech Blog"
description: "HW/SW 공동설계, AI/ML 개발 블로그"
url: "https://username.github.io"
twitter:
  username: "your_twitter"
og_image: "/assets/images/og-image.png"
```

### 9.2. 포스트별 SEO

```yaml
---
title: "포스트 제목"
excerpt: "검색 결과에 표시될 요약"
---
```

---

## 10. 애널리틱스

### 10.1. Google Analytics

```yaml
analytics:
  provider: "google-gtag"
  google:
    tracking_id: "G-XXXXXXXXXX"
    anonymize_ip: false
```

---

## 11. 유용한 커스터마이징 팁

### 11.1. 목차 스타일

```scss
.toc {
  background: #2d2d2d;
  border-radius: 8px;
  padding: 1rem;
}
```

### 11.2. 코드 블록 라인 넘버

```yaml
kramdown:
  syntax_highlighter_opts:
    block:
      line_numbers: true
```

### 11.3. 읽기 시간 한글화

`_includes/page__meta.html` 오버라이드:

```html
{% raw %}{% if document.read_time %}
  <span class="page__meta-readtime">
    <i class="far fa-clock"></i>
    약 {{ document.content | number_of_words | divided_by: 200 | plus: 1 }}분
  </span>
{% endif %}{% endraw %}
```

---

## 12. 정리

| 커스터마이징 | 파일 |
|-------------|------|
| 스킨 변경 | `_config.yml` |
| CSS 수정 | `assets/css/main.scss` |
| 변수 수정 | `_sass/_variables.scss` |
| 레이아웃 | `_layouts/*.html` |
| Include | `_includes/*.html` |
| 네비게이션 | `_data/navigation.yml` |
| 폰트 | `_includes/head/custom.html` |

---

## 시리즈 완료

이것으로 Jekyll 블로그 마스터 시리즈를 마친다.

1. [구축 - GitHub Pages 배포](/series/jekyll/01-setup/)
2. [폴더 구조 이해](/series/jekyll/02-structure/)
3. [포스트 작성법](/series/jekyll/03-posts/)
4. [Collections 시리즈 관리](/series/jekyll/04-collections/)
5. [테마 커스터마이징](/series/jekyll/05-customization/) ← 현재 글

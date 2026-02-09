---
title: "Jekyll 폴더 구조 이해하기"
permalink: /series/jekyll/02-structure/
date: 2026-02-06
excerpt: "용어부터 경로까지, Jekyll 디렉토리 구조를 읽는 기준을 만드는 글"
categories:
  - Software
tags:
  - Jekyll
  - Blog
series: "Jekyll 블로그 마스터"
series_order: 2
header:
  teaser: "https://jekyllrb-ko.github.io/img/logo-2x.png"
---

Jekyll을 오래 쓰려면 "어디를 고쳐야 결과가 바뀌는지"를 먼저 알아야 한다.  
이 글은 폴더 이름을 외우는 것이 아니라, 수정 지점을 찾는 기준을 만드는 데 집중한다.

---

## 이 글에서 해결하는 문제

- `_posts`, `_layouts`, `_includes` 역할이 헷갈리는 문제
- 수정했는데 화면이 안 바뀌는 문제
- 파일이 늘어날수록 구조가 무너지는 문제

---

## 먼저 용어 4개 정리

### 1) 소스 디렉토리

사람이 직접 수정하는 원본 파일 영역.

예시: `_posts/`, `_layouts/`, `assets/`

### 2) 빌드 산출물

Jekyll이 생성하는 결과물 영역.

예시: `_site/`

### 3) 레이아웃 (`_layouts`)

페이지 전체 뼈대 템플릿.

예시: 본문 위/아래 공통 header, footer.

### 4) 인클루드 (`_includes`)

반복되는 작은 조각 템플릿.

예시: 목차, 배너, 시리즈 내비게이션.

---

## 1. 먼저 전체 지도 보기

```text
my-blog/
├── _config.yml
├── _data/
├── _drafts/
├── _includes/
├── _layouts/
├── _posts/
├── _sass/
├── _site/
├── assets/
├── Gemfile
└── index.md
```

핵심만 기억하면 된다.

- "수정하는 곳": `_posts`, `_layouts`, `_includes`, `assets`, `_config.yml`
- "결과가 쌓이는 곳": `_site`

---

## 2. 자주 건드리는 폴더를 실무 기준으로 설명

### `_config.yml`

사이트 전역 설정 파일.

작은 예시:

```yaml
title: "My Blog"
url: "https://username.github.io"
baseurl: ""
theme: minimal-mistakes-jekyll
```

주의:

- `_config.yml` 수정 후에는 서버 재시작이 안전하다.

### `_posts/`

날짜 기반 일반 글 저장소.

작은 예시:

```text
_posts/2026-02-06-my-first-post.md
```

### `_layouts/`

페이지 전체 구조를 담당.

작은 예시:

- `single.html`을 고치면 여러 글의 공통 구조가 바뀐다.

### `_includes/`

재사용되는 조각 파일.

작은 예시:

```liquid
{% raw %}{% include toc.html %}{% endraw %}
```

### `_data/`

메뉴/설정 같은 정적 데이터를 분리.

작은 예시 (`_data/navigation.yml`):

```yaml
main:
  - title: "Posts"
    url: /posts/
```

### `assets/`

이미지/CSS/JS 보관 위치.

작은 예시:

```text
assets/images/logo.png
```

### `_site/`

빌드 결과물. 직접 수정하지 않는다.

---

## 3. "어디를 고치면 어디가 바뀌는지" 빠른 매핑

```text
_posts/2026-02-06-hello.md  -> _site/2026/02/06/hello/index.html
assets/images/logo.png      -> _site/assets/images/logo.png
_layouts/single.html        -> 여러 포스트의 공통 렌더링 결과
```

이 매핑을 알면 디버깅 속도가 크게 빨라진다.

---

## 4. 초보자가 자주 하는 실수

- `_config.yml` 수정 후 서버 재시작 누락
- `_site/`를 직접 수정
- 이미지 경로를 상대/절대 혼용

실전 규칙:

- 결과가 이상하면 `_site/`가 아닌 소스 파일을 찾는다.
- 경로 규칙을 팀 또는 개인 기준으로 하나로 통일한다.

---

## 5. 최종 체크리스트

- 핵심 폴더 역할을 설명할 수 있다.
- 수정 지점과 결과 지점을 구분할 수 있다.
- `_site/`를 손대지 않는 원칙을 지킨다.

다음 글에서는 실제 글 작성 규칙(Front Matter, Markdown, 이미지)을 같은 방식으로 정리한다.

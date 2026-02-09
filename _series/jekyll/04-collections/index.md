---
title: "Jekyll Collections로 시리즈 관리하기"
permalink: /series/jekyll/04-collections/
date: 2026-02-06
excerpt: "_posts를 넘어 연재형 문서를 구조적으로 관리하는 Collections 실전 가이드"
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

글이 늘어나면 가장 먼저 무너지는 것은 "순서"와 "리소스 위치"다.  
Collections는 이 문제를 해결하기 위한 Jekyll의 문서형 콘텐츠 기능이다.

---

## 이 글에서 해결하는 문제

- 연재 글 순서를 수동으로 관리하다 꼬이는 문제
- 글/이미지/첨부파일이 흩어지는 문제
- `_posts`만으로 문서형 구조를 만들기 어려운 문제

---

## 먼저 용어 3개 정리

### 1) `_posts`

날짜 기반 블로그 글 컬렉션(기본 제공).

작은 예시:

- 파일명에 날짜가 필수: `2026-02-06-title.md`

### 2) Collections

목적에 맞는 문서 묶음을 새로 정의하는 기능.

작은 예시:

- `series` 컬렉션을 만들어 연재 문서를 관리

### 3) `output: true`

컬렉션 문서를 실제 HTML로 빌드할지 결정하는 옵션.

작은 예시:

- `output: false`면 URL로 접근할 페이지가 생성되지 않음

---

## 1. `_posts`와 Collections를 언제 나눌까

| 상황 | `_posts` | Collections |
|------|----------|-------------|
| 날짜 중심 일상 글 | 적합 | 보통 불필요 |
| 순서가 중요한 튜토리얼 | 불편할 수 있음 | 적합 |
| 문서+리소스 묶음 관리 | 추가 규칙 필요 | 구조적으로 유리 |

간단 기준:

- "오늘 글"이면 `_posts`
- "문서 세트"면 Collections

---

## 2. `_config.yml` 설정

```yaml
collections:
  series:
    output: true
    permalink: /:collection/:path/

defaults:
  - scope:
      path: ""
      type: series
    values:
      layout: single
      toc: true
      toc_sticky: true
```

설명:

- `series` 컬렉션을 추가
- `output: true`로 페이지 생성 활성화
- `defaults`로 컬렉션 공통 옵션 통일

---

## 3. 권장 폴더 구조

```text
_series/
└── jekyll/
    ├── 01-setup/
    │   └── index.md
    ├── 02-structure/
    │   └── index.md
    └── 03-posts/
        ├── index.md
        └── screenshot.png
```

왜 좋은가:

- 문서와 리소스를 같은 위치에서 관리 가능
- 디렉토리 단위 이동/백업이 쉬움

---

## 4. 시리즈 내비게이션 구현

`_includes/series-nav.html`:

```liquid
{% raw %}{% if page.series and page.collection %}
  {% assign items = site[page.collection] | where: "series", page.series | sort: "series_order" %}
  <nav class="series-nav">
    <h4>{{ page.series }}</h4>
    <ol>
      {% for item in items %}
        <li>
          {% if item.url == page.url %}
            <strong>{{ item.title }}</strong>
          {% else %}
            <a href="{{ item.url }}">{{ item.title }}</a>
          {% endif %}
        </li>
      {% endfor %}
    </ol>
  </nav>
{% endif %}{% endraw %}
```

작은 핵심:

- `site[page.collection]` 문법으로 현재 컬렉션에 동적 접근
- `series_order` 숫자로 순서 고정

---

## 5. Front Matter 예시

```yaml
---
title: "Jekyll 블로그 구축 - GitHub Pages 배포"
permalink: /series/jekyll/01-setup/
series: "Jekyll 블로그 마스터"
series_order: 1
---
```

실무 규칙:

- `series_order` 중복 금지
- `permalink`를 명시해 링크 안정성 확보

---

## 6. 트러블슈팅

- 페이지가 생성되지 않음: `output: true` 확인
- 순서가 이상함: `series_order` 타입(숫자/문자열) 확인
- 링크가 404: `permalink`와 실제 경로 불일치 확인

---

## 7. 최종 체크리스트

- 컬렉션 설정이 `_config.yml`에 반영됨
- 문서/리소스 폴더 구조가 정해짐
- 시리즈 내비게이션이 동작함
- 글 순서가 안정적으로 유지됨

다음 글에서 테마 커스터마이징을 "업데이트 충돌을 줄이는 방식"으로 이어간다.

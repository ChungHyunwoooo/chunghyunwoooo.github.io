---
title: "Jekyll 테마 커스터마이징"
permalink: /series/jekyll/05-customization/
date: 2026-02-06
excerpt: "minimal-mistakes를 안전하게 확장하는 스킨, CSS, 레이아웃 수정 전략"
categories:
  - Software
tags:
  - Jekyll
  - CSS
  - Customization
series: "Jekyll 블로그 마스터"
series_order: 5
header:
  teaser: "https://jekyllrb-ko.github.io/img/logo-2x.png"
---

테마 커스터마이징의 핵심은 "많이 바꾸는 것"이 아니라 "안전하게 바꾸는 것"이다.  
이 글은 minimal-mistakes 기준으로 업데이트 충돌을 줄이면서 디자인을 바꾸는 방법을 정리한다.

---

## 이 글에서 해결하는 문제

- 테마 파일을 직접 수정했다가 업데이트 때 깨지는 문제
- CSS가 어디서 먹는지 몰라 반복 수정하는 문제
- 글 가독성을 높이고 싶은데 기준이 없는 문제

---

## 먼저 용어 3개 정리

### 1) 스킨 (skin)

기본 색상과 톤을 정하는 테마 프리셋.

작은 예시:

- `minimal_mistakes_skin: "air"`

### 2) 오버라이드 (override)

기존 규칙을 유지한 채, 필요한 부분만 덮어쓰는 방식.

작은 예시:

- 기본 `a` 스타일은 유지하고 `text-underline-offset`만 변경

### 3) 레이아웃 오버라이드

테마 레이아웃 파일 일부를 복사해 필요한 지점만 수정.

작은 예시:

- `_layouts/single.html`에 시리즈 내비게이션 include 추가

---

## 1. 가장 안전한 순서

1. 스킨 선택
2. CSS 오버라이드
3. 레이아웃 오버라이드

이 순서를 지키면 수정 범위가 단계적으로 늘어나 디버깅이 쉽다.

---

## 2. 스킨 먼저 고르기

`_config.yml`:

```yaml
minimal_mistakes_skin: "default"
```

선택 예시: `default`, `air`, `aqua`, `contrast`, `dark`, `mint`, `sunrise`

작은 팁:

- 스킨만 바꿔도 가독성 대부분이 해결될 수 있다.

---

## 3. CSS 오버라이드

`assets/css/main.scss`:

```scss
---
# Front matter required
---

@import "minimal-mistakes/skins/{{ site.minimal_mistakes_skin | default: 'default' }}";
@import "minimal-mistakes";

.page__content {
  font-size: 1rem;
  line-height: 1.8;
}

a {
  text-underline-offset: 2px;
}
```

중요 포인트:

- 상단 Front Matter가 없으면 SCSS 처리 안 됨
- 커스텀 규칙은 import 아래에 작성

---

## 4. 폰트 적용 (가독성의 체감이 큼)

`_includes/head/custom.html`:

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700&family=Fira+Code:wght@400;500&display=swap" rel="stylesheet">
```

`assets/css/main.scss`:

```scss
body {
  font-family: "Noto Sans KR", sans-serif;
}

code,
pre {
  font-family: "Fira Code", monospace;
}
```

---

## 5. 레이아웃 오버라이드 원칙

원칙:

- 필요한 파일만 복사
- 원본 전체 복제 금지

작은 예시 (`_layouts/single.html`):

```liquid
{% raw %}{% if page.series %}
  {% include series-nav.html %}
{% endif %}{% endraw %}
```

---

## 6. 운영 기능 연결

### 네비게이션 데이터

`_data/navigation.yml`:

```yaml
main:
  - title: "Posts"
    url: /posts/
  - title: "Series"
    url: /series/
  - title: "About"
    url: /about/
```

### 검색/댓글/분석

`_config.yml` 예시:

```yaml
search: true
search_full_content: true

comments:
  provider: "utterances"
  utterances:
    repo: "username/username.github.io"
    issue_term: "pathname"
    theme: "github-light"

analytics:
  provider: "google-gtag"
  google:
    tracking_id: "G-XXXXXXXXXX"
```

---

## 7. 트러블슈팅

- CSS 변경이 반영되지 않음: `main.scss` Front Matter 확인
- 레이아웃 적용이 안 됨: Front Matter의 `layout` 값 확인
- 모바일 깨짐: 본문 폭/폰트 크기/코드 블록 overflow 확인

---

## 8. 최종 체크리스트

- 스킨 선택 완료
- CSS 오버라이드 최소 범위로 반영
- 레이아웃 오버라이드 파일 최소화
- 모바일/데스크톱에서 가독성 확인

다음 글에서 검색 노출(Google) 설정을 같은 방식으로 끝낸다.

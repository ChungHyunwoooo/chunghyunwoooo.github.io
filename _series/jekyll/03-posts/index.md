---
title: "Jekyll 포스트 작성법"
permalink: /series/jekyll/03-posts/
date: 2026-02-06
excerpt: "Front Matter와 Markdown을 쉽게, 하지만 실무 기준으로 정리한 포스트 작성 가이드"
categories:
  - Software
tags:
  - Jekyll
  - Markdown
  - Blog
series: "Jekyll 블로그 마스터"
series_order: 3
header:
  teaser: "https://jekyllrb-ko.github.io/img/logo-2x.png"
---

글을 쓰는 속도보다 중요한 것은 "나중에도 읽히는 형식"이다.  
이 글은 Jekyll 포스트를 일관되게 작성하는 최소 규칙을 설명하고, 바로 복붙 가능한 템플릿까지 제공한다.

---

## 이 글에서 해결하는 문제

- Front Matter 항목이 매번 달라지는 문제
- 이미지/코드 블록 형식이 글마다 달라지는 문제
- 시간이 지나면 본인이 다시 읽기 어려워지는 문제

---

## 먼저 용어 3개 정리

### 1) Front Matter

문서 맨 위의 YAML 메타데이터 블록.

작은 예시:

```yaml
---
title: "포스트 제목"
date: 2026-02-06
---
```

### 2) 슬러그 (slug)

URL에 쓰이는 짧고 읽기 쉬운 문자열.

작은 예시:

- 파일명 `2026-02-06-jekyll-post-guide.md`
- URL 일부 `.../jekyll-post-guide/`

### 3) 초안 (draft)

공개 전 문서.

작은 예시:

- `_drafts/upcoming-post.md`
- `bundle exec jekyll serve --drafts`

---

## 1. 파일명 규칙부터 고정

```bash
touch _posts/2026-02-06-my-post-title.md
```

규칙:

- 형식: `YYYY-MM-DD-title.md`
- 공백 대신 `-`
- 소문자 영문 권장

왜 필요한가:

- URL 안정성이 좋아진다.
- 검색엔진/공유 링크 가독성이 좋아진다.

---

## 2. 바로 쓰는 Front Matter 템플릿

```yaml
---
title: "포스트 제목"
date: 2026-02-06 14:30:00 +0900
last_modified_at: 2026-02-07
categories:
  - Software
tags:
  - Jekyll
  - Tutorial
excerpt: "검색 결과와 목록에 보일 요약"
toc: true
published: true
---
```

핵심 설명:

- `title`: 문서 제목
- `date`: 발행 시각
- `excerpt`: 목록/검색 요약
- `published`: 공개 여부

작은 규칙:

- `excerpt`는 1~2문장으로 "이 글로 해결되는 문제"를 써라.

---

## 3. Markdown 작성 기준

### 제목 계층

본문은 H2(`##`)부터 시작하고, 하위는 H3(`###`)로 내린다.

```markdown
## 큰 주제
### 하위 주제
```

### 코드 블록

언어 태그를 넣는다.

````markdown
```bash
bundle exec jekyll serve
```
````

### 링크

```markdown
[외부 링크](https://jekyllrb.com)
[내부 링크](/series/jekyll/02-structure/)
```

---

## 4. 이미지 관리 규칙

권장 구조:

```text
assets/images/posts/
└── 2026-02-06-my-post/
    ├── cover.png
    └── result.png
```

본문 사용:

```markdown
![결과 화면](/assets/images/posts/2026-02-06-my-post/result.png)
```

핵심:

- 파일명은 소문자 + 하이픈
- `alt`에는 "무엇이 보이는지"를 짧게 작성

---

## 5. 초안 운영 방식 2가지

### 방식 A: `_drafts`

```bash
bundle exec jekyll serve --drafts
```

### 방식 B: `published: false`

```yaml
---
title: "작성 중"
published: false
---
```

실무 팁:

- 팀 협업이면 `published: false`가 리뷰 흐름에 유리하다.

---

## 6. 발행 전 체크리스트

- 제목 계층이 논리적으로 내려가는가
- 코드 블록에 언어 태그가 있는가
- 이미지 경로와 alt 텍스트가 맞는가
- 내부 링크가 끊기지 않았는가
- `excerpt`가 글 핵심을 설명하는가

이 기준만 지켜도 글의 가독성과 유지보수성이 눈에 띄게 올라간다. 다음 글에서 연재형 콘텐츠를 위한 Collections를 연결한다.

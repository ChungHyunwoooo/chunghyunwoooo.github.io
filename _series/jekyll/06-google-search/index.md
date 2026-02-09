---
title: "Jekyll 블로그 Google 검색 노출시키기"
permalink: /series/jekyll/06-google-search/
date: 2026-02-06
excerpt: "Search Console 등록부터 sitemap 제출, 색인 점검까지 한 번에 끝내는 가이드"
categories:
  - Software
tags:
  - Jekyll
  - SEO
  - Google
series: "Jekyll 블로그 마스터"
series_order: 6
header:
  teaser: "https://jekyllrb-ko.github.io/img/logo-2x.png"
---

배포는 끝났는데 검색에 안 잡히는 경우가 많다.  
이 글은 Google Search Console에서 인증, 사이트맵 제출, 색인 확인까지 필요한 절차만 정리한다.

---

## 이 글에서 해결하는 문제

- 구글에서 `site:도메인` 검색 결과가 거의 없는 문제
- Search Console 인증 단계에서 멈추는 문제
- sitemap 제출 후에도 색인이 느린 문제

---

## 먼저 용어 3개 정리

### 1) Search Console

Google이 사이트 색인 상태를 보여주는 관리 도구.

작은 예시:

- URL 검사로 "이 페이지가 색인됐는지" 즉시 확인 가능

### 2) 사이트맵 (`sitemap.xml`)

검색엔진에 "우리 사이트 URL 목록"을 제공하는 파일.

작은 예시:

- `https://username.github.io/sitemap.xml`

### 3) 색인 (indexing)

크롤링한 페이지를 검색 DB에 등록하는 과정.

작은 예시:

- 페이지는 열리지만 검색 결과에 안 보이면 "배포 완료, 색인 미완료" 상태

---

## 1. Search Console 속성 등록

1. [Google Search Console](https://search.google.com/search-console/about) 접속
2. `URL 접두어` 선택
3. 블로그 URL 입력: `https://username.github.io`

처음에는 `URL 접두어`가 단순하고 실수 확률이 낮다.

---

## 2. 소유권 인증

Search Console이 제공하는 태그 예시:

```html
<meta name="google-site-verification" content="고유코드" />
```

`content` 값만 `_config.yml`에 추가:

```yaml
google_site_verification: "고유코드"
```

배포:

```bash
git add _config.yml
git commit -m "Add Google site verification"
git push
```

배포 후 Search Console에서 `확인` 클릭.

---

## 3. 사이트맵 생성 확인

`Gemfile`:

```ruby
group :jekyll_plugins do
  gem "jekyll-sitemap"
end
```

`_config.yml`:

```yaml
plugins:
  - jekyll-sitemap
```

로컬 점검:

```bash
bundle exec jekyll serve
# http://localhost:4000/sitemap.xml
```

핵심:

- `_config.yml`의 `url` 값이 실제 도메인과 같아야 한다.

---

## 4. Search Console에 Sitemap 제출

1. 좌측 `Sitemaps`
2. `sitemap.xml` 입력
3. 상태가 `성공`인지 확인

문제 발생 시 우선 점검:

- sitemap URL 오타
- 빌드/배포 실패
- `url` 설정 불일치

---

## 5. 색인 확인 루틴

### URL 검사

대표 URL 입력:

```text
https://username.github.io/
```

### `site:` 검색

```text
site:username.github.io
```

참고:

- 신규 사이트는 보통 며칠~1,2주까지 시간이 걸릴 수 있다.

---

## 6. 실무 팁

- 새 글 발행 후 `URL 검사`에서 색인 요청
- 글 제목/요약(excerpt)을 명확히 작성
- 시리즈 내부 링크를 넣어 크롤링 동선 강화

---

## 7. 최종 체크리스트

- 소유권 인증 완료
- sitemap 제출 완료
- 주요 URL 색인 상태 확인
- 내부 링크/메타 정보 점검

다음 글에서는 Naver Search Advisor에 같은 방식으로 연결한다.

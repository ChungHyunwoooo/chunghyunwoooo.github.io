---
title: "Jekyll에서 robots.txt 이해하고 추가하기"
permalink: /series/jekyll/08-robots-txt/
date: 2026-02-06
excerpt: "robots.txt 문법을 쉽게 설명하고, Jekyll에 안전하게 적용하는 실전 가이드"
categories:
  - Software
tags:
  - Jekyll
  - SEO
  - robots.txt
series: "Jekyll 블로그 마스터"
series_order: 8
header:
  teaser: "https://jekyllrb-ko.github.io/img/logo-2x.png"
---

`robots.txt`는 어렵지 않지만, 한 줄 실수로 전체 크롤링이 막힐 수 있다.  
이 글은 꼭 필요한 문법만 설명하고 Jekyll에 안전하게 적용하는 방법을 정리한다.

---

## 이 글에서 해결하는 문제

- 검색엔진이 어떤 페이지를 읽게 할지 제어하고 싶은 문제
- `robots.txt`와 `sitemap.xml`의 관계가 헷갈리는 문제
- 차단 규칙 실수로 노출이 사라질까 걱정되는 문제

---

## 먼저 용어 4개 정리

### 1) `robots.txt`

사이트 루트에 두는 크롤러 안내 파일.

작은 예시:

- `https://username.github.io/robots.txt`

### 2) `User-agent`

규칙을 적용할 크롤러 대상.

작은 예시:

- `User-agent: *`는 모든 크롤러

### 3) `Allow` / `Disallow`

허용/차단 경로 규칙.

작은 예시:

- `Disallow: /tmp/`는 `/tmp/` 이하 수집 제한

### 4) `Sitemap`

사이트맵 위치를 알려주는 힌트.

작은 예시:

- `Sitemap: https://username.github.io/sitemap.xml`

---

## 1. 처음에는 이 기본안으로 시작

```text
User-agent: *
Allow: /
Sitemap: https://username.github.io/sitemap.xml
```

이 설정은 "전체 허용 + 사이트맵 위치 안내"라는 가장 안전한 시작점이다.

---

## 2. Jekyll에 파일 추가

프로젝트 루트(`_config.yml`과 같은 위치)에 `robots.txt` 생성:

```bash
cat > robots.txt <<'TXT'
User-agent: *
Allow: /
Sitemap: https://username.github.io/sitemap.xml
TXT
```

배포 후 확인:

```text
https://username.github.io/robots.txt
```

---

## 3. 자주 쓰는 확장 패턴

### 특정 경로 차단

```text
User-agent: *
Disallow: /tmp/
Disallow: /private/
Allow: /
Sitemap: https://username.github.io/sitemap.xml
```

### 특정 봇 차단

```text
User-agent: *
Allow: /

User-agent: BadBot
Disallow: /
```

---

## 4. 꼭 알아야 할 주의점

- `Disallow: /`는 전체 차단이다.
- CSS/JS를 막으면 검색엔진 렌더링 품질이 떨어질 수 있다.
- `robots.txt`는 보안 도구가 아니다(민감정보 보호 불가).

---

## 5. 문제 발생 시 점검 순서

1. `robots.txt`가 200으로 열리는지
2. `Sitemap` URL이 실제 주소인지
3. Search Console/Search Advisor에서 차단 경고가 있는지
4. 의도치 않은 `Disallow` 규칙이 있는지

---

## 6. 시리즈 전체 복습

1. [구축 - GitHub Pages 배포](/series/jekyll/01-setup/)
2. [폴더 구조 이해](/series/jekyll/02-structure/)
3. [포스트 작성법](/series/jekyll/03-posts/)
4. [Collections 시리즈 관리](/series/jekyll/04-collections/)
5. [테마 커스터마이징](/series/jekyll/05-customization/)
6. [Google 검색 노출](/series/jekyll/06-google-search/)
7. [Naver 검색 연동](/series/jekyll/07-naver-search/)
8. [robots.txt 이해와 적용](/series/jekyll/08-robots-txt/)

이제 이 시리즈만 순서대로 읽어도 "만들기 -> 쓰기 -> 꾸미기 -> 검색 노출"까지 이어서 해결할 수 있는 상태가 된다.

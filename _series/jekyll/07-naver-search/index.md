---
title: "Jekyll 블로그 Naver 검색 연동하기"
permalink: /series/jekyll/07-naver-search/
date: 2026-02-06
excerpt: "Naver Search Advisor 등록, 인증, sitemap 제출, 수집 확인까지 정리"
categories:
  - Software
tags:
  - Jekyll
  - SEO
  - Naver
series: "Jekyll 블로그 마스터"
series_order: 7
header:
  teaser: "https://jekyllrb-ko.github.io/img/logo-2x.png"
---

한국어 검색 유입을 고려하면 Google만 설정하고 끝내기 어렵다.  
이 글은 Naver Search Advisor에서 필요한 설정을 빠르게 끝내고, 실제 수집 상태를 확인하는 방법까지 다룬다.

---

## 이 글에서 해결하는 문제

- 네이버 검색 유입이 거의 없는 문제
- 인증 메타 태그를 어디에 넣어야 할지 헷갈리는 문제
- sitemap 제출 이후 무엇을 확인해야 할지 모르는 문제

---

## 먼저 용어 3개 정리

### 1) Naver Search Advisor

네이버 검색 노출을 위한 사이트 관리 도구.

작은 예시:

- 사이트 등록 후 수집 상태 리포트 확인 가능

### 2) 사이트 인증

해당 도메인의 소유자임을 증명하는 절차.

작은 예시:

- `<meta name="naver-site-verification" ...>` 코드 값 등록

### 3) 수집

네이버 크롤러가 페이지를 읽어가는 단계.

작은 예시:

- 수집 성공이어도 노출은 품질/시간에 따라 지연될 수 있음

---

## 1. 사이트 등록

1. [Naver Search Advisor](https://searchadvisor.naver.com/) 접속
2. 네이버 계정 로그인
3. 사이트 등록에 URL 입력: `https://username.github.io`

주의:

- `http`/`https`를 혼동하지 않는다.

---

## 2. 소유권 인증

제공되는 태그 예시:

```html
<meta name="naver-site-verification" content="고유코드" />
```

`content` 값만 `_config.yml`에 추가:

```yaml
naver_site_verification: "고유코드"
```

배포 후 Search Advisor에서 인증 완료 확인.

---

## 3. Sitemap 제출

제출 URL:

```text
https://username.github.io/sitemap.xml
```

전제:

- `jekyll-sitemap` 플러그인이 활성화되어 있어야 함

작은 점검:

- 브라우저에서 sitemap URL을 직접 열어 200 응답 확인

---

## 4. 수집 상태 확인 루틴

- 홈/시리즈/대표 글 URL을 우선 확인
- 리포트에서 수집 실패 URL을 모아 원인별로 정리
- 제목/요약(excerpt)/내부 링크를 함께 점검

---

## 5. 자주 막히는 포인트

- 등록 URL과 실제 사이트 URL이 다름
- 인증 코드 배포 전에 확인 버튼부터 누름
- sitemap URL 오타 또는 미생성

---

## 6. 최종 체크리스트

- 사이트 등록 완료
- 소유권 인증 완료
- sitemap 제출 완료
- 대표 URL 수집 상태 확인

이 단계까지 완료하면 네이버 검색 기반 설정은 마무리다. 다음 글에서 크롤링 정책(`robots.txt`)을 연결한다.

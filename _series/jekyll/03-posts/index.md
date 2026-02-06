---
title: "Jekyll 포스트 작성법"
permalink: /series/jekyll/03-posts/
date: 2026-02-06
excerpt: "Markdown 문법, Front Matter, 이미지 삽입"
categories:
  - Software
tags:
  - Jekyll
  - Markdown
  - Blog
series: "Jekyll 블로그 마스터"
series_order: 3
---

Jekyll에서 블로그 포스트를 작성하는 방법을 다룬다.

---

## 1. 포스트 생성

### 1.1. 파일 생성

```bash
touch _posts/2026-02-06-my-post-title.md
```

**파일명 규칙:**
- `YYYY-MM-DD-제목.md`
- 공백 대신 하이픈(`-`) 사용
- 영문 소문자 권장

---

### 1.2. Front Matter

모든 포스트는 YAML 헤더로 시작:

```yaml
---
title: "포스트 제목"
date: 2026-02-06 14:30:00 +0900
last_modified_at: 2026-02-07
categories:
  - Tech
  - Tutorial
tags:
  - Jekyll
  - Markdown
excerpt: "이 포스트의 요약문"
toc: true
toc_sticky: true
toc_label: "목차"
---
```

**주요 속성:**

| 속성 | 설명 | 필수 |
|------|------|------|
| `title` | 포스트 제목 | ✅ |
| `date` | 작성일 | ✅ |
| `categories` | 카테고리 | 선택 |
| `tags` | 태그 | 선택 |
| `excerpt` | 요약문 | 선택 |
| `toc` | 목차 표시 | 선택 |
| `published` | false면 비공개 | 선택 |

---

## 2. Markdown 문법

### 2.1. 제목

```markdown
## 대제목 (H2)
### 중제목 (H3)
#### 소제목 (H4)
```

> H1은 포스트 제목으로 자동 생성되므로 본문에서는 H2부터 사용.

---

### 2.2. 텍스트 스타일

```markdown
**굵게**
*기울임*
~~취소선~~
`인라인 코드`
```

결과: **굵게**, *기울임*, ~~취소선~~, `인라인 코드`

---

### 2.3. 목록

```markdown
- 순서 없는 목록
- 항목 2
  - 하위 항목

1. 순서 있는 목록
2. 항목 2
```

---

### 2.4. 링크

```markdown
[링크 텍스트](https://example.com)
[내부 링크]({% raw %}{{ site.baseurl }}{% endraw %}/about/)
```

---

### 2.5. 이미지

```markdown
![대체 텍스트](/assets/images/photo.jpg)
![대체 텍스트](./local-image.png)
```

**캡션 추가 (minimal-mistakes):**
```markdown
{% raw %}{% include figure image_path="/assets/images/photo.jpg" alt="설명" caption="이미지 캡션" %}{% endraw %}
```

---

### 2.6. 코드 블록

````markdown
```python
def hello():
    print("Hello, World!")
```
````

**결과:**
```python
def hello():
    print("Hello, World!")
```

**지원 언어:** python, javascript, bash, cpp, yaml, json, markdown 등

---

### 2.7. 인용문

```markdown
> 인용문입니다.
> 여러 줄도 가능합니다.
```

> 인용문입니다.
> 여러 줄도 가능합니다.

---

### 2.8. 테이블

```markdown
| 헤더1 | 헤더2 | 헤더3 |
|-------|-------|-------|
| 값1   | 값2   | 값3   |
| 값4   | 값5   | 값6   |
```

| 헤더1 | 헤더2 | 헤더3 |
|-------|-------|-------|
| 값1   | 값2   | 값3   |
| 값4   | 값5   | 값6   |

---

### 2.9. 수평선

```markdown
---
```

---

## 3. 이미지 관리

### 3.1. 기본 방식 (assets 폴더)

```
assets/images/posts/
└── 2026-02-06-my-post/
    ├── screenshot1.png
    └── diagram.png
```

```markdown
![스크린샷](/assets/images/posts/2026-02-06-my-post/screenshot1.png)
```

### 3.2. 이미지 크기 조절

```html
<img src="/assets/images/photo.jpg" width="500">
```

또는 (minimal-mistakes):
```markdown
{% raw %}{% include figure image_path="/assets/images/photo.jpg" alt="설명" class="half" %}{% endraw %}
```

---

## 4. 특수 기능

### 4.1. 알림 박스 (Notice)

```markdown
**주의:** 이것은 경고입니다.
{: .notice--warning}

**정보:** 이것은 정보입니다.
{: .notice--info}

**성공:** 이것은 성공입니다.
{: .notice--success}

**위험:** 이것은 위험입니다.
{: .notice--danger}
```

---

### 4.2. 버튼

```markdown
[버튼 텍스트](https://example.com){: .btn .btn--primary}
[큰 버튼](https://example.com){: .btn .btn--large}
```

---

### 4.3. 접기 (Details)

```html
<details>
<summary>클릭하여 펼치기</summary>

숨겨진 내용입니다.

</details>
```

---

### 4.4. YouTube 삽입

```markdown
{% raw %}{% include video id="VIDEO_ID" provider="youtube" %}{% endraw %}
```

---

## 5. 초안 작성

### 5.1. `_drafts/` 사용

```
_drafts/
└── upcoming-post.md    # 날짜 없이
```

### 5.2. 로컬 확인

```bash
bundle exec jekyll serve --drafts
```

### 5.3. 또는 `published: false`

```yaml
---
title: "작업 중인 포스트"
published: false
---
```

---

## 6. 카테고리 & 태그 전략

### 권장 구조

| 구분 | 용도 | 예시 |
|------|------|------|
| 카테고리 | 대분류 (2-3개) | Hardware, Software, AI-ML |
| 태그 | 세부 주제 (다수) | Jekyll, Python, SystemC |

```yaml
categories:
  - Software
tags:
  - Jekyll
  - Tutorial
  - Markdown
```

---

## 다음 단계

다음 글에서는 Collections를 활용한 시리즈 관리를 다룬다.

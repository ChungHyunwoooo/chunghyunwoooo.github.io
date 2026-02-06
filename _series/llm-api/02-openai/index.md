---
title: "OpenAI API (Python) 연동 및 환경 설정 가이드"
permalink: /series/llm-api/02-openai/
date: 2026-01-28
excerpt: "Python에서 OpenAI API 설정 및 사용법"
categories:
  - AI-ML
tags:
  - OpenAI
  - GPT-4
  - Python
series: "LLM API 셋업"
series_order: 2
mermaid: true
---

Python 애플리케이션에서 **OpenAI API**를 연동하는 방법을 정리한다.

최신 라이브러리(`openai >= 1.0.0`)를 기준으로 **API 키 발급, 환경 설정, API 호출(Chat Completion)** 과정을 다룬다.

---
permalink: /articles/setup-openai-api/

## 1. 사전 준비 (Prerequisites)

-   **Python 3.7.1** 이상 (3.10+ 권장)
-   OpenAI 계정

---

## 2. OpenAI API Key 발급

API 사용을 위한 인증 키를 발급받는다.

1.  [OpenAI Platform](https://platform.openai.com/) 접속 및 로그인
2.  좌측 메뉴의 **API Keys** 이동
3.  **Create new secret key** 클릭
    *   Name: 키 이름 입력 (예: `MyDevKey`)
    *   Permissions: 기본값 권장
4.  생성된 키(`sk-...`)를 복사하여 보관

---
permalink: /articles/setup-openai-api/

## 3. 라이브러리 설치

OpenAI Python 클라이언트를 설치한다.
(1.0.0 버전 이후 문법 변경 사항 반영)

```bash
pip install --upgrade openai
```

설치 확인:
```bash
pip show openai
```

---

## 4. 환경 변수 설정 (보안 필수)

API 키를 환경 변수로 등록하여 사용한다.

### Mac/Linux (zsh/bash)
터미널 입력:

```bash
export OPENAI_API_KEY="sk-..."
```

### Windows (PowerShell)

```powershell
$Env:OPENAI_API_KEY = "sk-..."
```

---
permalink: /articles/setup-openai-api/

## 5. Python 코드 작성 (Chat Completion)

Chat Completion API 호출 예제다.
1.x 버전부터는 `OpenAI()` 클라이언트 인스턴스를 사용한다.

### `openai_test.py`

```python
import os
from openai import OpenAI

# 1. 클라이언트 초기화
# 환경 변수 OPENAI_API_KEY가 설정되어 있다면 api_key 인자 생략 가능
client = OpenAI(
    # api_key=os.environ.get("OPENAI_API_KEY"),
)

# 2. API 호출
try:
    response = client.chat.completions.create(
        model="gpt-4o",  # 또는 "gpt-3.5-turbo"
        messages=[
            {"role": "system", "content": "너는 도움이 되는 AI 어시스턴트야."},
            {"role": "user", "content": "Python으로 OpenAI API 연동하는 법을 한 줄로 요약해줘."},
        ],
        max_tokens=100,  # 응답 최대 길이 제한
        temperature=0.7, # 창의성 조절 (0~1)
    )

    # 3. 결과 출력
    print(response.choices[0].message.content)

except Exception as e:
    print(f"Error 발생: {e}")
```

---

## 6. 실행 및 결과 확인

```bash
python openai_test.py
```

**정상 출력 예시:**
> `openai` 라이브러리를 설치하고 API 키를 설정한 뒤 `client.chat.completions.create` 메서드를 호출하면 됩니다.

---
permalink: /articles/setup-openai-api/

## 7. 트러블슈팅

### `RateLimitError`
*   원인: 크레딧 부족 또는 결제 카드 미등록.
*   해결: [Billing 설정](https://platform.openai.com/account/billing/overview)에서 결제 수단 등록 및 크레딧 충전.

### `ModuleNotFoundError: No module named 'openai'`
*   원인: 라이브러리 미설치 또는 가상환경 문제.
*   해결: `pip install openai` 실행 및 가상환경 활성화 확인.

연동 설정이 완료되었다.

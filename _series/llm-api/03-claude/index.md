---
title: "Anthropic Claude API (Python) 연동 및 환경 설정 가이드"
permalink: /series/llm-api/03-claude/
date: 2026-01-29
excerpt: "Python에서 Claude API 설정 및 사용법"
categories:
  - AI-ML
tags:
  - Anthropic
  - Claude
  - Python
series: "LLM API 셋업"
series_order: 3
mermaid: true
---

Python 환경에서 **Anthropic API**를 사용하여 Claude 모델을 호출하는 방법을 정리한다.
API 키 발급, 라이브러리 설치, 코드 작성 순서로 진행한다.

---
permalink: /articles/setup-claude-api/

## 1. 사전 준비 (Prerequisites)

-   **Python 3.7+**
-   Anthropic Console 계정

---

## 2. API Key 발급

1.  [Anthropic Console](https://console.anthropic.com/)에 접속한다.
2.  로그인 후 대시보드에서 **Get API Keys**를 클릭한다.
3.  **Create Key** 버튼을 눌러 키(`sk-ant-...`)를 생성하고 복사한다.
4.  **Billing** 메뉴에서 크레딧 충전이 필요하다.

---
permalink: /articles/setup-claude-api/

## 3. 라이브러리 설치

Anthropic 공식 Python SDK를 설치한다.

```bash
pip install anthropic
```

---

## 4. 환경 변수 설정

API 키를 환경 변수로 등록한다.

### Mac/Linux

```bash
export ANTHROPIC_API_KEY="sk-ant-api03-..."
```

---
permalink: /articles/setup-claude-api/

## 5. Python 코드 작성 (Message API)

Claude 3 이상에서는 `Messages API`를 사용한다.

### `claude_test.py`

```python
import os
import anthropic

# 1. 클라이언트 초기화
# 환경 변수 ANTHROPIC_API_KEY를 자동으로 감지함
client = anthropic.Anthropic(
    # api_key="my_api_key", # 환경 변수 미사용 시 직접 입력
)

# 2. 메시지 생성 요청
try:
    message = client.messages.create(
        model="claude-3-5-sonnet-20240620", # 사용 시점의 최신 모델 확인 필요
        max_tokens=1000,
        temperature=0, # 0에 가까울수록 결정론적(일관된) 답변
        system="당신은 간결하고 정확하게 답변하는 기술 전문가입니다.",
        messages=[
            {
                "role": "user",
                "content": "Claude API를 처음 사용하는 개발자에게 해줄 조언 3가지만 알려줘."
            }
        ]
    )

    # 3. 응답 출력
    # 응답 객체 구조: message.content 리스트 안에 TextBlock이 들어있음
    print(message.content[0].text)

except anthropic.APIError as e:
    print(f"API 에러 발생: {e}")
```

---

## 6. 실행 및 결과 확인

```bash
python claude_test.py
```

**출력 예시:**
> 1.  **모델 선택**: 작업의 난이도와 속도 요구사항에 따라 Haiku(빠름), Sonnet(균형), Opus(고성능) 중 적절한 모델을 선택하세요.
> 2.  **시스템 프롬프트 활용**: `system` 파라미터를 사용하여 Claude의 페르소나와 응답 형식을 명확히 지정하면 더 좋은 결과를 얻을 수 있습니다.
> 3.  **토큰 관리**: 긴 문맥을 처리할 수 있지만 비용 효율성을 위해 불필요한 입력은 줄이는 것이 좋습니다.

---
permalink: /articles/setup-claude-api/

## 7. 주요 모델명 참고 (2026년 기준)

`model` 파라미터에 들어갈 모델명이다.

*   **Claude 3.5 Sonnet**: `claude-3-5-sonnet-20240620`
*   **Claude 3 Opus**: `claude-3-opus-20240229`
*   **Claude 3 Haiku**: `claude-3-haiku-20240307`

최신 모델 ID는 [공식 문서](https://docs.anthropic.com/en/docs/models-overview)를 확인한다.

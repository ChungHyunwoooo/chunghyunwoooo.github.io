---
title: "Google Gemini API 연동"
permalink: /series/llm-api/01-gemini/
date: 2026-01-27
excerpt: "Python에서 Gemini API 설정 및 사용법"
series: "LLM API 셋업"
series_order: 1
categories:
  - AI-ML
tags:
  - Gemini
  - LLM
  - Python
series: "LLM API 셋업"
series_order: 1
---

Google Gemini API를 Python에서 연동하는 방법을 정리합니다.

## 1. API Key 발급

1. [Google AI Studio](https://aistudio.google.com/) 접속
2. **Get API key** → **Create API key** 클릭
3. 발급된 키 복사

## 2. 라이브러리 설치

```bash
pip install -q -U google-generativeai
```

## 3. 예제 코드

```python
import os
import google.generativeai as genai

genai.configure(api_key=os.environ["GOOGLE_API_KEY"])
model = genai.GenerativeModel('gemini-1.5-flash')

response = model.generate_content("인공지능의 미래를 한 문장으로 요약해줘.")
print(response.text)
```

## 다음 단계

다음 글에서는 OpenAI API 연동을 다룹니다.

---
title: "Llama 모델 세팅 - 선택부터 서빙까지"
permalink: /series/on-prem-llm/04-llama-setup/
date: 2026-02-06
excerpt: "Llama 모델 선택, 다운로드, Ollama/vLLM으로 프로덕션 배포하기"
categories:
  - AI-ML
tags:
  - Llama
  - Ollama
  - vLLM
  - Model Serving
series: "온프레미스 LLM 구축"
series_order: 4
---

## 소개

드디어 모델을 올려봅니다. `ollama pull llama3.1` 한 줄이면 끝... 이라고 하고 싶지만, 프로덕션 수준으로 세팅하려면 할 게 꽤 많습니다.

모델이 너무 많아서 뭘 골라야 할지 모르겠다는 분들, Ollama랑 vLLM이 뭐가 다른지 궁금한 분들을 위한 회차입니다.

---

## 모델 선택 가이드

### Llama 패밀리

- **Llama 3.1**: 8B / 70B / 405B. 가장 범용적, 한국어도 괜찮음
- **Llama 3.2**: 1B / 3B. 경량 모델, 엣지/모바일용
- **Llama 3.3**: 70B. 최신, 성능 개선

### 경쟁 모델 (같이 비교해야 합니다)

- **Mistral 7B / 8x7B MoE**: 유럽산, 작은 사이즈 대비 성능 좋음. 한국어는 좀 약함
- **Qwen2.5 72B**: 중국어/한국어 강점. 한국어 특화라면 의외로 이게 답
- **DeepSeek-V2/V3**: 코딩 특화 모델도 있음. MoE 구조로 효율적
- **Gemma 2**: Google 오픈소스. 9B/27B

### 어떤 모델을 고를까?

- 간단한 Q&A, 요약 → **8B면 충분**
- 코드 생성 → **DeepSeek-Coder, CodeLlama**
- 한국어 특화 → **Qwen2.5**가 의외로 좋음
- 복잡한 추론, 멀티스텝 → **70B급** 필요

## Ollama vs vLLM

| 항목 | Ollama | vLLM |
|------|--------|------|
| 설치 난이도 | 매우 쉬움 | 중간~어려움 |
| 동시 처리 | 약함 (5명 이상이면 느림) | 강함 (PagedAttention) |
| API 호환 | Ollama 자체 API | OpenAI 호환 API |
| 양자화 지원 | GGUF 자동 | GPTQ, AWQ |
| 추천 용도 | 개발/테스트 | 프로덕션 |

```bash
# Ollama - 간편하게 시작
ollama pull llama3.1:70b-instruct-q4_K_M
ollama serve --port 11434

# vLLM - 프로덕션 서빙
python -m vllm.entrypoints.openai.api_server \
  --model meta-llama/Llama-3.1-70B-Instruct \
  --tensor-parallel-size 2 \
  --gpu-memory-utilization 0.9
```

## 실무에서 겪는 현실 (삽질 포인트)

- Ollama는 진짜 편한데, 동시 요청 많아지면 느려짐. 5명 이상 동시에 쓰면 체감됨
- vLLM 설치가 은근 까다로움. `pip install vllm`이 CUDA 버전 때문에 실패하는 경우 빈번
- 70B 모델 다운로드 중에 네트워크 끊겨서 처음부터 다시... (resume 안 되는 경우)
- 양자화(Q4_K_M, Q5_K_M 등) 적용하면 VRAM은 아끼는데 답변 품질이 미묘하게 떨어짐
- 한국어 성능이 영어 대비 확 떨어지는 모델이 있음. Llama 3.1은 괜찮은데, Mistral은 좀 약하더라고요

> **이건 꼭 알아두세요:** 모델 선택에서 제일 중요한 건 **"어떤 작업을 시킬 건가"**입니다. 무조건 큰 모델이 답은 아니에요. 추론 속도와 VRAM 비용을 같이 봐야 합니다.

---

## TODO

- [ ] 모델별 한국어 벤치마크 비교표
- [ ] Ollama vs vLLM 응답 속도 실측 비교
- [ ] GGUF 포맷 설명 및 양자화 레벨별 품질 비교
- [ ] vLLM 설치 트러블슈팅 가이드
- [ ] Hugging Face 모델 다운로드 스크립트 (폐쇄망용 포함)
- [ ] API 서버 구축 후 curl 테스트 예시

---

*시리즈: 온프레미스 LLM 구축 (4/10)*

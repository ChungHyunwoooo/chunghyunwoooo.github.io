---
title: "파인튜닝과 모델 최적화 - LoRA, 양자화, 추론 가속"
permalink: /series/on-prem-llm/09-finetuning/
date: 2026-02-06
excerpt: "LoRA/QLoRA 파인튜닝, 양자화, 추론 속도 최적화 실전 가이드"
categories:
  - AI-ML
tags:
  - Fine-tuning
  - LoRA
  - Quantization
  - Optimization
series: "온프레미스 LLM 구축"
series_order: 9
---

## 소개

"파인튜닝하면 성능 좋아진다면서요?" — 네, 맞는데 **잘 해야** 좋아집니다. 잘못하면 오히려 성능이 떨어지는 catastrophic forgetting이 발생하거든요.

그리고 파인튜닝보다 먼저 해야 할 게 **모델 최적화(양자화, 추론 가속)**입니다. 이미 좋은 모델을 더 빠르고 가볍게 만드는 게 ROI가 더 높은 경우가 많아요.

---

## 파인튜닝이 필요한 시점

RAG로 해결 안 되는 경우에만 파인튜닝을 고려하세요:

- 응답 형식이 항상 특정 포맷이어야 할 때 (JSON, 표, 특정 템플릿)
- 도메인 전문 용어를 정확하게 써야 할 때
- 특정 태스크의 정확도를 극한까지 끌어올려야 할 때
- RAG 문서로 커버가 안 되는 "암묵적 지식"이 필요할 때

## LoRA / QLoRA

- **LoRA(Low-Rank Adaptation)**: 전체 모델 대신 작은 어댑터만 학습. VRAM 1/10
- **QLoRA**: LoRA + 4bit 양자화 조합. RTX 4090 한 장으로 70B 파인튜닝 가능 (느리지만 됨)

```bash
# QLoRA 파인튜닝 (Axolotl 기준)
accelerate launch -m axolotl.cli.train config.yaml

# vLLM 양자화 모델 서빙
python -m vllm.entrypoints.openai.api_server \
  --model ./my-finetuned-model \
  --quantization awq \
  --max-model-len 8192
```

## 데이터셋 준비

- instruction tuning 형태: `{"instruction": "...", "input": "...", "output": "..."}`
- 최소 1,000개 이상 필요, **데이터 품질이 90%**
- 현실: "데이터는 있어요"라고 했는데 정제하면 10%만 쓸만함
- 전체 프로젝트 시간의 60%가 데이터셋 만드는 데 소요

## Quantization (양자화)

| 포맷 | 용량 절감 | 성능 하락 | 추천 |
|------|----------|----------|------|
| FP16 | 기준 | 없음 | VRAM 여유 있으면 |
| INT8 | 50% | 1~2% | 무난한 선택 |
| INT4 (Q4_K_M) | 75% | 3~5% | VRAM 부족할 때 |
| Q5_K_M | 68% | 1~3% | **가성비 최고** |

## 추론 가속

- **Flash Attention 2**: 메모리 효율적인 Attention 구현. 무조건 켜세요
- **vLLM PagedAttention**: 동시 요청 처리 최적화
- **Speculative Decoding**: 작은 모델로 초안 생성 → 큰 모델로 검증. 속도 2~3배

## 파인튜닝 프레임워크 비교

| 도구 | 특징 |
|------|------|
| Axolotl | 원스톱 프레임워크, YAML 설정, 다양한 모델 지원 |
| Unsloth | 2~5배 빠른 학습, VRAM 적게 씀. 최근 인기 급상승 |
| PEFT (HuggingFace) | 공식 라이브러리, 안정적. 직접 코드 작성 필요 |

## 실무에서 겪는 현실 (삽질 포인트)

- 데이터셋 만드는 게 진짜 노가다. "데이터는 있어요" → 정제하면 10%만 쓸만
- LoRA rank를 너무 높게 잡으면 과적합, 너무 낮으면 학습 안 됨. r=16이 보통 기본값
- 파인튜닝 후 일반 대화 능력이 떨어지는 현상(catastrophic forgetting). 범용 데이터를 10~20% 섞어야 함
- Q5_K_M 양자화는 원본과 거의 차이 없더라고요. 대부분의 경우 이걸 추천
- 학습 도중 OOM(Out of Memory) → gradient checkpointing 켜거나 batch size 줄이기

> **이건 꼭 알아두세요:** 파인튜닝 전에 반드시 **"RAG로 해결 안 되나?"**를 먼저 확인하세요. 파인튜닝은 데이터셋 준비, 학습, 평가, 배포까지 최소 2~4주가 걸리고, 모델 업그레이드할 때마다 다시 해야 합니다. RAG는 문서만 추가하면 되고요.

---

## TODO

- [ ] QLoRA 파인튜닝 전체 실습 (Axolotl config 포함)
- [ ] 데이터셋 포맷 예시 및 정제 스크립트
- [ ] LoRA rank별 성능 비교 실험
- [ ] 양자화 레벨별 벤치마크 (속도, 정확도)
- [ ] catastrophic forgetting 방지 전략 상세
- [ ] Unsloth 사용 가이드
- [ ] 파인튜닝 전후 성능 비교 결과

---

*시리즈: 온프레미스 LLM 구축 (9/10)*

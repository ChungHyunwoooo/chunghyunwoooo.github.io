---
title: "RAG 파이프라인 구축 - 검색 증강 생성의 모든 것"
permalink: /series/on-prem-llm/06-rag-pipeline/
date: 2026-02-06
excerpt: "벡터 DB, 임베딩 모델, 청킹 전략까지 프로덕션 RAG 파이프라인 구현"
categories:
  - AI-ML
tags:
  - RAG
  - Vector DB
  - Embedding
  - LangChain
series: "온프레미스 LLM 구축"
series_order: 6
---

## 소개

온프레미스 LLM의 **킬러 피처**입니다. 모델 자체 성능이 상용 대비 떨어져도, RAG를 잘 구축하면 **우리 도메인에서는 GPT-4보다 나은 답변**을 만들 수 있거든요.

이론은 간단한데 실제로 구현하면 예상 못 한 함정이 곳곳에 있습니다. 이 회차에서는 프로덕션 수준의 RAG 파이프라인을 처음부터 끝까지 구축합니다.

---

## RAG 파이프라인 전체 구조

1. **문서 수집** → PDF, 위키, Confluence, 코드 등
2. **전처리/청킹** → 문서를 적절한 크기로 분할
3. **임베딩** → 벡터로 변환
4. **벡터 DB 저장** → 인덱싱
5. **검색** → 사용자 질문 → 유사 문서 검색
6. **리랭킹** → 검색 결과 정밀도 향상
7. **생성** → 검색 결과 + 질문 → LLM에 전달 → 답변

## 벡터 DB 심층 비교

| DB | 특징 | 추천 상황 |
|----|------|----------|
| ChromaDB | 쉬움, 임베디드 | 프로토타입, POC |
| Qdrant | 빠름, Rust 기반 | **프로덕션 추천** |
| Milvus | 대규모, 클러스터링 | 문서 100만 건 이상 |
| Weaviate | 하이브리드 검색 내장 | 벡터+키워드 동시 검색 |

## 임베딩 모델 선택

- `bge-m3`: 다국어 최강. 한국어 포함 100+ 언어
- `multilingual-e5-large`: 범용 다국어
- `ko-sroberta-multitask`: 한국어 특화, 한국어만이면 이것도 괜찮음

## 청킹 전략

- **고정 크기 (512토큰)**: 편한데 문맥이 잘림
- **문장 기반**: 의미 단위 보존, 크기 불균일
- **Recursive Character Splitter**: LangChain 기본, 실무에서 제일 많이 씀
- **의미 기반**: 최신 기법, 아직 실험적

## 검색 알고리즘

- **Dense (벡터 검색)**: 의미 유사도 기반. 기본
- **Sparse (BM25)**: 키워드 매칭. 정확한 용어 검색에 강함
- **Hybrid**: 둘 다 쓰고 결합. 실무에서는 이게 제일 좋더라고요

## 리랭킹

검색 결과를 한번 더 정밀하게 순위 매기기. 체감 정확도가 확 올라갑니다.

- `bge-reranker-v2-m3`: 다국어 리랭커 추천
- `cross-encoder/ms-marco-MiniLM-L-12-v2`: 영어 기준 정확도 높음

## 코드 미리보기

```python
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.embeddings import HuggingFaceBgeEmbeddings
from qdrant_client import QdrantClient

# 이런 수준으로 전체 파이프라인 코드를 보여줄 예정
```

## LangChain vs LlamaIndex

- **LangChain**: 범용적, 커뮤니티 크고, 진입 장벽 낮음. 하지만 abstraction이 너무 많아서 디버깅 힘들 때 있음
- **LlamaIndex**: RAG 특화, 데이터 연결이 강점. 구조가 더 깔끔한데 생태계가 좀 작음

## 실무에서 겪는 현실 (삽질 포인트)

- 청킹 사이즈를 잘못 잡으면 답변 품질이 바닥. 512토큰이 만능이 아닙니다
- 한국어 문서 임베딩에서 영어 모델 쓰면 검색 정확도 처참. 다국어 모델 필수
- PDF에서 텍스트 추출할 때 표(table)가 깨지는 문제 → 별도 전처리 필요
- "검색은 잘 되는데 LLM이 검색 결과를 무시하고 자기 지식으로 답변하는" 현상. 프롬프트 엔지니어링이 핵심
- 벡터 DB 인덱스 리빌드할 때 문서 수만 건이면 시간 엄청 걸림. 증분 업데이트 전략 필요
- "의미적으로 비슷한데 키워드가 다른" 경우 벡터 검색이 잘 못 찾음 → Hybrid Search로 해결

> **이건 꼭 알아두세요:** RAG 성능의 80%는 **전처리와 청킹**에서 결정됩니다. 모델이 아무리 좋아도 검색이 엉뚱한 문서를 가져오면 소용없어요. 임베딩 모델 선택, 청킹 전략, 리랭킹 — 이 세 가지에 시간을 제일 많이 투자하세요.

---

## TODO

- [ ] 엔드-투-엔드 RAG 파이프라인 전체 코드
- [ ] 벡터 DB 성능 벤치마크 (검색 속도, 정확도)
- [ ] 청킹 전략별 답변 품질 비교 실험
- [ ] PDF/Confluence/코드 전처리 파이프라인
- [ ] 프롬프트 템플릿 예시 (검색 결과 주입 방식)
- [ ] RAGAS 평가 프레임워크로 품질 측정
- [ ] 증분 인덱싱 구현 방법

---

*시리즈: 온프레미스 LLM 구축 (6/10)*

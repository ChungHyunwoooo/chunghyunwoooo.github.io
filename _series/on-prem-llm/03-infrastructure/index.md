---
title: "인프라 준비 - GPU 서버부터 Docker까지"
permalink: /series/on-prem-llm/03-infrastructure/
date: 2026-02-06
excerpt: "GPU 선택, CUDA 설치, Docker 환경 구성까지 인프라 삽질기의 모든 것"
categories:
  - AI-ML
tags:
  - GPU
  - CUDA
  - Docker
  - Infrastructure
series: "온프레미스 LLM 구축"
series_order: 3
---

## 소개

이 회차가 **야근의 원인 1순위**입니다. CUDA 버전이 안 맞아서, Docker에서 GPU를 못 잡아서, 드라이버가 충돌해서... 인프라 세팅 삽질기의 모든 것을 다룹니다.

하드웨어 선택부터 소프트웨어 스택 설치까지, "처음 GPU 서버 만지는 사람"이 봐도 따라할 수 있게 정리할 예정이에요.

---

## GPU 선택 가이드

| GPU | VRAM | 가격대 | 용도 |
|-----|------|--------|------|
| NVIDIA A100 | 80GB | 3,000~4,000만원 | 데이터센터, 대형 모델 |
| NVIDIA H100 | 80GB | 5,000만원+ | 최신, 학습+추론 최강 |
| RTX 4090 | 24GB | 250~300만원 | 가성비, 소형 모델 |
| L40S | 48GB | 1,500만원대 | 추론 특화 |
| RTX 4080 | 16GB | 150만원대 | 입문/테스트용 |

## VRAM 요구사항

모델 크기별 최소 VRAM (FP16 기준, 양자화하면 줄어듦):

- 7B~8B 모델: ~14GB → RTX 4090 OK
- 13B 모델: ~26GB → RTX 4090 빠듯, A100 권장
- 70B 모델: ~140GB → A100 2장 or 양자화 필수
- 405B 모델: 여러 장 필요, 일반 회사에서는 비현실적

## CUDA + Docker 환경 구성

```bash
# GPU 확인
nvidia-smi

# CUDA Toolkit 12.x 설치 후 확인
nvcc --version

# Docker GPU 연동
nvidia-ctk runtime configure
sudo systemctl restart docker

# GPU Docker 테스트
docker run --gpus all nvidia/cuda:12.4.0-base-ubuntu22.04 nvidia-smi
```

## 실무에서 겪는 현실 (삽질 포인트)

- `nvidia-smi` 잘 되는데 Docker 안에서 GPU 안 잡히는 현상 → `nvidia-container-toolkit` 설치 빠뜨린 것
- CUDA 12.4 설치했는데 PyTorch가 CUDA 12.1까지만 지원해서 다시 설치
- RTX 4090 두 장 꽂았는데 NVLink 안 돼서 멀티 GPU 활용 제한 (4090은 NVLink 미지원)
- 서버실 발열 이슈로 GPU 쓰로틀링 걸려서 성능 반토막
- 폐쇄망에서 Docker 이미지, 모델 파일 수동으로 USB에 담아 옮긴 경험

> **이건 꼭 알아두세요:** GPU 살 때 **VRAM이 진짜 중요**합니다. RTX 4090이 성능은 좋은데 24GB라서 큰 모델을 못 올려요. A100 80GB는 비싸지만 70B 모델도 양자화하면 올라갑니다. 예산과 모델 크기 사이에서 트레이드오프를 잘 따져야 합니다.

---

## TODO

- [ ] CUDA + cuDNN 버전 호환성 매트릭스 표 작성
- [ ] Docker Compose 예시 파일 (GPU 설정 포함)
- [ ] 폐쇄망 환경 오프라인 설치 가이드
- [ ] nvidia-smi 출력 해석 방법
- [ ] 서버 발열/전력 모니터링 설정
- [ ] 하드웨어 벤치마크 결과 (실측)

---

*시리즈: 온프레미스 LLM 구축 (3/10)*

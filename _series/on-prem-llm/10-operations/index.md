---
title: "운영과 모니터링 - 프로덕션 LLM의 생존 가이드"
permalink: /series/on-prem-llm/10-operations/
date: 2026-02-06
excerpt: "Prometheus, Grafana 모니터링부터 장애 대응, 스케일링까지 실전 운영기"
categories:
  - AI-ML
tags:
  - Monitoring
  - DevOps
  - Prometheus
  - Production
series: "온프레미스 LLM 구축"
series_order: 10
---

## 소개

드디어 프로덕션 디플로이입니다. 솔직히 여기서부터가 진짜 시작이에요. **"만드는 건 20%, 운영이 80%"**라는 말 있잖아요. LLM도 정확히 그렇습니다.

POC는 성공했는데 프로덕션 전환이 고민인 분, "서비스 오픈했는데 느려요 / 자꾸 죽어요" 문제를 겪고 있는 분을 위한 회차입니다.

---

## 프로덕션 디플로이 체크리스트

이거 빠뜨리면 새벽에 전화 옵니다:

- [ ] Health check 엔드포인트
- [ ] Rate limiting 설정
- [ ] 타임아웃 설정 (LLM은 응답이 느릴 수 있음)
- [ ] 에러 핸들링 / fallback 전략
- [ ] GPU 메모리 모니터링
- [ ] 로그 로테이션
- [ ] 자동 재시작 설정 (systemd / k8s)

## 핵심 메트릭

| 메트릭 | 설명 | 알림 기준 |
|--------|------|----------|
| Latency (p50/p95/p99) | 응답 시간 분포 | p99 > 10초 |
| Throughput | tokens/sec | 임계치 미만 |
| GPU 사용률 | nvidia-smi | > 95% 지속 |
| VRAM 사용량 | GPU 메모리 | > 90% |
| 큐 대기 시간 | 요청 대기열 | > 5초 |
| 에러율 | 실패 요청 비율 | > 1% |

## 모니터링 스택

```yaml
# Prometheus 수집 설정 예시
- job_name: 'vllm'
  metrics_path: '/metrics'
  static_configs:
    - targets: ['vllm-server:8000']
```

- **Prometheus + Grafana**: 메트릭 수집 + 대시보드. 실제 대시보드 JSON 공유 예정
- **ELK Stack / Grafana Loki**: 로깅. 요청/응답 로그, 에러 로그, 느린 쿼리 로그
- **PagerDuty / Slack 알림**: GPU 95% 이상, latency p99 > 10초, 에러율 > 1%

## 모델 업데이트 전략

- **Blue-Green 배포**: 새 모델을 별도 인스턴스에 올리고 트래픽 전환
- **Canary 배포**: 10% 트래픽만 새 모델로 보내서 품질 확인 후 전체 전환
- 모델 바꿨는데 품질 떨어지면 **즉시 롤백** 가능해야 함. regression test 필수

## 스케일링

- 단일 GPU → 멀티 GPU (tensor parallelism)
- 멀티 GPU → 멀티 노드 (pipeline parallelism)
- Kubernetes + GPU Operator로 오토스케일링
- `nvidia.com/gpu` 리소스 설정 실수로 GPU 없이 Pod 뜨는 사고 주의

## 실무에서 겪는 현실 (삽질 포인트)

- GPU 메모리 릭 → vLLM 프로세스가 점점 느려지다가 OOM으로 죽음. 주기적 재시작 필요
- 동시 요청이 갑자기 몰리면 큐가 밀려서 타임아웃 폭주. rate limiting 필수
- 모델 업데이트했는데 기존에 잘 되던 답변이 안 됨. regression test 없으면 감지 못 함
- K8s에서 GPU Pod 스케줄링이 생각보다 까다로움
- 사용자가 점점 LLM에 의존하기 시작하면서 장애 시 임팩트가 커짐. SLA 설정 필요
- 로그 용량이 미친 듯이 쌓임. 요청/응답 전문 저장하면 하루에 수십GB. 샘플링 전략 필요

> **이건 꼭 알아두세요:** 프로덕션 LLM에서 가장 중요한 메트릭은 **p99 latency**입니다. 평균 2초여도, 100명 중 1명이 30초 기다리면 그 사람이 "이거 느려서 못 쓰겠다"고 소문을 냅니다. GPU 추론은 배치 처리 여부에 따라 latency 편차가 크기 때문에, p99까지 모니터링하고 알림을 걸어야 합니다.

---

## TODO

- [ ] Prometheus + Grafana 대시보드 JSON 파일
- [ ] vLLM 메트릭 엔드포인트 설정 가이드
- [ ] Kubernetes GPU Operator 설정
- [ ] Blue-Green 배포 스크립트
- [ ] regression test 셋 구축 방법
- [ ] 트러블슈팅 사례집 (실제 장애 + 해결)
- [ ] 로그 샘플링 전략
- [ ] SLA 템플릿

---

*시리즈: 온프레미스 LLM 구축 (10/10)*

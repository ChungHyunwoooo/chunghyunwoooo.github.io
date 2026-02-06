---
permalink: /articles/veer-risc-v-core/
title: "VeeR RISC-V Core 소개"
date: 2025-01-15
categories:
  - Hardware
tags:
  - RISC-V
  - VeeR
  - CPU
  - Verilog
mermaid: true
---

임베디드 설계를 위해 오픈소스 CPU를 찾다 보면 Western Digital의 **VeeR**를 마주하게 됩니다. 수십억 개의 SSD 컨트롤러에 탑재되어 양산 검증을 마친 이 코어는, 단순히 "무료"라서가 아니라 **실시간 제어의 결정론적 성능(Deterministic Performance)** 때문에 선택됩니다.

본 포스트에서는 제품군 중 가장 효율적인 **VeeR-EL2**의 아키텍처를 분석합니다.

## VeeR 개요

![VeeR Logo](https://github.com/chipsalliance/Cores-VeeR-EL2/raw/main/docs/source/img/VeeR-logo-white-rgb.png)

VeeR는 Western Digital이 자사 제품의 신뢰성을 담보하기 위해 설계하고 CHIPS Alliance에 기고한 고성능 RISC-V 코어입니다. 상용 수준의 완성도를 갖춘 Verilog RTL을 즉시 프로젝트에 투입할 수 있다는 점이 엔지니어들에게 가장 큰 매력입니다.

<div class="mermaid">
graph TB
    subgraph Core["VeeR Core"]
        IFU[Instruction Fetch Unit]
        DEC[Decode/AGU]
        EXU[Execution Unit]
        LSU[Load/Store Unit]
    end

    subgraph Memory["Memory Subsystem"]
        IC[I-Cache / ICCM]
        DCCM[DCCM<br/>Data Closely Coupled Memory]
    end

    subgraph Bus["External Interface"]
        AXI[AXI4 Bus Interface]
    end

    IFU <--> IC
    LSU <--> DCCM
    IC <--> AXI
    LSU <--> AXI
    IFU --> DEC
    DEC --> EXU
    DEC --> LSU
</div>

## 주요 특징: "실시간성을 위한 설계"

### 1. 4-Stage 파이프라인과 순차 발행

VeeR-EL2는 전력과 면적을 최소화하기 위해 **4-stage pipeline**과 **Single-issue** 방식을 채택합니다.

- **구조:** Fetch, Decode, Execute, Write-back으로 이어지는 간결한 구조입니다.
- **Out-of-order completion**: 부하가 큰 메모리 연산(LSU)과 정수 연산(EXU)의 완료 시점을 유연하게 처리하여 파이프라인 멈춤을 방지합니다.

<div class="mermaid">
graph LR
    F[Fetch<br/>명령어 인출] --> D[Decode<br/>명령어 해독]
    D --> E[Execute<br/>실행]
    E --> W[Write Back<br/>결과 저장]

    style F fill:#4a90d9,stroke:#333,color:#fff
    style D fill:#9b59b6,stroke:#333,color:#fff
    style E fill:#e67e22,stroke:#333,color:#fff
    style W fill:#2ecc71,stroke:#333,color:#fff
</div>

### 2. D-Cache 대신 DCCM을 쓰는 이유

독자가 가장 의아해할 부분은 **데이터 캐시(D-Cache)의 부재**입니다. 하지만 이는 의도된 설계입니다.

<div class="mermaid">
flowchart LR
    subgraph Traditional["기존 방식"]
        CPU1[CPU] --> DC[D-Cache]
        DC -->|Cache Miss| MEM1[Memory]
        DC -->|Cache Hit| CPU1
    end

    subgraph VeeR["VeeR 방식"]
        CPU2[CPU] <-->|Single Cycle| DCCM2[DCCM]
    end

    style DC fill:#e74c3c,stroke:#333,color:#fff
    style DCCM2 fill:#2ecc71,stroke:#333,color:#fff
</div>

- **DCCM (Data Closely Coupled Memory)**: 캐시 미스에 따른 가변적인 지연 시간은 실시간 제어에서 치명적입니다. VeeR-EL2는 SRAM 기반의 DCCM을 배치하여 **단일 사이클 내에 데이터를 확정적으로 읽고 씁니다**.
- **설계 철학**: 스토리지 펌웨어의 엄격한 타이밍 예측 가능성 요구사항을 충족하기 위해, DCCM이 기존 데이터 캐시를 대체하여 비결정론적 지연을 제거합니다.

### 3. 검증된 성능 지표

VeeR-EL2는 저사양 코어임에도 불구하고 높은 효율을 보여줍니다.

| Metric | VeeR EL2 Specification |
|--------|------------------------|
| **CoreMark/MHz** | 3.6 (ARM Cortex-M4급 성능) |
| **DMIPS/MHz** | 2.1 |
| **Target Frequency** | 1+ GHz (7nm 공정 기준) |

<div class="mermaid">
pie title VeeR-EL2 성능 비교 (CoreMark/MHz)
    "VeeR-EL2 (3.6)" : 36
    "Cortex-M4 (3.4)" : 34
    "Cortex-M0 (2.3)" : 23
</div>

## Verilog 구조 및 확장성

VeeR는 표준 RISC-V 툴체인을 그대로 지원하며, 외부 버스로는 산업 표준인 AXI4를 사용합니다.

```verilog
module veer_wrapper (
    input  logic        clk,
    input  logic        rst_l, // Active-low reset

    // IFU(명령어 인출) 인터페이스
    output logic [31:0] ifu_axi_araddr,
    output logic        ifu_axi_arvalid,
    input  logic        ifu_axi_arready,

    // LSU(데이터 로드/스토어) 인터페이스
    output logic [31:0] lsu_axi_awaddr,
    output logic        lsu_axi_awvalid,
    input  logic        lsu_axi_awready
);
```

> **AXI4 프로토콜 동작**: IFU는 `ifu_axi_arvalid`를 assert하여 fetch 동작을 시작합니다. AXI4 프로토콜 명세에 따라, slave가 `ifu_axi_arready`를 assert할 때까지 주소가 유지됩니다.

<div class="mermaid">
sequenceDiagram
    participant IFU as IFU (Master)
    participant AXI as AXI Bus
    participant MEM as Memory (Slave)

    IFU->>AXI: araddr, arvalid=1
    Note over AXI: Address Phase
    AXI->>MEM: Forward Request
    MEM-->>AXI: arready=1
    AXI-->>IFU: arready=1
    Note over AXI: Data Phase
    MEM-->>AXI: rdata, rvalid=1
    AXI-->>IFU: rdata, rvalid=1
    IFU->>AXI: rready=1
</div>

## 요약: 왜 VeeR-EL2인가?

1. **상용 검증**: WD의 스토리지 제품군에서 이미 안정성이 증명되었습니다.
2. **결정론적 성능**: DCCM 구조를 통해 실시간 응답성을 보장합니다.
3. **오픈소스**: SoC 설계에 자유롭게 활용할 수 있습니다.

---
permalink: /articles/veer-risc-v-core/

## 참고 자료

- [VeeR-EL2 GitHub](https://github.com/chipsalliance/Cores-VeeR-EL2)
- [RISC-V Foundation Specifications](https://riscv.org/specifications/)
- [CHIPS Alliance](https://chipsalliance.org/)

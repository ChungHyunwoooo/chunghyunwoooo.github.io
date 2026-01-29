---
title: "Attention Mechanism 완벽 이해"
date: 2024-01-20
categories:
  - AI-ML
tags:
  - Attention
  - Transformer
  - Deep Learning
  - NLP
mermaid: true
---

Transformer의 핵심인 **Attention Mechanism**을 수식과 코드로 이해합니다.

## Attention이란?

Attention은 입력 시퀀스에서 **중요한 부분에 집중**하는 메커니즘입니다.

<div class="mermaid">
graph LR
    I[Input Sequence] --> E[Embedding]
    E --> Q[Query]
    E --> K[Key]
    E --> V[Value]
    Q --> ATT[Attention Score]
    K --> ATT
    ATT --> SM[Softmax]
    SM --> W[Weights]
    W --> OUT[Output]
    V --> OUT
</div>

## Self-Attention

### 수식

$$
\text{Attention}(Q, K, V) = \text{softmax}\left(\frac{QK^T}{\sqrt{d_k}}\right)V
$$

- **Q (Query)**: 현재 위치에서 다른 위치를 조회
- **K (Key)**: 각 위치의 식별자
- **V (Value)**: 실제 정보

### 동작 과정

<div class="mermaid">
sequenceDiagram
    participant Input
    participant Q as Query
    participant K as Key
    participant V as Value
    participant Output

    Input->>Q: Linear Transform
    Input->>K: Linear Transform
    Input->>V: Linear Transform
    Q->>K: MatMul (QK^T)
    Note over Q,K: Scale by √d_k
    K->>K: Softmax
    K->>V: Weighted Sum
    V->>Output: Result
</div>

## PyTorch 구현

```python
import torch
import torch.nn as nn
import torch.nn.functional as F

class SelfAttention(nn.Module):
    def __init__(self, embed_dim, num_heads):
        super().__init__()
        self.embed_dim = embed_dim
        self.num_heads = num_heads
        self.head_dim = embed_dim // num_heads

        self.q_proj = nn.Linear(embed_dim, embed_dim)
        self.k_proj = nn.Linear(embed_dim, embed_dim)
        self.v_proj = nn.Linear(embed_dim, embed_dim)
        self.out_proj = nn.Linear(embed_dim, embed_dim)

    def forward(self, x):
        batch_size, seq_len, _ = x.shape

        # Project to Q, K, V
        Q = self.q_proj(x)
        K = self.k_proj(x)
        V = self.v_proj(x)

        # Reshape for multi-head attention
        Q = Q.view(batch_size, seq_len, self.num_heads, self.head_dim).transpose(1, 2)
        K = K.view(batch_size, seq_len, self.num_heads, self.head_dim).transpose(1, 2)
        V = V.view(batch_size, seq_len, self.num_heads, self.head_dim).transpose(1, 2)

        # Attention scores
        scores = torch.matmul(Q, K.transpose(-2, -1)) / (self.head_dim ** 0.5)
        attn_weights = F.softmax(scores, dim=-1)

        # Weighted sum
        output = torch.matmul(attn_weights, V)

        # Reshape and project
        output = output.transpose(1, 2).contiguous().view(batch_size, seq_len, self.embed_dim)
        return self.out_proj(output)
```

## Multi-Head Attention

여러 개의 attention head를 병렬로 사용하여 다양한 관점에서 정보를 수집합니다.

<div class="mermaid">
graph TB
    subgraph Input
        X[Input Embedding]
    end

    subgraph Heads
        H1[Head 1<br/>문법]
        H2[Head 2<br/>의미]
        H3[Head 3<br/>위치]
        H4[Head 4<br/>...]
    end

    subgraph Output
        C[Concatenate]
        L[Linear Layer]
        O[Output]
    end

    X --> H1
    X --> H2
    X --> H3
    X --> H4
    H1 --> C
    H2 --> C
    H3 --> C
    H4 --> C
    C --> L
    L --> O
</div>

## Attention의 장점

| 특성 | RNN | Attention |
|------|-----|-----------|
| 병렬화 | 어려움 | 용이 |
| 장거리 의존성 | 약함 | 강함 |
| 학습 속도 | 느림 | 빠름 |
| 해석 가능성 | 낮음 | 높음 |

## Transformer 전체 구조

<div class="mermaid">
graph TB
    subgraph Encoder
        E_IN[Input] --> E_EMB[Embedding + PE]
        E_EMB --> E_ATT[Multi-Head Attention]
        E_ATT --> E_ADD1[Add & Norm]
        E_ADD1 --> E_FF[Feed Forward]
        E_FF --> E_ADD2[Add & Norm]
    end

    subgraph Decoder
        D_IN[Output] --> D_EMB[Embedding + PE]
        D_EMB --> D_ATT1[Masked Multi-Head Attention]
        D_ATT1 --> D_ADD1[Add & Norm]
        D_ADD1 --> D_ATT2[Cross Attention]
        E_ADD2 --> D_ATT2
        D_ATT2 --> D_ADD2[Add & Norm]
        D_ADD2 --> D_FF[Feed Forward]
        D_FF --> D_ADD3[Add & Norm]
    end

    D_ADD3 --> LINEAR[Linear]
    LINEAR --> SOFTMAX[Softmax]
    SOFTMAX --> OUT[Output Probabilities]
</div>

## 참고 자료

- [Attention Is All You Need (2017)](https://arxiv.org/abs/1706.03762)
- [The Illustrated Transformer](https://jalammar.github.io/illustrated-transformer/)

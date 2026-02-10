---
title: "Agent Skills - Agent에게 전문성을 패키징하는 법"
permalink: /series/ai-agent/04-agent-skills/
date: 2026-02-10
excerpt: "오픈 표준 Agent Skills 포맷: 개념, 스펙, 통합, 생태계"
categories:
  - AI-ML
tags:
  - Agent Skills
  - AI Agent
  - SKILL.md
  - Open Standard
series: "AI Agent 실전 가이드"
series_order: 4
mermaid: true
---

## TODO

agentskills.io 4개 페이지 통합 구성:

### 1. 왜 Agent에게 "스킬"이 필요한가
- Agent의 한계: 범용 지식 O, 조직 맥락 X
- 프롬프트 엔지니어링의 한계 → 구조화된 지식 전달 필요

### 2. Agent Skills란? (what-are-skills)
- 폴더 = 스킬 (SKILL.md + scripts/ + references/ + assets/)
- Progressive Disclosure: Discovery → Activation → Execution
- MCP와의 관계: "MCP가 손이라면, Skills는 매뉴얼"

### 3. SKILL.md 스펙 (specification)
- Frontmatter 필수 필드: name, description
- 선택 필드: license, compatibility, metadata, allowed-tools
- 네이밍 규칙, description 작성 가이드
- Body 구조 권장사항, 500줄 가이드라인

### 4. Agent에 Skills 통합하기 (integrate-skills)
- Filesystem-based vs Tool-based 접근
- Discovery → Metadata Loading → Matching → Activation → Execution
- System Prompt에 XML로 스킬 목록 주입
- 보안: 샌드박싱, 허용목록, 사용자 확인

### 5. 생태계 현황 (home)
- 지원: Claude Code, Cursor, Gemini CLI, OpenCode, VS Code, GitHub 등 27+
- Anthropic이 만들고 오픈 표준으로 공개
- skills-ref 라이브러리

### 6. 마무리
- 조직 지식의 버전 관리 가능한 패키징
- 한 번 만들면 여러 Agent에서 재사용

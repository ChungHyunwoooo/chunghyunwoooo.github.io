---
permalink: /articles/zsh-background-customization/
title: "Zsh 터미널 꾸미기: 배경 이미지 및 투명도 설정 (feat. Pywal)"
date: 2026-01-30
categories:
  - Software
tags:
  - Zsh
  - Terminal
  - Customization
  - Pywal
mermaid: true
---

Zsh 터미널에 배경 이미지를 적용하고 투명도를 설정하는 방법을 정리한다.
GNOME Terminal 설정, Powerlevel10k 투명 스타일, 그리고 **Pywal**을 이용한 색상 테마 동기화 방법을 다룬다.

---
permalink: /articles/zsh-background-customization/

## 1. 개념 이해: 쉘(Shell) vs 터미널 에뮬레이터

쉘과 터미널 에뮬레이터의 역할 차이를 이해해야 한다.

*   **Zsh (Shell)**: 명령어 실행 엔진. 프롬프트 모양(Powerlevel10k 등) 설정.
*   **터미널 (Emulator)**: 쉘을 실행하는 창 프로그램. 배경 이미지, 투명도, 폰트 설정 (예: GNOME Terminal, iTerm2).

즉, **배경 이미지는 터미널 에뮬레이터 설정에서 변경해야 한다.**

---

## 2. 배경 이미지 설정 방법 (GNOME Terminal 기준)

리눅스 기본 터미널인 **GNOME Terminal** 설정 방법이다.

1.  터미널 메뉴 -> **Preferences (기본 설정)**
2.  사용 중인 **Profile (프로파일)** 선택
3.  **Appearance (모양)** 또는 **Colors** 탭 선택
4.  **Background (배경)** 섹션 설정
    *   **Background Image**: 이미지 파일 선택
    *   **Transparent background**: 슬라이더로 투명도 조절

> **Tip**: 가독성을 위해 어두운 계열의 이미지를 권장한다.

---
permalink: /articles/zsh-background-customization/

## 3. Powerlevel10k 투명 스타일 적용

배경 이미지를 가리지 않도록 Powerlevel10k 테마를 투명 스타일로 설정한다.

```bash
p10k configure
```

설정 마법사 추천 옵션:

1.  **Prompt Style**: `Rainbow` 또는 `Lean`
    *   *배경 강조 시 `Lean` 추천*
2.  **Character Set**: `Unicode`
3.  **Prompt Height**: `One line`
4.  **Prompt Connection**: `Disconnected`
5.  **Prompt Frame**: `No`
6.  **Prompt Flow**: `Compact`
7.  **Transient Prompt**: `Yes`

설정 후 `~/.p10k.zsh` 파일이 갱신된다.

---

## 4. [고급] Pywal로 색감 자동 동기화

**Pywal**은 이미지에서 색상을 추출하여 터미널 테마를 자동으로 변경해주는 도구다.

### 설치
```bash
pip3 install pywal
```

### 사용법

```bash
# 이미지 지정 및 테마 적용
wal -i ~/Pictures/my_wallpaper.jpg

# 폴더 내 랜덤 이미지 지정
wal -i ~/Pictures/Wallpapers/
```

설정 유지를 위해 `~/.zshrc`에 다음 내용을 추가한다.

```bash
# Pywal 색상 로드
(cat ~/.cache/wal/sequences &)
source ~/.cache/wal/colors-tty.sh
```

---
permalink: /articles/zsh-background-customization/

## 5. 스타일 벤치마크 (추천 조합)

인기 있는 3가지 스타일 예시다.

### A. The Cyberpunk (사이버펑크)
![Cyberpunk Style](images/cyberpunk.jpg)
*   **이미지**: 네온 야경, 보라/분홍 계열
*   **P10k 스타일**: `Rainbow`
*   **투명도**: 10~20%
*   **폰트**: `MesloLGS NF` 또는 `D2Coding`

### B. The Minimalist (미니멀리스트)
![Minimalist Style](images/minimal.jpg)
*   **이미지**: 단색 회색 또는 기하학 패턴
*   **P10k 스타일**: `Lean`
*   **투명도**: 0% (불투명)
*   **특징**: 코드 가독성 중시

### C. Nature (자연)
![Nature Style](images/nature.jpg)
*   **이미지**: 숲, 비 오는 창가 (어두운 톤)
*   **P10k 스타일**: `Classic`
*   **투명도**: 30%
*   **Pywal**: 필수 (이미지 톤에 맞게 텍스트 색상 변경)

---

## 마무리

위 설정을 통해 시각적으로 만족스러운 터미널 환경을 구축할 수 있다.

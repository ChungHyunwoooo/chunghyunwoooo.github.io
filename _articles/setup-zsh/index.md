---
permalink: /articles/setup-zsh/
title: "Zsh 및 Oh My Zsh 완벽 설정 가이드 (2026년판)"
date: 2026-01-26
categories:
  - Software
tags:
  - Zsh
  - Linux
  - Terminal
mermaid: true
---

Linux 환경에서 **Zsh (Z Shell)**과 **Oh My Zsh**를 설정하는 방법을 정리한다.
기본 Bash 쉘 대비 향상된 자동 완성 기능과 플러그인 시스템을 활용할 수 있다.

**Zsh 설치부터 필수 플러그인 적용, Powerlevel10k 테마 설정**까지의 과정을 다룬다.

---
permalink: /articles/setup-zsh/

## 1. Zsh 설치

패키지 매니저를 통해 Zsh를 설치한다.

```bash
sudo apt update
sudo apt install zsh -y
```

설치 확인:
```bash
zsh --version
```

기본 쉘 변경 (로그아웃 후 다시 로그인해야 적용됨):
```bash
chsh -s $(which zsh)
```

---

## 2. Oh My Zsh 설치

Zsh 설정 관리 프레임워크인 Oh My Zsh를 설치한다.
`curl`이나 `wget`을 사용한다.

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

---
permalink: /articles/setup-zsh/

## 3. 필수 플러그인 설치

사용 편의성을 높여주는 두 가지 주요 플러그인을 설치한다.

1.  **zsh-autosuggestions**: 명령어 기록 기반 자동 완성 제안.
2.  **zsh-syntax-highlighting**: 명령어 문법 강조 (유효 명령어/오타 구분).

### 플러그인 다운로드 (Git Clone)

```bash
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### .zshrc 적용

`~/.zshrc` 파일을 열어 `plugins` 항목을 수정한다.

```bash
vi ~/.zshrc
```

```bash
# 수정 전
plugins=(git)

# 수정 후
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)
```

설정 적용:
```bash
source ~/.zshrc
```

---

## 4. 테마 설정 (Powerlevel10k)

정보 표시와 속도 면에서 우수한 **Powerlevel10k** 테마를 설정한다.

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

`~/.zshrc`에서 테마 변수 변경:

```bash
ZSH_THEME="powerlevel10k/powerlevel10k"
```

파일을 저장하고 쉘을 다시 로드(`source ~/.zshrc`)하면 설정 마법사(`p10k configure`)가 실행된다.
아이콘, 프롬프트 스타일 등을 선택하여 설정을 완료한다.

---
permalink: /articles/setup-zsh/

## 5. 결론

위 설정을 통해 서버 및 로컬 환경에서 일관되고 효율적인 터미널 환경을 구축할 수 있다.

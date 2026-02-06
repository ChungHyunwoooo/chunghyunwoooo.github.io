---
title: "SystemC 2.3.4 설치 가이드"
permalink: /series/systemc/01-install/
date: 2025-01-16
excerpt: "Ubuntu에서 SystemC 설치 및 환경 설정"
header:
  teaser: https://systemc.org/images/systemc.png
categories:
  - Hardware
tags:
  - SystemC
  - Linux
  - Verification
series: "SystemC"
series_order: 1
---

이 튜토리얼에서는 SystemC 2.3.4를 Ubuntu에 설치하는 방법을 다룹니다.

## 1. 사전 필수 패키지 설치

```bash
sudo apt update
sudo apt install -y build-essential wget
```

## 2. 다운로드 및 빌드

```bash
mkdir -p ~/tools && cd ~/tools
wget https://www.accellera.org/images/downloads/standards/systemc/systemc-2.3.4.tar.gz
tar -xvzf systemc-2.3.4.tar.gz
cd systemc-2.3.4
mkdir objdir && cd objdir
../configure --prefix=$HOME/tools/systemc-2.3.4/install --enable-pthreads
make -j$(nproc)
make install
```

## 3. 환경 변수 설정

`~/.bashrc` 또는 `~/.zshrc`에 추가:

```bash
export SYSTEMC_HOME=$HOME/tools/systemc-2.3.4/install
export LD_LIBRARY_PATH=$SYSTEMC_HOME/lib-linux64:$LD_LIBRARY_PATH
```

## 다음 단계

다음 글에서는 SystemC의 기본 문법을 다룹니다.

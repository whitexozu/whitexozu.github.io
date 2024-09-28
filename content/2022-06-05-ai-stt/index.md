---
title: '[작성중][STT] Acoustic model 조사 및 recognition model 생성'
date: 2022-06-05 08:05:34
author: TMM
categories: AI
tags: STT
---

여친에게 새로운 사업 기획서를 받았습니다. 이번엔 STT 조사가 필요합니다.

## 학습 순서

1. STT 모델 생성 방법 확인

    1. 기초 지식 학습

        - 모델 파이프라인

            - Raw audio -> Feature extraction -> Recognizer -> Character sequence
            - Audio File
                - wav, pcm, flac, etc..
                - 16,000Hz
            - Feature extraction
                - Short-Time Fourier transform
                - 주파수 변화 (신호 처리 기법)
            - acoustic model
                - CTC (Connectionist Temporal Classification)
                - Attention mechanization

        - HMM (Hidden Markov Model, 은닉 마르포크 모형)
        - Kaldi
        - ASR (Automatic Speech Recognition, 자동 음성 인식)
        - CTC (Connectionist Temporal Classification)
        - LSTM Attention
        - ESPnet (End-to-End Speech Processing Toolkit)

1. ksponspeech 학습 데이터 확인

    - https://aihub.or.kr/aidata/105
    - Librosa: https://banana-media-lab.tistory.com/entry/Librosa-python-library%EB%A1%9C-%EC%9D%8C%EC%84%B1%ED%8C%8C%EC%9D%BC-%EB%B6%84%EC%84%9D%ED%95%98%EA%B8%B0

1. speech recognition model 조사

    - KoSpeech: https://github.com/sooftware/kospeech#introduction
    - ESPNet: https://shyu0522.tistory.com/19?category=979870
    - ETC: https://swjman.tistory.com/65

1. STT 모델 생성

    1. 학습 데이터 전사 규칙 확인
    1. hydra
    1. PyTorch Lightning


## 내 모델 생성 환경

### 회사

-   GTX 760 Ti / Ranking 312 / Score 3924

### 집

-   GTX 1060 3G / Ranking 125 / Score 9722

## 참고

- KoSpeech 발표 동영상: https://www.youtube.com/watch?v=OglqDo44zpQ&t=434s
- STFT(Short Time Fourier Transform): https://m.blog.naver.com/vmv-tech/220936084562
- KoSpeech 설정 및 실행 1: https://velog.io/@letgodchan0/%EC%9D%8C%EC%84%B1%EC%9D%B8%EC%8B%9D-%ED%95%9C%EA%B5%AD%EC%96%B4-STT-1
- KoSpeech 설정 및 실행 2: https://mingchin.tistory.com/152
- PyTorch Lightning: https://pytorch-lightning.readthedocs.io/en/latest/notebooks/lightning_examples/mnist-hello-world.html
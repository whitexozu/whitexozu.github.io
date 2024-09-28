---
title: '[작성중][LLaMA] LLaMA 모델 사용'
date: 2024-02-25 08:05:34
author: TMM
categories: NLP
tags: LLM
---

## 학습 목표

1. LLaMA로 특정 도메인에 특화된 봇 만들기

## 학습 순서

1. 개념 정리

    - 사람으로 치면 직장에 나가기 전 정규 교육을 거치게됩니다. 그리고 특정 분야에 전문가가 되기 위해 전공 과장을 듣습니다. LLM으로 치면 정규 과정은 사전 훈련 모델을 만드는 것이고, 전공 과정을 듣는것을 메시 조정이라고 할 수 있습니다. 그리고 과거에는 거대기업외에 현실적으로 파인 튜닝이 불가능했으나 현재 누가나 가능한 경량화된 파일튜닝 방법으로 LoRA(Low-Rank Adaptation of LLM)을 사용하고 있습니다.

        1. 사전 훈련 모델/기반 모델 (정규 과정): Foundation Model

        1. 미세 조정 (전공 과정): Fine-tuning

            - 흙수저 미세 조정: LoRA
                - 장점
                    - 작은 크기
                    - 대기 시간 없이 효율적인 작업 전환
                - 다점
                    - 기반 모델의 한계를 넘을 수 없음

        1. 미세 조성 후 정교하게 학습시키는 것: Prompt Learning

            - 노동 집약적 작업
            - 몇 번 예제 보여주고 요청

        1. 지식 기반의 사실을 처리 로직 뒤에 붙여서 확인: Inform

            - WolframAlpha

        1. 비 윤리적 추론에 대한 안내 문구 추가: Guardrail

        1. 위 3개의 추론 능력 향상을 위해 질의 응답: Human feedback

1. PyTorch 학습
    - 111
    - 222
1. torchrun으로 GPU, M1에서 분산 학습 확인
1. Apacha, KoApacha 분석
1. LLaMA Fine-Turning 방법 확인
1. LoRA (Low-Rank Adaptation) 추가 학습 방법 확인
1. Hugging Face 모델 Repository 생성 후 Private로 변경
1. Hugging Face 모델 Repository Clone

    - Hugigng Face는 현제 password 인증을 통한 clone방식을 지원하지 않습니다.

    ```bash
    $ mkdir <repo_path>
    $ cd <repo_path>
    $ git init
    $ git remote add origin https://<user_name>:<token>@huggingface.co/<user_name><repo_path>
    $ # git remote set-url origin https://<user_name>:<token>@huggingface.co/<user_name><repo_path> # 경로 수정시
    $ git pull origin
    $ git pull origin main
    ```

    ```bash
    $ mkdir koalpaca-polyglot-12.8b-bill
    $ cd koalpaca-polyglot-12.8b-bill
    $ git init
    $ git remote add origin https://whitexozu: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@huggingface.co/whitexozu/koalpaca-polyglot-12.8b-bill
    $ git pull origin
        remote: Enumerating objects: 8, done.
        remote: Counting objects: 100% (5/5), done.
        remote: Compressing objects: 100% (5/5), done.
        remote: Total 8 (delta 0), reused 0 (delta 0), pack-reused 3
        Unpacking objects: 100% (8/8), 4.24 KiB | 482.00 KiB/s, done.
        From https://huggingface.co/whitexozu/koalpaca-polyglot-12.8b-bill
        * [new branch]      main       -> origin/main
        You asked to pull from the remote 'origin', but did not specify
        a branch. Because this is not the default configured remote
        for your current branch, you must specify a branch on the command line.
    $ git pull origin main
        From https://huggingface.co/whitexozu/koalpaca-polyglot-12.8b-bill
        * branch            main       -> FETCH_HEAD
    ```

1.

## 참고

```yaml
PyTorch: https://tutorials.pytorch.kr/beginner/basics/quickstart_tutorial.html
stanford alpaca: https://github.com/tatsu-lab/stanford_alpaca
KoAlpaca: https://github.com/Beomi/KoAlpaca
```

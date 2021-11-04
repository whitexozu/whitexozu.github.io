---
title: '[Python] google sentencepiece'
date: 2020-12-07 08:05:34
author: TMM
categories: Language
tags: Python sentencepiece
---

sentencepiece를 황용해서 토큰화 해보겠습니다.

## sentencepiece

### Subword Segmentation

- subword segmentation(단어 분리, 단어 분절)이란, 하나의 단어(혹은 토큰)는 여러 개의 subword의 조합으로 이루어져 있다는 가정하에, subword 단위의 토크나이징을 수행하여 단어를 이해하려는 목적을 가진 전처리 작업을 말합니다.

### BPE(Byte Pair Encoding)

- BPE는 subword segmentation의 대표적인 알고리즘입니다. 'byte'라는 단어에서 알 수 있듯이 원래는 데이터 압축을 위한 알고리즘으로 탄생했지만, 현재는 NLP 분야의 대표적인 토크나이징 방법으로 활용되고 있습니다.

### 설치

```bash
pip install sentencepiece
```

### argument

- input : 학습시킬 text의 위치
- model_name : 만들어질 모델 이름, 학습 후 <model_name>.model, <model_name>.vocab 두 파일 생성
- model_type : 어느 방식으로 학습할것인가, (unigram(default), bpe, char, word)
- vocal_size : Subword 갯수 설정, 보통 3,200개
- character_coverage : 몇%의 데이터를 커버할것인가, default=0.9995, 데이터셋이 적은 경우 1.0으로 설정

### model 생성

```python
import sentencepiece as spm

input_file = 'data.log'
vocab_size = 32000
model_name = 'subword_tokenizer'
model_type = 'bpe'
user_defined_symbols = '[PAD],[UNK],[CLS],[SEP],[MASK],[UNK1],[UNK2],[UNK3],[UNK4],[UNK5]'

input_argument = '--input=%s --model_prefix=%s --vocab_size=%s --user_defined_symbols=%s --model_type=%s'
cmd = input_argument%(input_file, model_name, vocab_size,user_defined_symbols, model_type)

spm.SentencePieceTrainer.Train(cmd)
```

### model 사용

```python
import sentencepiece as spm

sp = spm.SentencePieceProcessor()
sp.Load("subword_tokenizer.model")

# text -> subword
sp.EncodeAsPieces("This is a test")
# ['▁This', '▁is', '▁a', '▁', 't', 'est']

# text -> subword id
sp.EncodeAsIds("This is a test")
# [497, 100, 49, 6, 47, 514]

# subword id -> text
sp.DecodeIds([497, 100, 49, 6, 47, 514])
# 'This is a test'

# subword -> text
sp.DecodePieces(['▁This', '▁is', '▁a', '▁', 't', 'est'])
# 'This is a test'

# subword size
sp.GetPieceSize()
# 1000

# id -> piece
sp.IdToPiece(2)
# '</s>'

# piece -> id
sp.PieceToId('')
# 0

# Drop-out 사용하기
# enable_sampling=True 일 때 Drop-out이 적용되며 alpha=0.1은 10% 확률로 dropout 한다는 의미이다.
for _ in range(5):
    print(sp.encode('This is a test', out_type=str, enable_sampling=True, alpha=0.1, nbest_size=-1))

# encode의 인자로 encoding 하기
sp.encode('나는 오늘 아침밥을 먹었다.', out_type=str)
# ['▁', '나는', '▁', '오늘', '▁', '아침밥을', '▁', '먹었다', '.']
sp.encode('나는 오늘 아침밥을 먹었다.', out_type=int)
# [245, 0, 245, 0, 245, 0, 245, 0, 251]
```

## 참고

- https://signing.tistory.com/51
- https://velog.io/@gwkoo/BPEByte-Pair-Encoding

```toc

```

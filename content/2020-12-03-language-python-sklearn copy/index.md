---
title: '[Python] sklearn tf-idf, clustering'
date: 2020-12-03 08:05:34
author: TMM
categories: Language
tags: Python sklearn tf-idf clustering
---

순서에 상관없이 Document-Term에서 중요한 단어, 혹은 중요하지 않은 단어를 찾는 방법중 TF-IDF(Term Frequency - Inverse Document Frequency)를 sklearn을 활용하여 간단하게 사용한 예제입니다.<br />
그리고 TF-IDF결과를 clustering 해보도록 하겠습니다.

## 설치

### sklearn, pandas, jupyter

```bash
$ pip install sklearn
$ pip install jupyter
$ pip install pandas
```

### jupyter 실행

```bash
$ jupyter notebook
```

## TF-IDF

### read csv file

```python

import pandas as pd
import matplotlib.font_manager as fm
import matplotlib.pyplot as plt
from sklearn.manifold import TSNE
from sklearn.feature_extraction.text import TfidfVectorizer

df = pd.read_csv('./article_data.csv', encoding='utf-8')
# df = article_data.head(5)
documents = [row['title'] for row in df.T.to_dict().values()]
```

### tf-idf vectorizer

```python

tfidf = TfidfVectorizer(max_features = 100, max_df=0.95, min_df=0)
tfidf_sp = tfidf.fit_transform(documents)  #size D x V
tfidf_dict = tfidf.get_feature_names()
print(tfidf_dict)

data_array = tfidf_sp.toarray()

```

### 2D chart

```python

data = pd.DataFrame(data_array, columns=tfidf_dict)

tsne = TSNE(n_components=2, n_iter=10000, verbose=1)
Z = tsne.fit_transform(data_array.T)
path = './NanumGothic.ttf'
fontprop = fm.FontProperties(fname=path, size=10)
plt.figure(figsize=(15, 15))
plt.scatter(Z[:,0], Z[:,1])
for i in range(len(tfidf_dict)):
    plt.annotate(s=tfidf_dict[i].encode("utf8").decode("utf8"), xy=(Z[i,0], Z[i,1]), fontProperties =fontprop)

plt.draw()
```

## clustering

### KMeans

```python

X = np.array(data_array)
kmeans = KMeans(n_clusters=15, random_state=0).fit(X)
print(kmeans.labels_)

```

## fornt download

1. https://hangeul.naver.com/2017/nanum
1. "네이버에서 개발한 글꼴모음 설치하하기 클릭"
1. 윈도우, 맥 모두 윈도우 버전의 압축파일을 다운 받아서 사용합니다.

## 참고

- https://donghwa-kim.github.io/TFIDF.html

```toc

```

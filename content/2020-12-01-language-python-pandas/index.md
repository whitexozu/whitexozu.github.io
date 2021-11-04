---
title: '[Python] pandas 사용방법'
date: 2020-12-01 08:05:34
author: TMM
categories: Language
tags: Python pandas
---

데이터 분석을 위해 pandas를 사용해 보았습니다.<br />
한동안 안쓰면 또 잊어버릴 것 같아서 자주 쓰는것들만 정리해 놓으려 합니다.

## 설치

### pandas, jupyter

```bash
$ pip install jupyter
$ pip install pandas
```

### jupyter 실행

```bash
$ jupyter notebook
```

## pandas

### display option

```python
import pandas as pd

pd.set_option('display.max_columns', None)  # or 1000
pd.set_option('display.max_rows', None)  # or 1000
pd.set_option('display.max_colwidth', -1)  # or 199

# pd.set_option('display.max_columns', 100)  # or 1000
# pd.set_option('display.max_rows', 100)  # or 1000
# pd.set_option('display.max_colwidth', 100)  # or 199
```

### read csv file

```python
import pandas as pd

pd = pd.read_csv('./article_data_file.csv', index_col='id')
pd.shape    # 행, 열
pd.columns  # 컬럼명 배열
pd.head(5)  # 상위 5개
pd.tail(5)  # 하위 5개

```

### db data to pandas

```python
import pandas as pd

dbData = selectArticleData()
pd = pd.DataFrame(dbData)
```

### pandas to numpy

```python
import pandas as pd

dbData = selectArticleData()
pd = pd.to_numpy()
```

### filter column value

```python
import pandas as pd

dbData = selectArticleData
df = pd.DataFrame(dbData)

df0 = df[df['cluster'] == 0]
print(df0[['cluster', 'title']])
```

### sum

```python
import pandas as pd

pd = pd.read_csv('./article_data_file.csv', index_col='id')

pd['count'].sum()
```

### group count

```python
import pandas as pd

pd = pd.read_csv('./article_data_file.csv', index_col='id')

df2 = pd[['article']]
df2.insert(1, 'count', 1)
df2 = df2.groupby(by=['article'], as_index=False)\
    .sum()\
    .sort_values(['count'], ascending=False)\
    .head(5)
df2
```

### group percentage

```python
import pandas as pd

pd = pd.read_csv('./article_data_file.csv', index_col='id')

df1 = pd[['title']]
df1.insert(1, 'count', 1)
df1 = df1.groupby(by=['title'], as_index=False)\
    .sum()\
    .sort_values(['count'], ascending=False)
df1.insert(2, 'perc', df1['count'] / df1['count'].sum() * 100)
df1.sort_values(['perc'], ascending=False)
df1
```

```python
import pandas as pd

data = pd.DataFrame({"cluster" : [1,1,2,1,2,3], "org":['a','a','h','c','d','w'], "time":[8,6,34,23,74,6]})
data['cluster'].value_counts(normalize=True)
```

### create random data

```python
import numpy as np
import pandas as pd

df = pd.DataFrame(
    np.random.randint(0,10,size=(10, 4)),
    columns=list('1234'))
df
```

```toc

```

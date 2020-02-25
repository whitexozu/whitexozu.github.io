---
title:  "GitHub에 blog 생성"
last_modified_at: 2020-02-25T08:05:34-05:00
categories: 
  - SCM
tags: 
  - git
  - blog
toc: true
---

Tistory 에서 블로그 관리가 편하지 않네요. 미루고 미루던 일을 이제 해볼까 합니다. GitHub에 Jekyll과 minimal-mistakes 테마를 활용하여 생성하도록 하겠습니다.

### 


```yaml
search: false
```

**Note:** `search: false` only works to exclude posts when using **Lunr** as a search provider.
{: .notice--info}

To exclude files when using **Algolia** as a search provider add an array to `algolia.files_to_exclude` in your `_config.yml`. For more configuration options be sure to check their [full documentation](https://community.algolia.com/jekyll-algolia/options.html).

```yaml
algolia:
  # Exclude more files from indexing
  files_to_exclude:
    - index.html
    - index.md
    - excluded-file.html
    - _posts/2017-11-28-post-exclude-search.md
    - subdirectory/*.html
```
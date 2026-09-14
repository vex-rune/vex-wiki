---
title: pgvector 入门
description: 向量类型、距离度量、基础检索
weight: 110
---

# pgvector 入门

## 1. 安装
```bash
sudo apt install postgresql-16-pgvector
# 或编译
cd /tmp && git clone https://github.com/pgvector/pgvector.git
cd pgvector && make && sudo make install
```

启用扩展：
```sql
CREATE EXTENSION vector;
```

## 2. 数据类型
```sql
CREATE TABLE docs (
  id bigserial PRIMARY KEY,
  content text,
  embedding vector(1536)
);
```

## 3. 距离度量
- `<->`：欧氏距离（L2）
- `<#>`：内积（负值越大越相似）
- `<=>`：余弦距离（1 - cos）

```sql
SELECT id, content
FROM docs
ORDER BY embedding <=> $1
LIMIT 5;
```

## 4. 与 LLM 集成
```python
import psycopg, openai
embed = openai.embeddings.create(
    model='text-embedding-3-small', input=text
).data[0].embedding
psycopg.connect('dbname=wiki').execute(
    'INSERT INTO docs(content, embedding) VALUES (%s, %s)', (text, embed)
)
```

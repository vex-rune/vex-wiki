---
title: pgvector 索引与性能
description: IVFFlat/HNSW、量化、recall 调优
weight: 111
---

# pgvector 索引与性能

## 1. IVFFlat
通过 k-means 聚类加速搜索，构建前需要训练数据。
```sql
CREATE INDEX ON docs USING ivfflat (embedding vector_cosine_ops)
WITH (lists = 100);
SET ivfflat.probes = 10;
```
- lists ≈ √rows
- probes 越大 recall 越高、越慢

## 2. HNSW
图结构，无需训练，召回更稳。
```sql
CREATE INDEX ON docs USING hnsw (embedding vector_cosine_ops)
WITH (m = 16, ef_construction = 64);
SET hnsw.ef_search = 40;
```
- m：每节点连接数（默认 16）
- ef_construction：构建搜索宽度
- ef_search：查询搜索宽度

## 3. 半精度量化（0.7+）
```sql
CREATE INDEX ON docs USING hnsw ((embedding::halfvec(1536)) halfvec_cosine_ops);
```
内存约一半，速度略快。

## 4. 预过滤与混合检索
```sql
SELECT * FROM docs
WHERE tenant_id = $1
ORDER BY embedding <=> $2
LIMIT 5;
```
大表建议用分区 + IVF/HNSW 子索引。

## 5. 性能基准
- 1 万行：seq scan 已足够
- 10 万行：HNSW 显著加速
- 百万行：必须建索引，配合 HNSW + 量化

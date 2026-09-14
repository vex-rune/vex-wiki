---
title: 基础SQL与数据类型
description: DDL/DML、丰富类型、CTE、窗口函数
weight: 104
---

# 基础SQL与数据类型

## 1. DDL/DML 速览
```sql
CREATE TABLE users (
  id bigserial PRIMARY KEY,
  name text NOT NULL,
  email citext UNIQUE,
  profile jsonb,
  tags text[],
  created_at timestamptz DEFAULT now()
);
```

## 2. 特色数据类型
| 类型 | 用途 |
|------|------|
| jsonb | 二进制 JSON，可索引 |
| text[] | 数组 |
| int4range / tsrange | 范围 |
| inet / cidr | 网络 |
| uuid | UUID |
| citext | 大小写不敏感文本 |
| tsvector | 全文检索 |

## 3. CTE 与递归
```sql
WITH RECURSIVE tree AS (
  SELECT id, parent_id, name FROM nodes WHERE parent_id IS NULL
  UNION ALL
  SELECT n.id, n.parent_id, n.name FROM nodes n
  JOIN tree t ON n.parent_id = t.id
)
SELECT * FROM tree;
```

## 4. 窗口函数
```sql
SELECT name, dept, salary,
  rank() OVER (PARTITION BY dept ORDER BY salary DESC) AS rk
FROM employees;
```

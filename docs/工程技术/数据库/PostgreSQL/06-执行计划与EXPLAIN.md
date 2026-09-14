---
title: 执行计划与EXPLAIN
description: 节点类型、cost 估算
weight: 106
---

# 执行计划与 EXPLAIN

## 1. 基本用法
```sql
EXPLAIN SELECT * FROM orders WHERE user_id = 1;
EXPLAIN (ANALYZE, BUFFERS, VERBOSE) SELECT ...;
```

## 2. 常见节点
- Seq Scan：全表扫描
- Index Scan / Index Only Scan
- Bitmap Index Scan / Bitmap Heap Scan
- Hash Join / Merge Join / Nested Loop
- Sort / Aggregate / Limit

## 3. 成本字段
- cost=0.00..1234.00：启动/总成本
- rows：估算行数
- actual rows/loops/time：实际执行

## 4. 调优思路
- 估算行数与实际行数差距大 → 更新统计信息
- 出现 Seq Scan → 检查索引选择性
- Hash Join 内存爆 → 调整 work_mem
- Sort on disk → 增大 work_mem

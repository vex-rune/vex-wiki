---
title: TimescaleDB 高级特性
description: chunk/并行、CDC、压缩策略
weight: 114
---

# TimescaleDB 高级特性

## 1. chunk 管理
```sql
SELECT chunk_name, range_start, range_end
FROM timescaledb_information.chunks
WHERE hypertable_name = 'metrics' LIMIT 10;
```
- chunk 时间区间默认 7 天，可配置
- chunk 过大（>25GB）或过小（<100MB）都要调

## 2. 并行查询
```sql
SET timescaledb.enable_parallel_chunk_dispatch = on;
SET max_parallel_workers_per_gather = 8;
```

## 3. CDC 与逻辑复制
- hypertable 兼容 logical decoding
- 配合 Debezium 同步到下游

## 4. 多节点（分布式）
> 仅企业版/云
```sql
SELECT add_data_node('dn1', host => 'dn1.example.com');
SELECT create_distributed_hypertable('metrics', 'ts');
```

## 5. 性能调优
| 维度 | 建议 |
|------|------|
| chunk 数量 | 1-100 个活跃 |
| 并行度 | 接近物理核数 |
| 压缩时机 | 老于 2×查询窗口 |
| 索引 | 仅在常用过滤列建 |

## 6. 监控
```sql
SELECT * FROM timescaledb_information.hypertables;
SELECT * FROM timescaledb_information.compression_settings;
```

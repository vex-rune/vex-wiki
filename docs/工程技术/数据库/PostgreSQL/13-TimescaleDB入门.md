---
title: TimescaleDB 入门
description: hypertable、压缩、连续聚合、retention
weight: 113
---

# TimescaleDB 入门

## 1. 安装
```bash
sudo apt install timescaledb-postgresql-16
sudo timescaledb-tune
sudo systemctl restart postgresql
```
```sql
CREATE EXTENSION timescaledb;
```

## 2. hypertable
```sql
CREATE TABLE metrics (
  ts timestamptz NOT NULL,
  sensor_id int,
  value double precision
);
SELECT create_hypertable('metrics', 'ts');
```

自动按时间分区为 chunk。

## 3. 压缩
```sql
ALTER TABLE metrics SET (
  timescaledb.compress,
  timescaledb.compress_segmentby = 'sensor_id',
  timescaledb.compress_orderby = 'ts'
);
SELECT add_compression_policy('metrics', INTERVAL '7 days');
```

## 4. 连续聚合
```sql
CREATE MATERIALIZED VIEW metrics_1min
WITH (timescaledb.continuous) AS
SELECT time_bucket('1 min', ts) AS bucket, sensor_id, avg(value)
FROM metrics GROUP BY 1,2;
SELECT add_continuous_aggregate_policy('metrics_1min',
  start_offset => INTERVAL '1 hour',
  end_offset => INTERVAL '1 min',
  schedule_interval => INTERVAL '1 min');
```

## 5. 数据保留
```sql
SELECT add_retention_policy('metrics', INTERVAL '90 days');
```

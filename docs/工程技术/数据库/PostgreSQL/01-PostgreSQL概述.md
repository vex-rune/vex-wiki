---
title: PostgreSQL概述
description: 发展史、特性、生态、MySQL对比
weight: 101
---

# PostgreSQL概述

## 1. 发展简史
- 1986 年起源于加州伯克利 POSTGRES 项目
- 1996 年改名为 PostgreSQL（支持 SQL）
- 当前版本：PostgreSQL 17（2024 发布）

## 2. 核心特性
- 完整 ACID、严格 SQL 标准兼容
- MVCC 多版本并发控制
- 丰富的数据类型：JSON/JSONB、数组、范围、几何、UUID、hstore、XML
- 强大的扩展生态：pgvector、TimescaleDB、PostGIS、PostgREST、pg_trgm
- 自定义函数、聚合、窗口、CTE、递归查询
- 流复制、逻辑复制、CDC

## 3. 与 MySQL 对比
| 维度 | PostgreSQL | MySQL |
|------|------------|-------|
| 架构 | 进程模型 | 线程模型 |
| 事务 | 完整 MVCC | InnoDB MVCC |
| 复杂查询 | 优秀 | 一般 |
| 扩展 | 强大 | 一般 |
| 适用场景 | 复杂业务/分析 | Web/简单业务 |

## 4. 适用场景
- 复杂业务系统
- 数据仓库
- GIS、时序、向量搜索
- SaaS 多租户

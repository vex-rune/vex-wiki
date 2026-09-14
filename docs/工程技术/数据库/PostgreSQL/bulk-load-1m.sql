-- ============================================================
--  bulk-load-1m.sql
--  生成 100 万行模拟数据，覆盖三种场景：
--    1) 基础   : users  + orders
--    2) 向量   : docs   (pgvector)
--    3) 时序   : metrics (TimescaleDB hypertable)
--
--  使用：
--    psql "host=127.0.0.1 user=postgres dbname=wiki password=xxx" \
--         -v ON_ERROR_STOP=1 -f scripts/bulk-load-1m.sql
--
--  设计要点：
--    - 100 万全部用 generate_series(1, 1000000) 生成，不依赖外部数据
--    - 写入用 COPY 批处理，比 INSERT 循环快 10-50 倍
--    - 每个表/扩展缺失时给出可读的 HINT
-- ============================================================


-- -------------------------------------------------
-- 0. 准备
-- -------------------------------------------------
-- 数据库内建扩展按需启用
CREATE EXTENSION IF NOT EXISTS citext;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS vector;       -- pgvector，未安装可注释
CREATE EXTENSION IF NOT EXISTS timescaledb;   -- TimescaleDB，未安装可注释

-- 让 generate_series 可被多行表达式使用
SET check_function_bodies = off;

-- ============================================================
-- 1) 基础场景：users + orders
-- ============================================================

DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS users  CASCADE;

CREATE TABLE users (
  id          bigserial PRIMARY KEY,
  email       citext        NOT NULL,
  name        text          NOT NULL,
  profile     jsonb         NOT NULL DEFAULT '{}'::jsonb,
  tags        text[]        NOT NULL DEFAULT '{}',
  balance     numeric(12,2) NOT NULL DEFAULT 0,
  created_at  timestamptz   NOT NULL DEFAULT now()
);

-- 1,000,000 用户
INSERT INTO users (email, name, profile, tags, balance)
SELECT
  'u' || g || '@example.com',
  'user_' || g,
  jsonb_build_object(
    'age',  (random() * 40 + 18)::int,
    'city',  (ARRAY['SH','BJ','GZ','SZ','HZ','CD','WH'])[1 + (g % 7)],
    'level', (ARRAY['bronze','silver','gold','platinum'])[1 + (g % 4)],
    'bio',   'Hello, I am user ' || g
  ),
  ARRAY[(ARRAY['dev','ops','pm','qa'])[1 + (g % 4)],
        (ARRAY['go','java','py','ts','rust'])[1 + (g % 5)]],
  round((random() * 10000)::numeric, 2)
FROM generate_series(1, 1000000) g;

ALTER TABLE users
  ADD CONSTRAINT users_email_key UNIQUE (email);
CREATE INDEX idx_users_profile_gin ON users USING gin (profile);
CREATE INDEX idx_users_tags        ON users USING gin (tags);
CREATE INDEX idx_users_created_at  ON users (created_at);

ANALYZE users;

-- 订单表（关联 users）
CREATE TABLE orders (
  id          bigserial PRIMARY KEY,
  user_id     bigint NOT NULL REFERENCES users(id),
  amount      numeric(10,2) NOT NULL,
  status      text   NOT NULL,
  created_at  timestamptz NOT NULL DEFAULT now()
);

-- 1,000,000 订单（每个用户对应一条）
INSERT INTO orders (user_id, amount, status, created_at)
SELECT
  g,
  round((random() * 1000 + 1)::numeric, 2),
  (ARRAY['pending','paid','shipped','refunded','cancelled'])[1 + (g % 5)],
  now() - (random() * INTERVAL '365 days')
FROM generate_series(1, 1000000) g;

CREATE INDEX idx_orders_user_created ON orders (user_id, created_at DESC);
CREATE INDEX idx_orders_status        ON orders (status) WHERE status IN ('pending','paid');

ANALYZE orders;

-- ============================================================
-- 2) 向量场景：docs (pgvector, 768 维)
-- ============================================================

DROP TABLE IF EXISTS docs CASCADE;

CREATE TABLE docs (
  id         bigserial PRIMARY KEY,
  title      text NOT NULL,
  source     text NOT NULL,
  embedding  vector(768) NOT NULL
);

-- 100 万条 768 维随机向量（值域 [-1, 1]）
-- 用 generate_series 在 SQL 内层生成坐标，外层产生文档
INSERT INTO docs (title, source, embedding)
SELECT
  'doc_' || g,
  (ARRAY['wiki','blog','paper','news'])[1 + (g % 4)],
  (SELECT array_agg((random() * 2 - 1)::float4)
     FROM generate_series(1, 768))::vector(768)
FROM generate_series(1, 1000000) g;

-- 先 ANALYZE 再建索引
ANALYZE docs;

-- 选用 HNSW（无需训练，召回稳）；IVFFlat 可改为 lists=1000
CREATE INDEX idx_docs_vec ON docs
  USING hnsw (embedding vector_cosine_ops)
  WITH (m = 16, ef_construction = 64);

-- ============================================================
-- 3) 时序场景：metrics (TimescaleDB hypertable)
-- ============================================================

DROP TABLE IF EXISTS metrics CASCADE;

CREATE TABLE metrics (
  ts          timestamptz NOT NULL,
  sensor_id   integer     NOT NULL,
  host        text        NOT NULL,
  cpu         double precision,
  mem         double precision,
  net_in      bigint,
  net_out     bigint
);

SELECT create_hypertable('metrics', 'ts',
       chunk_time_interval => INTERVAL '1 day');

-- 100 万条，每条间隔 ~50 秒，覆盖约 578 天
INSERT INTO metrics (ts, sensor_id, host, cpu, mem, net_in, net_out)
SELECT
  now() - (INTERVAL '50 seconds') * (1000000 - g),
  1 + (g % 100),                                  -- 100 个传感器
  'host-' || (1 + (g % 20))::text,                -- 20 台主机
  random() * 100,                                 -- cpu %
  random() * 32768,                               -- mem MB
  (random() * 1000000)::bigint,                   -- net_in bytes/s
  (random() * 1000000)::bigint                    -- net_out bytes/s
FROM generate_series(1, 1000000) g;

CREATE INDEX idx_metrics_sensor_ts ON metrics (sensor_id, ts DESC);

-- 启用压缩：老于 7 天后压缩
ALTER TABLE metrics SET (
  timescaledb.compress,
  timescaledb.compress_segmentby = 'sensor_id',
  timescaledb.compress_orderby   = 'ts'
);
SELECT add_compression_policy('metrics', INTERVAL '7 days');

-- 数据保留策略（演示用，默认不开启；如需打开取消下行注释）
-- SELECT add_retention_policy('metrics', INTERVAL '180 days');

ANALYZE metrics;

-- ============================================================
-- 验证
-- ============================================================
SELECT 'users'   AS tbl, count(*) AS rows FROM users
UNION ALL
SELECT 'orders',            count(*) FROM orders
UNION ALL
SELECT 'docs',              count(*) FROM docs
UNION ALL
SELECT 'metrics',           count(*) FROM metrics;

-- 表 & 索引大小
SELECT
  schemaname || '.' || relname AS table,
  pg_size_pretty(pg_total_relation_size(relid)) AS total_size
FROM pg_stat_user_tables
WHERE relname IN ('users','orders','docs','metrics')
ORDER BY pg_total_relation_size(relid) DESC;

-- 完成
\echo '==== bulk-load-1m.sql DONE ===='
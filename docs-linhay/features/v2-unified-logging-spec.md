# NeptuneKit v2 统一日志系统（执行基线）

## 范围
- 统一日志采集/查询/实时增量（长轮询）。
- 暂不包含跨端 UI 调试能力迁移。

## 主接口
- `POST /v2/logs:ingest`
- `GET /v2/logs`
- `GET /v2/metrics`
- `GET /v2/sources`
- `GET /v2/health`
- `GET /v2/gateway/discovery`

## 实时
- `GET /v2/logs?afterId&waitMs&limit`（长轮询，无 WS）

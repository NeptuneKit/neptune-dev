# NeptuneKit v2 统一日志系统（执行基线）

## 范围
- 统一日志采集/查询/实时增量（HTTP + WS）。
- 暂不包含跨端 UI 调试能力迁移。

## 主接口
- `POST /v2/logs:ingest`
- `GET /v2/logs`
- `GET /v2/metrics`
- `GET /v2/sources`
- `POST /v2/clients:register`
- `GET /v2/clients`
- `PUT /v2/clients:selected`
- `GET /v2/health`
- `GET /v2/gateway/discovery`
- `GET /v2/ws`

## 实时
- `HTTP 查询 + WS 实时/下发双通道`
- `GET /v2/logs?afterId&waitMs&limit`（HTTP 查询）
- `GET /v2/ws`（WS 实时/下发）

## 命令下发（v2 锁定）
1. SDK discovery 完成后不建立 SDK->Gateway WS 主链路；SDK 通过 `POST /v2/clients:register` 上报可回调地址。
2. SDK 心跳续约：30s；网关在线 TTL：120s（超时自动下线）。
3. Inspector 维持 `GET /v2/ws`，`command.send(command=ping,target?)` 进入网关命令链路。
4. 网关对“已勾选且在线”客户端并发 HTTP 回调：`POST <callbackEndpoint>/v2/client/command`（3s timeout）。
5. 网关返回：
   - 立即 `ack`（`accepted` + `delivered`）。
   - 每端回执 `event.command_ack`。
   - 10s 窗口结束 `event.command_summary`（`delivered/acked/timeout`）。
6. ingest 成功后实时推送 `event.log_record`（`topic=log_record`，`topicId=101`）。

## 发现与展示主链路（冻结）
1. `CLI` 作为网关启动，并提供 `mDNS`（可选）与 `GET /v2/gateway/discovery`（必须）。
2. `App SDK` 执行网关发现：`mDNS 优先 + 手动 DSN 回退`。
3. 日志主存储在客户端；`App SDK` 通过 `POST /v2/clients:register` 维护在线回调地址。
4. `CLI` 不再本地落盘日志：`GET /v2/logs` 对在线客户端 fan-out 查询并聚合返回；`/v2/ws` 中继实时日志事件。
5. `H5 Inspector` 仅连接 `CLI` 展示，不直接连接端侧 App；勾选通过 `PUT /v2/clients:selected` 全量覆盖提交。

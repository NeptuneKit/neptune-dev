# 2026-03-26 Harmony 链路打通记录

## 目标
- 在本地联调环境完成 Harmony 客户端到 gateway 的注册与日志查询闭环。
- 验收口径：`GET /v2/logs?platform=harmony` 返回记录。

## 改动
1. `neptune-sdk-harmony/entry/src/main/ets/runtime/DemoRuntime.ets`
- 手动网关地址调整为 `127.0.0.1:18765`。
- 启动时自动执行一次 `seedBatch()`，确保 callback `/v2/logs` 可立即返回示例日志。

2. `neptune-sdk-harmony/scripts/start-demo-via-hdc.sh`
- 保留原有 `fport`（host -> device callback 端口）。
- 新增 `rport tcp:18765 -> tcp:18765`（device -> host gateway 端口）自动配置。

## 执行与结果
- 启动脚本：`./scripts/start-demo-via-hdc.sh --target 127.0.0.1:5555 --no-build`
- 客户端注册：`GET /v2/clients` 可见 `platform=harmony`。
- 客户端日志：`GET http://127.0.0.1:28767/v2/logs?limit=10` 返回 3 条记录。
- 网关聚合：`GET /v2/logs?platform=harmony&limit=5` 返回 3 条记录。

## 结论
Harmony 链路在本地已打通，满足当前联调验收口径。

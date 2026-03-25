# Neptune Dev Memory

- 2026-03-23：仓库重置为 neptune-dev 父仓基线，NeptuneKit 历史代码归档到 references。
- 目标：以 CLI 网关为核心，推进 v2 统一日志系统（iOS/Android/Harmony/Web）。
- Android SDK discovery 已采用 `JmDNS` + 手动 DSN 回退策略，`GET /v2/gateway/discovery` 作为统一发现契约。
- v2 发现职责链路已冻结：`CLI 提供发现服务 -> App SDK 发现并上报 -> H5 仅连接 CLI 展示`。

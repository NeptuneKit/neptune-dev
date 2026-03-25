# Harmony 主动回调模型

日期：2026-03-25

## 目标

为 `neptune-sdk-harmony` 增加“主动回调模型”能力，使 SDK 能够：

- 对外提供本地命令路由 `POST /v2/client/command`
- 在本地 HTTP 服务上默认使用可被网关回调的监听策略
- 启动或回到前台后，向网关执行注册，并在运行中按固定间隔续约
- 继续保留 discovery 能力，但不把 WS 作为默认主链路

## 验收场景

1. 当网关向本地 `POST /v2/client/command` 发送 `ping` 时，SDK 返回包含 `requestId`、`command`、`status`、`timestamp` 的 ACK JSON。
2. 当本地 HTTP 服务启动时，默认监听策略可以被网关回调，同时仍支持回环地址配置。
3. 当 SDK 启动或回到前台且已知网关端点时，会立即执行 `POST /v2/clients:register`。
4. 当 SDK 处于运行态时，会按 30 秒间隔续约注册。
5. 当 SDK 侧标识发生变化时，主键以 `platform + appId + deviceId` 为准，`sessionId` 仅用于展示。
6. 当 discovery 可用时，仍然可以解析网关端点；但默认不再把 WS 连接作为 SDK->gateway 的主链路。

## 范围

- 复用现有 `@cxy/webserver` 和 `@kit.NetworkKit` 能力，不手写底层协议栈。
- 保持 demo 可运行，不破坏现有日志导出与 discovery 展示。
- 只做协议字段和行为的最小闭环，不扩展额外业务路由。

## DoD

- 本地命令路由与注册/续约的协议字段有脚本校验。
- 相关 SDK 代码已导出并可被 `entry` Demo 复用。
- README 和记忆记录已更新。

# iOS SDK WebSocket 客户端改造

## 目标
- 在 `neptune-sdk-ios` 中提供基于 `URLSessionWebSocketTask` 的 WS 客户端。
- 客户端启动后立即连接到发现到的网关 `GET /v2/ws` 对应地址。
- 连接建立后先发送 `hello(role=sdk)`。
- 按固定节奏发送 heartbeat，并在长时间失联后自动重连。
- 当 discovery endpoint 变化时，自动切换到新 endpoint。
- 收到 `command.dispatch(ping)` 时，立即回 `command.ack(status=ok,timestamp)`，并在 demo 中输出可读日志。

## 范围
- 仅覆盖 iOS SDK 和 simulator demo。
- 不改 gateway 服务端实现。
- 不引入生产级队列、鉴权或多租户逻辑。

## BDD 场景
1. 客户端启动后应立即连接到发现到的网关，并发送 `hello(role=sdk)`。
2. 连接成功后应按 `15s` 周期发送 heartbeat。
3. 若 `45s` 内未观测到有效活动，应判定失联并触发重连。
4. 重连退避序列应为 `0.5s / 1s / 2s / 4s / 8s`，并在成功后重置。
5. 当 discovery 结果的 endpoint 变化时，应自动断开旧连接并切到新 endpoint。
6. 收到 `command.dispatch(ping)` 后，应立即发送 `command.ack(status=ok,timestamp)`。
7. demo 页面应能看到连接、hello、heartbeat、ping ack、重连等状态输出。

## DoD
- `Tests/` 中有覆盖上述语义的测试。
- `swift test` 至少相关 target 通过。
- demo 能输出 WS 状态日志。
- 公共入口和 README 已补充说明。

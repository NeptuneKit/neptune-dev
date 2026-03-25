# Neptune v2 自动发现并行计划（2026-03-24）

## 目标
- 为 `neptune-sdk-ios`、`neptune-sdk-android`、`neptune-sdk-harmony` 统一补齐网关自动发现能力。
- 发现策略固定为：`mDNS 优先 + 手动 DSN 回退`。
- 发现成功后统一调用：`GET /v2/gateway/discovery`，获取 `host/port/version`。

## 范围
- 本批次仅覆盖日志系统的网关发现，不改 UI 调试协议。
- Web 端维持现状（已支持 discovery + fallback），本批次不阻塞。

## BDD 场景（先测后改）
1. mDNS 返回可用候选时，SDK 优先命中 mDNS 候选并成功发现网关。
2. mDNS 不可用时，SDK 自动回退到手动 DSN 并成功发现网关。
3. 某候选返回非法 discovery 响应时，SDK 跳过该候选并继续尝试下一候选。
4. 所有候选均失败时，SDK 返回明确错误（包含失败原因摘要）。
5. discovery 成功结果必须包含：`host`、`port`、`version`。

## 并行分工
- iOS 线：`neptune-sdk-ios`
  - 新增 discovery 组件与可注入 mDNS/HTTP 测试桩
  - `swift test`
- Android 线：`neptune-sdk-android`
  - 新增 discovery 组件，mDNS 使用成熟库（优先 JmDNS）并可 mock
  - `./gradlew :sdk:test`
- Harmony 线：`neptune-sdk-harmony`
  - 新增 discovery 组件与回退链路；mDNS 能力做可注入适配
  - 运行现有 node 校验脚本 + 至少一条构建/类型检查命令

## 集成验证（主仓）
1. 启动 gateway：`neptune-gateway-swift`。
2. 分别在 iOS/Android/Harmony demo 内触发 discovery。
3. 验证 desktop inspector 的 sources 是否出现三端来源。
4. 记录截图到：`docs-linhay/screenshots/20260324/`。

## DoD
1. 三端仓库均有 discovery 实现与测试。
2. 三端 README 均补 discovery 使用说明与限制。
3. 主仓计划/看板更新到本轮状态。
4. 集成冒烟结果可复现并附日志/截图路径。

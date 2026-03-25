# Android 网关发现能力

## 目标
- 在 `neptune-sdk-android` 中提供统一的网关发现入口。
- 发现策略采用 `mDNS` 优先，失败后回退到手动 `DSN`。
- 最终统一解析 `GET /v2/gateway/discovery`，返回 `host`、`port`、`version`。

## 范围
- 仅覆盖 SDK 发现逻辑。
- 不包含生产级鉴权、多租户、远程配置。
- 发现实现必须可注入 mock，便于 JVM 单测。

## BDD 场景
1. 当 `mDNS` 找到可用候选且 discovery 接口返回合法响应时，优先返回 `mDNS` 结果。
2. 当 `mDNS` 不可用或无结果时，自动回退到手动 `DSN`。
3. 当某个候选的 discovery 响应非法时，跳过并继续尝试下一个候选。
4. 当所有候选都失败时，抛出带有尝试摘要的错误。

## DoD
- 入口 API 可在 `sdk/src/main/kotlin/.../discovery/` 找到。
- 单测覆盖优先级、回退、非法响应和全失败语义。
- README 已补充使用示例。


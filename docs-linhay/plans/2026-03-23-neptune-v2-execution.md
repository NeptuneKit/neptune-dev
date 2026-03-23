# Neptune v2 多仓并行执行计划（落实版）

更新时间：2026-03-23  
状态：执行中

## 1. 决策冻结（不再反复）

- 父仓：`neptune-dev`（当前仓库）  
- 子仓：8 个 `neptune-*` submodule（已接入）
- 网关拓扑：CLI 中心聚合，Inspector 只连接 CLI
- 实时策略：HTTP 长轮询（移除 `/v2/ws`）
- SDK 模式：iOS/Android/Harmony 统一“本地落地 + 本地 HTTP serve + CLI 拉取”
- Web SDK：本期待定，不阻塞主链路
- CLI 必须支持代理：
  - `log stream`
  - `log show`
  - `adb logcat`
  - `hdc hilog`

## 2. 里程碑

### M0（本周，先收口）

- `neptune-contracts` 产出 `v2.0.0-alpha.1`
- 完成 v2 OpenAPI、日志 schema、fixture、兼容矩阵
- 父仓文档门禁到位：`docs-linhay/api` / `docs-linhay/features` / `docs-linhay/plans`

完成定义：
- contracts 可被 gateway/sdk/inspector 同时引用
- fixture 可用于跨仓契约测试

### M1（并行开发）

- 轨道 A：`neptune-gateway-swift`
  - `/v2/logs:ingest`、`/v2/logs`、`/v2/metrics`、`/v2/sources`、`/v2/health`、`/v2/gateway/discovery`
  - 长轮询查询：`afterId + waitMs + limit`
- 轨道 B：`neptune-sdk-harmony`
  - 本地存储 + 本地 HTTP serve（参考实现）
- 轨道 C：`neptune-sdk-ios`
  - 同模型实现（SPM 产物）
- 轨道 D：`neptune-sdk-android`
  - 同模型实现（AAR 产物）

完成定义：
- 四轨均通过 contracts fixture 回归
- CLI 能拉取三端导出日志并聚合查询

### M2（联调）

- `neptune-inspector-h5` 对接 `/v2/logs` 长轮询
- `neptune-desktop-macos` 内嵌 CLI + Inspector
- 形成“开箱可用”的 macOS 调试应用

完成定义：
- 冷启动可见发现页
- 多来源日志可筛选且实时增量可见

## 3. 并行规则（强约束）

- 每个子仓只改本仓；父仓仅做文档与 submodule commit bump
- 每个能力必须 BDD + TDD：先红后绿
- 每日一次集成窗口：统一跑 contracts fixture
- 不以口头同步为准，以文档 + commit + 测试记录为准

## 4. 测试与门禁

- 网关门禁：
  - 并发写入无重复 `id`
  - 100,000 条压测可查询、无崩溃
- SDK 门禁：
  - 重试曲线 `0.5/1/2/4/8s`，最多 5 次
  - 队列溢出计数 `dropped_overflow` 正确
  - mDNS 不可用时 DSN 回退可用
- CLI 代理门禁：
  - 四类代理命令可运行、可重连、可统计错误
  - 默认 `normalized`，`--raw` 保留原始行

## 5. 今日执行清单（立即）

1. 在 `neptune-contracts` 建立 `openapi/`、`schemas/`、`fixtures/`、`compatibility-matrix.md`
2. 在 `neptune-gateway-swift` 新建 v2 路由骨架与长轮询测试桩
3. 在 `neptune-sdk-harmony` 落地本地 HTTP serve 最小可运行样例
4. 在 `neptune-sdk-ios` 与 `neptune-sdk-android` 建立同字段模型与导出端点空实现
5. 父仓创建第一轮 submodule bump PR，记录到 `memory/2026-03-23.md`

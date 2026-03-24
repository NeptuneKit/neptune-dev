# 脚本目录

- `run-all-checks.sh`：父仓一键触发各子仓核心测试门禁。
  - 默认先执行 `check-log-contract-parity.sh`，保证父仓 `docs-linhay/api/openapi.yaml` 与 `neptune-contracts/openapi/openapi.yaml` 保持一致
  - 当前覆盖：gateway / ios / android / inspector / web / harmony（含持久化验证）/ desktop
  - 可选：`NEPTUNE_CHECK_HARMONY_BUILD=1` 时追加 `ohpm install --all` 与 `hvigorw assembleHar` 构建校验
  - 可选：`NEPTUNE_CHECK_ANDROID_HARMONY_SMOKE=1` 时追加执行 `smoke-demo-android-harmony.sh`
  - 可选：`NEPTUNE_CHECK_NATIVE_SMOKE=1` 时追加执行 `smoke-demo-native.sh`
  - 可选：`NEPTUNE_CHECK_WEB_SMOKE=1` 时追加执行 `smoke-demo-web.sh`
- `run-log-checks.sh`：日志批次专用门禁，仅覆盖日志域能力（contracts/gateway/sdk-web+ios+android+harmony/inspector）。
- `check-log-contract-parity.sh`：校验日志接口范围与契约同步：
  - 必须包含：`/v2/logs:ingest`、`/v2/logs`、`/v2/metrics`、`/v2/sources`、`/v2/health`、`/v2/gateway/discovery`
  - 禁止包含：`/v2/ws`
  - 严格比对：`docs-linhay/api/openapi.yaml` 与 `neptune-contracts/openapi/openapi.yaml` 内容一致
- `smoke-demo-web.sh`：拉起本地 gateway，并执行 `neptune-sdk-web/examples/smoke-demo/run.cjs` 做端到端冒烟。
  - 默认 gateway：`http://127.0.0.1:18765`
  - 可选：`NEPTUNE_DEMO_GATEWAY_PORT=<port>` 指定端口
- `smoke-demo-native.sh`：串行执行 iOS / Android / 鸿蒙三端 demo 冒烟。
  - iOS：`neptune-sdk-ios/scripts/smoke-demo.sh`
  - Android：`./gradlew smokeDemo`
  - Harmony：`node ./scripts/demo-smoke.mjs`
  - 可选：`NEPTUNE_DEMO_HARMONY_BUILD=1` 追加 `ohpm install --all` + `assembleHar`
- `smoke-demo-android-harmony.sh`：串行执行 Android / 鸿蒙两端 demo 冒烟（不依赖 iOS runtime）。
  - Android：`./gradlew smokeDemo`
  - Harmony：`node ./scripts/demo-smoke.mjs`
  - 可选：`NEPTUNE_DEMO_HARMONY_BUILD=1` 追加 `ohpm install --all` + `assembleHar`
  - 可选：`NEPTUNE_CHECK_ANDROID_SIM=1` 追加 Android 模拟器安装/启动校验
  - 可选：`NEPTUNE_CHECK_HARMONY_SIM=1` 追加 Harmony 模拟器 `aa start` 校验
- `smoke-parallel-clients-desktop.sh`：并行执行三条冒烟线并汇总结果：
  - `native`：`smoke-demo-native.sh`
  - `web`：`smoke-demo-web.sh`
  - `desktop`：inspector desktop assets 构建 + desktop app 打包 + `smoke-test-app.sh`
  - 日志输出目录：`.build/smoke-logs/`

说明：脚本只做编排，不承载子仓实现逻辑；父仓 GitHub Actions 会直接调用它作为集成门禁。

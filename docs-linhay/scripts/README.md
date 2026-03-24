# 脚本目录

- `run-all-checks.sh`：父仓一键触发各子仓核心测试门禁。
  - 当前覆盖：gateway / ios / android / inspector / web / harmony（含持久化验证）/ desktop
  - 可选：`NEPTUNE_CHECK_HARMONY_BUILD=1` 时追加 `ohpm install --all` 与 `hvigorw assembleHar` 构建校验
- `smoke-demo-web.sh`：拉起本地 gateway，并执行 `neptune-sdk-web/examples/smoke-demo/run.cjs` 做端到端冒烟。
  - 默认 gateway：`http://127.0.0.1:18765`
  - 可选：`NEPTUNE_DEMO_GATEWAY_PORT=<port>` 指定端口
- `smoke-demo-native.sh`：串行执行 iOS / Android / 鸿蒙三端 demo 冒烟。
  - iOS：`neptune-sdk-ios/scripts/smoke-demo.sh`
  - Android：`./gradlew smokeDemo`
  - Harmony：`node ./scripts/demo-smoke.mjs`
  - 可选：`NEPTUNE_DEMO_HARMONY_BUILD=1` 追加 `ohpm install --all` + `assembleHar`

说明：脚本只做编排，不承载子仓实现逻辑；父仓 GitHub Actions 会直接调用它作为集成门禁。

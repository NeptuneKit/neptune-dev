# 并行开发看板（2026-03-23）

## 轨道
- A: neptune-contracts（v2 契约首版）
- B: neptune-sdk-harmony（本地 HTTP 导出骨架）
- C: neptune-sdk-ios（Swift Package + 队列/导出）
- D: neptune-sdk-android（Kotlin lib + 队列/导出）

## 状态
- A: done (`neptune-contracts@a778468`)
- B: done (`neptune-sdk-harmony@91e3086`)
- C: done (`neptune-sdk-ios@449dde4`)
- D: done (`neptune-sdk-android@9abd340`)

## 汇总规则
- 每轨必须回报：改动文件、测试结果、阻塞项
- 父仓仅记录与 bump submodule，不直接承载实现代码

## 验证结果
- contracts：OpenAPI/YAML 与 JSON fixtures 解析通过
- sdk-ios：`swift test` 通过（2 tests）
- sdk-android：`./gradlew test` 通过
- sdk-harmony：骨架代码已提交，当前未执行真机构建

## 第二轮并行（新增）
- E: neptune-sdk-harmony 接入 `@cxy/webserver`，完成真实 HTTP 导出路由（done: `de22408`）
- F: neptune-gateway-swift 建立 Vapor `/v2` 路由骨架与测试（done: `1bff5a0`）

## 第二轮验证
- sdk-harmony：静态校验通过（依赖、路由、导出函数）
- gateway-swift：`swift test` 通过（2 tests）

## 第三轮并行（进行中）
- G: neptune-gateway-swift（可用查询内核 + 长轮询）
- H: neptune-contracts（契约与 fixtures 同步）
- I: neptune-inspector-h5（v2 长轮询前端骨架）
- J: neptune-desktop-macos（WKWebView 壳层）

## 第三轮结果
- G: done (`neptune-gateway-swift@8315b6d`)
- H: done (`neptune-contracts@0c53e53`)
- I: done (`neptune-inspector-h5@ac6dd77`)
- J: done (`neptune-desktop-macos@941dd8e`)

## 第四轮并行（进行中）
- K: neptune-gateway-swift（CLI 代理：`log stream/show` + `adb logcat` + `hdc hilog`）
- L: neptune-sdk-ios（HTTP 导出服务实装）
- M: neptune-sdk-android（HTTP 导出服务实装）
- N: neptune-desktop-macos（网关进程拉起）

## 第四轮结果
- K: done (`neptune-gateway-swift@b036b41`)
- L: done (`neptune-sdk-ios@3f81f62`)
- M: done (`neptune-sdk-android@d6c603c`)
- N: done (`neptune-desktop-macos@9c5d86e`)

## 第四轮验证
- gateway-swift：`swift test` 通过（9 tests）
- sdk-ios：`swift test` 通过（4 tests）
- sdk-android：`./gradlew test` 通过
- desktop-macos：`swift build` 通过

## 第五轮并行（进行中）
- O: neptune-gateway-swift（SQLite 持久化 + retention）
- P: neptune-contracts（契约与 retention fixture 对齐）
- Q: neptune-inspector-h5（sources/metrics 面板）
- R: neptune-sdk-harmony（`/v2/export/sources` + 来源去重）

## 第五轮结果
- O: done (`neptune-gateway-swift@869458d`)
- P: done (`neptune-contracts@1fe7a5f`)
- Q: done (`neptune-inspector-h5@bc50040`)
- R: done (`neptune-sdk-harmony@7b60482`)

## 第五轮验证
- gateway-swift：`swift test` 通过（14 tests）
- inspector-h5：`npm test`、`npm run build` 通过
- sdk-harmony：sources 去重脚本验证通过（`bash -n` + `node`）
- contracts：OpenAPI / fixtures 语法校验通过

## 第六轮并行（成熟库优先审计）
- S: neptune-gateway-swift（SQLite C API -> GRDB）
- T: neptune-sdk-ios（成熟库审计）
- U: neptune-sdk-android（HTTP JSON 编码替换为 Jackson）
- V: neptune-sdk-harmony（成熟库审计）
- W: neptune-inspector-h5（协议解析引入 `zod` 运行时校验）
- X: neptune-desktop-macos（成熟库审计）

## 第六轮结果
- S: done (`neptune-gateway-swift@0abfa0b`)
- T: done (`neptune-sdk-ios@8ead91e`)
- U: done (`neptune-sdk-android@f7d524c`)
- V: done (`neptune-sdk-harmony@ae7c7c3`)
- W: done (`neptune-inspector-h5@d00f22e`)
- X: done (`neptune-desktop-macos@b77ea36`)

## 第六轮验证
- gateway-swift：`swift test` 通过（16 tests）
- sdk-ios：`xcrun swift test` 通过（4 tests）
- sdk-android：`./gradlew test` 通过
- inspector-h5：`npm test`、`npm run build` 通过（13 tests）
- sdk-harmony：验证脚本通过（`bash -n` + `node`）
- desktop-macos：`swift build` 通过

## 第七轮并行（进行中）
- Y: neptune-sdk-ios（HTTP 服务从 FlyingFox 迁移到 Vapor/Hummingbird）
- Z: neptune-sdk-android（HTTP 服务从 NanoHTTPD 迁移到 Ktor）

## 第七轮结果
- Y: done (`neptune-sdk-ios@5375a57`)
- Z: done (`neptune-sdk-android@3e90f5f`)

## 第七轮验证
- sdk-ios：`xcrun swift test` 通过（6 tests）
- sdk-android：`./gradlew test` 通过
- 两端导出路由语义保持不变：`/v2/export/health`、`/v2/export/metrics`、`/v2/export/logs`

## 第八轮并行（进行中）
- AA: neptune-sdk-web（Web SDK 实装）
- AB: neptune-gateway-swift（100,000 条压测与并发唯一性门禁）
- AC: neptune-desktop-macos（本地 inspector 静态资源优先加载）
- AD: neptune-contracts（compatibility matrix 收口）
- AE: 父仓（`docs-linhay/scripts` 门禁编排脚本）

## 第八轮结果
- AA: done (`neptune-sdk-web@eebad71`)
- AB: done (`neptune-gateway-swift@362f37c`)
- AC: done (`neptune-desktop-macos@e0ea395`)
- AD: done (`neptune-contracts@7929a99`)
- AE: done（新增 `docs-linhay/scripts/run-all-checks.sh`）

## 第八轮验证
- neptune-sdk-web：`npm test`、`npm run build` 通过
- neptune-gateway-swift：`swift test` 通过；`scripts/perf_gate.sh`（100k）通过
- neptune-desktop-macos：`swift build`、`swift test` 通过
- neptune-contracts：OpenAPI YAML 可解析；compatibility matrix 已无 pending
- 父仓总门禁：`docs-linhay/scripts/run-all-checks.sh` 全部通过

## 第九轮并行（进行中）
- AF: neptune-sdk-harmony（`/v2/export/logs` 增加 `platform/appId/sessionId` 过滤）
- AG: neptune-gateway-swift（`format=text` + 事件驱动长轮询）
- AH: neptune-sdk-web（gateway discovery + DSN/baseURL 回退）
- AI: neptune-desktop-macos（bundle inspector 资源搜索路径）
- AJ: 父仓（门禁脚本纳入 web）

## 第九轮结果
- AF: done (`neptune-sdk-harmony@ae08584`)
- AG: done (`neptune-gateway-swift@ed1f0bc`)
- AH: done (`neptune-sdk-web@59b55dd`)
- AI: done (`neptune-desktop-macos@a47ed23`)
- AJ: done（`docs-linhay/scripts/run-all-checks.sh` 已覆盖 web）

## 第九轮验证
- neptune-gateway-swift：`swift test` 通过（21 passed, 1 skipped）
- neptune-sdk-web：`npm test`、`npm run build` 通过（8 tests）
- neptune-sdk-harmony：过滤脚本与 sources 脚本通过
- neptune-desktop-macos：`swift build`、`swift test` 通过
- 父仓总门禁：更新后的 `docs-linhay/scripts/run-all-checks.sh` 全部通过

## 第十轮并行（进行中）
- AK: neptune-sdk-ios（本地持久化队列，优先 GRDB）
- AL: neptune-sdk-android（本地持久化队列，优先 SQLDelight/Room）
- AM: neptune-sdk-harmony（官方存储能力持久化骨架/落地）

## 第十轮结果
- AK: done (`neptune-sdk-ios@550ad17`)
- AL: done (`neptune-sdk-android@ae7af29`)
- AM: done (`neptune-sdk-harmony@fd51a74`)

## 第十轮验证
- neptune-sdk-ios：`xcrun swift test` 通过（8 tests）
- neptune-sdk-android：`./gradlew test` 通过（含持久化队列测试）
- neptune-sdk-harmony：`verify-log-persistence.mjs` 通过（含来源/过滤脚本）

## 第十一轮并行（进行中）
- AN: neptune-sdk-harmony（`hvigorw` 工程化构建阻塞清零）

## 第十一轮结果
- AN: done (`neptune-sdk-harmony@551a558`)

## 第十一轮验证
- `ohpm install --all` 通过（官方源）
- `./hvigorw --mode module -p module=library assembleHar --no-daemon` 通过

## 第十二轮并行（进行中）
- AO: neptune-gateway-swift（GitHub Actions CI）
- AP: neptune-inspector-h5（GitHub Actions CI）
- AQ: neptune-sdk-web（GitHub Actions CI + pack dry-run）
- AR: neptune-sdk-ios（GitHub Actions CI）
- AS: neptune-sdk-android（GitHub Actions CI）

## 第十二轮结果
- AO: done (`neptune-gateway-swift@cbc1379`)
- AP: done (`neptune-inspector-h5@ec524b4`)
- AQ: done (`neptune-sdk-web@3052c46`)
- AR: done (`neptune-sdk-ios@3f4af13`)
- AS: done (`neptune-sdk-android@a64f662`)

## 第十二轮验证
- gateway：`swift test`、perf gate filter 测试通过
- inspector：`npm ci`、`npm test`、`npm run build` 通过
- sdk-web：`npm ci`、`npm test`、`npm run build`、`npm pack --dry-run` 通过
- sdk-ios：`xcrun swift test` 通过
- sdk-android：`./gradlew test` 通过

## 第十三轮并行（进行中）
- AT: neptune-desktop-macos（GitHub Actions CI）
- AU: neptune-sdk-harmony（GitHub Actions CI + 手动 Harmony build 开关）
- AV: neptune-contracts（OpenAPI/fixtures 契约 CI）
- AW: 父仓（集成 CI 工作流，调用 run-all-checks）

## 第十三轮结果
- AT: done (`neptune-desktop-macos@bd87606`)
- AU: done (`neptune-sdk-harmony@06faaf1`)
- AV: done (`neptune-contracts@b63df3b`)
- AW: done（父仓 `.github/workflows/integration.yml`，commit: `4ee0c63`）

## 第十三轮验证
- desktop：`swift build`、`swift test` 通过
- harmony：默认 CI 校验脚本通过；手动开关可跑 `ohpm install --all` + `assembleHar`
- contracts：OpenAPI YAML + fixtures JSON/NDJSON 语法校验通过
- 父仓：workflow YAML 可解析，`run-all-checks.sh` 语法通过

## 第十四轮并行（进行中）
- AX: neptune-desktop-macos（desktop packaging）
- AY: neptune-gateway-swift（gateway cli release）
- AZ: neptune-inspector-h5（inspector asset pipeline）

## 第十四轮结果
- AX: done (`neptune-desktop-macos@4424598`)
- AZ: done (`neptune-inspector-h5@1ae2c66`)
- AY: done (`neptune-gateway-swift@e00f74e`)

## 第十四轮备注
- 三条并行线均已完成并推送；父仓已完成 submodule bump 与总门禁回归

## 第十五轮并行（进行中）
- BA: neptune-gateway-swift（CLI release workflow）
- BB: neptune-desktop-macos（desktop package workflow）

## 第十五轮结果
- BA: done (`neptune-gateway-swift@ae60d3b`)
- BB: done (`neptune-desktop-macos@1c4536d`)

## 第十五轮验证
- gateway：`release-cli.yml` YAML 可解析；`build-cli-release.sh` 语法校验通过
- desktop：`package-desktop.yml` YAML 可解析；`package-macos-app.sh --dry-run` 可执行

## 第十六轮并行（占位）
- BC: neptune-gateway-swift（gateway tag release）
- BD: neptune-desktop-macos（desktop zip+release）

## 第十七轮并行（占位）
- BE: 父仓（统一发布编排入口）
  - 目标：新增 `workflow_dispatch` 编排入口，透传 `gateway_tag` / `desktop_tag`，按需触发 `neptune-gateway-swift` 与 `neptune-desktop-macos` 的 release workflow，只做调度，不做构建
  - 验证目标：父仓 workflow YAML 可解析，`run-all-checks.sh` 纳入新 workflow 的语法校验

## 第十八轮并行（进行中）
- BF: 父仓（发布前 preflight 集成门禁固化）
  - 目标：`release-orchestrator` 在分发 release 前默认执行 `run-all-checks.sh`，并默认开启 Harmony build gate
  - 验证目标：`release-orchestrator.yml` 与 `run-all-checks.sh` 语法通过，且新增 release workflows 纳入 YAML 校验清单

## 第十九轮并行（进行中）
- BG: demo 工程（Web SDK 最小 demo 集成 + 冒烟脚本）
  - 目标：落地 `Web SDK -> Gateway -> logs/sources/metrics` 端到端冒烟链路，并提供父仓一键执行脚本
  - 验证目标：`docs-linhay/scripts/smoke-demo-web.sh` 可拉起 gateway 并跑通 `neptune-sdk-web/examples/smoke-demo/run.cjs`

## 第十九轮结果
- BG: done (`neptune-sdk-web@6d0fb4a` + 父仓 `smoke-demo-web.sh`)

## 第十九轮验证
- `bash -n docs-linhay/scripts/smoke-demo-web.sh` 通过
- `bash docs-linhay/scripts/smoke-demo-web.sh` 通过（`queried_records=3`，`source_count=1`）

## 第二十轮并行（进行中）
- BH: neptune-sdk-ios（iOS demo 冒烟链路）
- BI: neptune-sdk-android（Android demo 冒烟链路）
- BJ: neptune-sdk-harmony（Harmony demo 冒烟链路）
- BK: 父仓（多端 demo 一键编排）
  - 目标：提供 `iOS + Android + Harmony` 一键 smoke 脚本，并将子仓 demo 结果固定到父仓文档/记忆

## 第二十轮结果
- BH: done (`neptune-sdk-ios@a13249b`)
- BI: done (`neptune-sdk-android@7d8875e`)
- BJ: done (`neptune-sdk-harmony@cfd1da5`)
- BK: done（新增 `docs-linhay/scripts/smoke-demo-native.sh`）

## 第二十轮验证
- iOS：`cd neptune-sdk-ios && ./scripts/smoke-demo.sh` 通过（`SMOKE_RESULT ok=true`）
- Android：`cd neptune-sdk-android && ./gradlew smokeDemo` 通过
- Harmony：`cd neptune-sdk-harmony && node ./scripts/demo-smoke.mjs` 通过（`demo-smoke: ok`）
- 父仓：`bash docs-linhay/scripts/smoke-demo-native.sh` 通过（`all native smoke demos passed`）

## 第二十一轮并行（进行中）
- BL: neptune-sdk-ios（CI 纳入 smoke-demo）
- BM: neptune-sdk-android（Kotlin 插件告警清零 + CI 纳入 smokeDemo）
- BN: neptune-sdk-harmony（CI 默认纳入 demo-smoke）
- BO: 父仓（run-all-checks 增加 native/web smoke 可开关门禁）

## 第二十一轮结果
- BL: done (`neptune-sdk-ios@1bd1053`)
- BM: done (`neptune-sdk-android@ddfbf59`)
- BN: done (`neptune-sdk-harmony@cfd1da5`)
- BO: done（父仓 `run-all-checks.sh` / `integration.yml` / `scripts/README.md` 已同步）

## 第二十一轮验证
- Android：`./gradlew test --warning-mode all`、`./gradlew smokeDemo --warning-mode all` 通过，Kotlin 插件多重加载 warning 消失
- iOS：`xcrun swift test`、`./scripts/smoke-demo.sh` 通过；`ci.yml` 已新增独立 Smoke Demo job
- Harmony：`node scripts/demo-smoke.mjs` 与现有 verify 链路通过；`ci.yml` 默认执行 demo smoke
- 父仓：`NEPTUNE_CHECK_NATIVE_SMOKE=1 NEPTUNE_CHECK_WEB_SMOKE=1 bash docs-linhay/scripts/run-all-checks.sh` 全量通过

## 第二十二轮并行（进行中）
- BP: neptune-sdk-ios（真实 simulator demo app 启动验证）
- BQ: neptune-sdk-android（本机 Android SDK + AVD 环境安装与 demo app 真机模拟器验证）
- BR: neptune-sdk-harmony（entry demo 应用安装与启动验证）

## 第二十二轮结果
- BP: 部分完成（`neptune-sdk-ios@7c1df8d` 已有真实 demo app；本机 simulator runtime 当前缺失）
- BQ: done（`neptune-sdk-android@860b945` + 本机 AVD `Neptune_API_34` 创建并跑通）
- BR: 部分完成（`neptune-sdk-harmony@cae2760` + 目标 `127.0.0.1:5555` 已安装 HAP，但启动受锁屏策略阻塞）

## 第二十二轮验证
- Android 环境：
  - `brew install --cask android-commandlinetools android-platform-tools` 成功
  - `sdkmanager ... system-images;android-34;google_apis;arm64-v8a` 成功
  - `avdmanager create avd -n Neptune_API_34 ...` 成功
- Android demo：
  - `./gradlew :app:installDebug` 成功安装到 emulator
  - `adb shell am start -n com.neptunekit.sdk.android.examples.simulator/.MainActivity` 成功拉起
  - `adb logcat` 捕获 `NeptuneSimulatorDemo` 业务日志（clickCount/queuedRecords）
- Harmony demo：
  - `node scripts/verify-demo-entry.mjs`、`./scripts/build-demo-entry.sh` 通过
  - `hdc install -r entry-default-unsigned.hap` 成功
  - `aa start -b io.github.neptune.sdk.harmony -m entry -a EntryAbility` 被设备锁屏策略拦截（`10106102`）

## 第二十二轮并行（进行中）
- BP: neptune-sdk-ios（真实 iOS Simulator Demo App）
- BQ: neptune-sdk-android（真实 Android Simulator Demo App）
- BR: neptune-sdk-harmony（真实 Harmony entry Demo App）

## 第二十二轮结果
- BP: done (`neptune-sdk-ios@7c1df8d`)
- BQ: done (`neptune-sdk-android@860b945`)
- BR: done (`neptune-sdk-harmony@cae2760`)

## 第二十二轮验证
- iOS：`bash scripts/simulator-demo.sh` 通过（`BUILD SUCCEEDED` + `simctl launch` 成功）
- Android：Demo 工程 `examples/simulator-app` 已落地并可独立解析 Gradle 任务；主仓 `./gradlew test`、`./gradlew smokeDemo` 不受影响
- Harmony：`entry` 模块可构建，`./hvigorw --mode module -p module=entry assembleHap --no-daemon` 通过
- 环境阻塞记录：当前机器缺 Android 标准 SDK/adb/emulator，且 `hdc list targets` 为空，故 Android/Harmony 未完成“启动模拟器并安装运行”实机步骤

## 第二十三轮并行（进行中）
- BS: neptune-sdk-harmony（模拟器启动阻塞清零）
- BT: neptune-sdk-ios（runtime 恢复与 simulator 冒烟）
- BU: 父仓（实机证据与子模块指针收口）

## 第二十三轮结果
- BS: done（`neptune-sdk-harmony@f7a1679`，`EntryAbility` 增加 `exported=true`，`aa start` 已成功）
- BT: 进行中（当前 `simctl list runtimes` 为空，待 runtime 下载恢复）
- BU: 进行中（Harmony v02/v03 截图与 layout 证据待入库，父仓待 bump harmony 子模块）

## 第二十三轮验证
- Harmony：
  - `./scripts/build-demo-entry.sh` 通过
  - `hdc install -r entry-default-unsigned.hap` 成功
  - `hdc shell aa start -b io.github.neptune.sdk.harmony -m entry -a EntryAbility` 返回 `start ability successfully`
  - `uitest dumpLayout` 可见 Demo 页面关键文案（`Neptune SDK Harmony Demo`、`写入 Demo 日志批次`）
- iOS：
  - `xcrun simctl list runtimes` 当前输出为空（环境阻塞仍在）

## 第二十四轮并行（进行中）
- BV: 父仓（Android + Harmony 二端独立 smoke 编排）

## 第二十四轮结果
- BV: done（新增 `docs-linhay/scripts/smoke-demo-android-harmony.sh`，默认仅跑 Android/Harmony 协议 smoke，可选开启双端模拟器校验）

## 第二十四轮验证
- `bash docs-linhay/scripts/smoke-demo-android-harmony.sh` 通过
- `NEPTUNE_CHECK_HARMONY_SIM=1 bash docs-linhay/scripts/smoke-demo-android-harmony.sh` 通过（`aa start ...` 成功）
- 新增 Harmony 模拟器证据：
  - `docs-linhay/screenshots/20260324/harmony/20260324-harmony-simulator-demo-after-v06.jpeg`
  - `docs-linhay/screenshots/20260324/harmony/20260324-harmony-entry-layout-after-v06.json`
- Android 模拟器现状：
  - 协议 smoke（`./gradlew smokeDemo`）稳定通过
  - 实机安装链路受本机 adb/emulator 在线状态抖动影响，已下沉为可选校验项（`NEPTUNE_CHECK_ANDROID_SIM=1`）

## 第二十五轮并行（进行中）
- BW: 父仓（日志契约同步与日志专用门禁）

## 第二十五轮结果
- BW: done
  - `docs-linhay/api/openapi.yaml` 已与 `neptune-contracts/openapi/openapi.yaml` 完整同步
  - 新增 `docs-linhay/scripts/check-log-contract-parity.sh`（校验日志路径集合 + 禁用 `/v2/ws` + 文件一致性）
  - 新增 `docs-linhay/scripts/run-log-checks.sh`（日志批次专用门禁）
  - `docs-linhay/scripts/run-all-checks.sh` 默认接入契约一致性校验

## 第二十五轮验证
- `bash docs-linhay/scripts/check-log-contract-parity.sh` 通过
- `bash docs-linhay/scripts/run-log-checks.sh` 全量通过：
  - gateway: `swift test`（23 passed, 1 skipped）
  - sdk-ios: `xcrun swift test`（9 passed）
  - sdk-android: `./gradlew test && ./gradlew smokeDemo` 通过
  - sdk-harmony: 过滤/持久化/demo-smoke 脚本通过
  - sdk-web: `npm test && npm run build` 通过
  - inspector-h5: `npm test && npm run build` 通过

## 第二十六轮并行（进行中）
- BX: neptune-inspector-h5（desktop 空白页修复）
- BY: neptune-sdk-ios（runtime 恢复后 simulator 实机冒烟）

## 第二十六轮结果
- BX: done（`neptune-inspector-h5@6dfdb18`，desktop 构建改为 `vite build --base ./`，修复 `file://` 资源绝对路径导致的空白）
- BY: done（iOS simulator demo 成功）

## 第二十六轮验证
- inspector:
  - `neptune-inspector-h5/dist/index.html` 资源路径由 `/assets/...` 变为 `./assets/...`
  - desktop app 重打包后 smoke 通过（`.app` 结构、inspector 资源存在）
- iOS:
  - runtime：`iOS 26.3 (26.3.1 - 23D8133)` 可用
  - 执行：`NEPTUNE_DEMO_SIMULATOR_ID=1126FA83-5C54-4803-ABC4-FBBE05A9FCDD bash scripts/simulator-demo.sh`
  - 关键结果：`** BUILD SUCCEEDED **`、`simctl launch` 成功（`com.neptunekit.demo.ios: 19782`）

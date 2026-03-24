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

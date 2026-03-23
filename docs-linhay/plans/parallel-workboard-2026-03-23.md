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

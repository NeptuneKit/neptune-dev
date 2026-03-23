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

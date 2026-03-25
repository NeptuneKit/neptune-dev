# 三端模拟器 Discovery 冒烟（2026-03-24）

## 目标
- 在 iOS / Android / Harmony 模拟器内触发 SDK 网关发现。
- 发现策略统一：mDNS 优先，手动 DSN 回退。
- 确认结果可见：UI 或日志中能看到 `source/host/port/version`。

## 职责顺序（冻结）
1. `CLI` 提供发现服务（mDNS 可选 + `/v2/gateway/discovery` 必须）。
2. `App SDK` 发现 `CLI`（不是 App 注册发现服务）。
3. `App SDK` 上报日志到 `CLI`。
4. `H5 Inspector` 仅连接 `CLI` 展示聚合数据。

## 前置
1. 启动本地 gateway（neptune-gateway-swift），确保 `GET /v2/gateway/discovery` 可用。
2. 本机检查：
   - `curl -fsS http://127.0.0.1:18765/v2/health`
   - `curl -fsS http://127.0.0.1:18765/v2/gateway/discovery`

## iOS 模拟器
1. 运行 `neptune-sdk-ios` simulator app。
2. 点击 `Discover Gateway`。
3. 预期：页面日志出现 discovery 成功行，包含：`source`、`host`、`port`、`version`。

## Android 模拟器
1. 运行 `neptune-sdk-android/examples/simulator-app`。
2. 点击 `Discover Gateway`。
3. 预期：UI 状态区和 `adb logcat` 出现 discovery 结果或失败原因。
4. Android Emulator 的默认手动 DSN 使用 `10.0.2.2:18765`（访问宿主机 loopback）。

## Harmony 模拟器
1. 运行 `neptune-sdk-harmony/entry` demo。
2. 点击 `发现网关` 按钮。
3. 预期：页面显示 discovery 状态，成功时包含 `source/host/port/version`。

## 回归命令
- `./docs-linhay/scripts/run-discovery-checks.sh`
- `./docs-linhay/scripts/smoke-demo-native.sh`
- `./docs-linhay/scripts/smoke-parallel-clients-desktop.sh`

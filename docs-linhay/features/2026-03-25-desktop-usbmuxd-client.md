# Neptune Desktop usbmuxd 客户端（2026-03-25）

## 背景
- 需要在 macOS 侧通过 `usbmuxd` 与 iOS 真机建立端口转发连接，作为 Inspector/调试链路的基础传输能力。
- 当前仓库缺少可复用的 `usbmuxd` 协议实现，导致只能依赖模拟器或外部实现。

## 范围
- 在 `neptune-desktop-macos` 增加最小 `usbmuxd` 客户端能力：
- 支持连接 `/var/run/usbmuxd`（或测试注入连接器）。
- 支持发送 `Connect` plist 请求（`DeviceID` + `PortNumber`）。
- 支持解析 `Result` 响应并校验 `Number == 0`。
- 成功后返回可复用的已连接文件描述符（后续可用于自定义协议读写）。

## 非目标
- 本次不实现完整设备发现 UI。
- 本次不实现 Peertalk 全量协议迁移。
- 本次不把该能力直接接入现有桌面窗口流程。

## BDD 验收场景

### 场景 1：Connect 请求端口字节序正确
- Given 请求连接 `deviceID=123`、`port=8100`
- When 构建发往 `usbmuxd` 的 `Connect` plist
- Then `PortNumber` 字段应使用网络字节序表达（与 Peertalk 行为一致）

### 场景 2：握手成功返回可用连接
- Given `usbmuxd` 返回 `Result` 且 `Number=0`
- When 客户端执行 connect 握手
- Then 返回的连接对象包含有效文件描述符，且未被关闭

### 场景 3：握手失败抛出明确错误
- Given `usbmuxd` 返回 `Result` 且 `Number!=0`
- When 客户端执行 connect 握手
- Then 抛出 `usbmuxd` 业务错误，包含响应码信息

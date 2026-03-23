# 鸿蒙开发参考（NeptuneKit）

## 1. 第三方库候选：`@cxy/webserver`

- 包名：`@cxy/webserver`
- 最新版本：`2.0.2`（核对日期：2026-03-23）
- 许可证：`Apache-2.0`
- 官方仓库：<https://github.com/iHongRen/WebServer>
- OHPM 页面：<https://ohpm.openharmony.cn/#/cn/detail/@cxy%2Fwebserver>
- Registry 元数据：<https://ohpm.openharmony.cn/ohpm/@cxy/webserver>

## 2. 能力摘要

该库提供类 Express 的本地 HTTP 服务能力，支持：

- 路由与中间件
- 静态文件服务
- 文件上传
- HTTP/HTTPS（含 `TLSServer`）
- CORS 与日志中间件

## 3. 在 NeptuneKit 的适用性判断

### 3.1 适用场景

当 `neptune-sdk-harmony` 需要在设备本地启动服务时可用，例如：

- 本地调试面板（H5 Inspector）
- 设备内离线静态资源服务
- 本地桥接接口（仅开发/调试用途）

### 3.2 不适用场景

以下场景不建议引入：

- 仅需调用远端网关 API 的普通 SDK 能力
- 对三方依赖敏感、追求最小依赖面的核心链路

## 4. 风险与注意事项

- 生态成熟度仍偏早期（社区规模较小，需预留替换方案）。
- 已有上传相关性能反馈 issue，接入前必须做大文件上传压测。
- 包 metadata 标注 `compatibleSdkVersion: 12 (beta1)`，接入时需与目标 API 版本做兼容验证。

## 5. 采纳结论（当前）

结论：**暂不作为默认依赖引入**，仅在 Harmony 端明确存在“本地 HTTP 服务”需求时，以 POC 方式受控引入。

## 6. POC 验收（BDD）

### 场景 A：本地服务可用
- Given 在 Harmony 设备启动 `HttpServer`
- When 访问 `GET /health`
- Then 返回 `200` 且耗时稳定

### 场景 B：端口回收正确
- Given 服务在 `8080` 启动
- When 调用 `stopServer()` 后再次启动同端口
- Then 不出现端口占用错误

### 场景 C：上传性能可接受
- Given 开启 `multipart` 上传接口
- When 上传 10MB/50MB 文件
- Then 平均耗时与失败率满足 SDK 基线要求

## 7. 最小接入示例

```bash
ohpm install @cxy/webserver
```

```ts
import { HttpServer } from '@cxy/webserver';

const server = new HttpServer();
server.get('/health', async (_req, res) => {
  await res.status(200).json({ ok: true });
});
await server.startServer(8080);
```

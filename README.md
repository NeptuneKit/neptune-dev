# neptune-dev

父仓（orchestrator）用于管理 NeptuneKit v2 多仓协作。

## 目录结构

```text
.
├── AGENTS.md
├── MEMORY.md
├── README.md
├── docs-linhay/
│   └── plans/
├── docs-dev/
│   ├── api/
│   ├── dev/
│   ├── features/
│   └── ops/
├── memory/
├── references/
├── screenshots/
├── neptune-contracts/       # git submodule
├── neptune-gateway-swift/   # git submodule
├── neptune-inspector-h5/    # git submodule
├── neptune-desktop-macos/   # git submodule
├── neptune-sdk-ios/         # git submodule
├── neptune-sdk-android/     # git submodule
├── neptune-sdk-harmony/     # git submodule
└── neptune-sdk-web/         # git submodule (待定)
```

## 子仓职责

- `neptune-contracts`: OpenAPI/Schema/Fixture/兼容矩阵
- `neptune-gateway-swift`: CLI 网关与聚合服务
- `neptune-inspector-h5`: Inspector 前端
- `neptune-desktop-macos`: macOS 壳应用（CLI + Inspector）
- `neptune-sdk-ios`: iOS SDK（SPM）
- `neptune-sdk-android`: Android SDK（AAR）
- `neptune-sdk-harmony`: Harmony SDK（ohpm）
- `neptune-sdk-web`: Web SDK（npm，待定）

## 约束

- 父仓只做编排与文档，不直接承载子仓实现代码。
- 子仓升级通过 submodule commit bump PR。

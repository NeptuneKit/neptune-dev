# neptune-dev 目录结构（当前）

## 父仓
- 文档：`docs-dev/`
- 记忆：`memory/`, `MEMORY.md`
- 归档：`references/`
- 截图：`screenshots/`

## 子仓（git submodule）
- `neptune-contracts`
- `neptune-gateway-swift`
- `neptune-inspector-h5`
- `neptune-desktop-macos`
- `neptune-sdk-ios`
- `neptune-sdk-android`
- `neptune-sdk-harmony`
- `neptune-sdk-web`

## 约定
- 父仓不直接实现业务代码，仅做编排、文档和版本钉住。
- 子仓发布各自 SDK 产物。

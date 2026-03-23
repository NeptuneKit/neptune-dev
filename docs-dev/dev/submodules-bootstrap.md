# Submodule 结构与接入清单

## 目标
在父仓 `neptune-dev` 下维护子仓，并采用 commit pin 管理。

## 仓库命名
- `neptune-contracts`
- `neptune-gateway-swift`
- `neptune-inspector-h5`
- `neptune-desktop-macos`
- `neptune-sdk-ios`
- `neptune-sdk-android`
- `neptune-sdk-harmony`
- `neptune-sdk-web`

## 首次接入命令（新环境）
```bash
git clone https://github.com/NeptuneKit/neptune-dev.git
cd neptune-dev
git submodule update --init --recursive
```

## 新增子仓命令（扩仓时）
```bash
git submodule add git@github.com:NeptuneKit/neptune-contracts.git neptune-contracts
git submodule add git@github.com:NeptuneKit/neptune-gateway-swift.git neptune-gateway-swift
git submodule add git@github.com:NeptuneKit/neptune-inspector-h5.git neptune-inspector-h5
git submodule add git@github.com:NeptuneKit/neptune-desktop-macos.git neptune-desktop-macos
git submodule add git@github.com:NeptuneKit/neptune-sdk-ios.git neptune-sdk-ios
git submodule add git@github.com:NeptuneKit/neptune-sdk-android.git neptune-sdk-android
git submodule add git@github.com:NeptuneKit/neptune-sdk-harmony.git neptune-sdk-harmony
git submodule add git@github.com:NeptuneKit/neptune-sdk-web.git neptune-sdk-web
```

## 更新策略
- 父仓仅通过 submodule commit bump PR 更新。
- 禁止在父仓直接改子仓代码。

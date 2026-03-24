# 脚本目录

- `run-all-checks.sh`：父仓一键触发各子仓核心测试门禁。
  - 当前覆盖：gateway / ios / android / inspector / web / harmony（含持久化验证）/ desktop
  - 可选：`NEPTUNE_CHECK_HARMONY_BUILD=1` 时追加 `ohpm install --all` 与 `hvigorw assembleHar` 构建校验

说明：脚本只做编排，不承载子仓实现逻辑。

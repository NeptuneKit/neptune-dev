# AGENTS 执行规范（neptune-dev）

## 路径规范
.
├── MEMORY.md
├── AGENTS.md
├── docs-linhay/
│   └── plans/
├── references/
├── screenshots/
├── docs-dev/
│   ├── api/
│   ├── dev/
│   ├── features/
│   └── ops/
└── memory/

## 工作约束
1. 全程中文沟通。
2. 采用 BDD + TDD：先场景与验收，再测试，再实现。
3. 文档先行：需求变更先更新 `docs-dev/features/`。
4. 接口变更同步更新 `docs-dev/api/openapi.yaml`。
5. 关键决策同步写入 `memory/YYYY-MM-DD.md`。

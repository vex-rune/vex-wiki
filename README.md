# Luke''s Wiki

> 个人知识库，基于 MkDocs + Material 主题构建的现代化静态文档网站。

[![GitHub Stars](https://img.shields.io/github/stars/vex-rune/vex-wiki.svg?style=flat-square)](https://github.com/vex-rune/vex-wiki)
[![GitHub Issues](https://img.shields.io/github/issues/vex-rune/vex-wiki.svg?style=flat-square)](https://github.com/vex-rune/vex-wiki/issues)
[![GitHub License](https://img.shields.io/github/license/vex-rune/vex-wiki.svg?style=flat-square)](https://github.com/vex-rune/vex-wiki/blob/main/LICENSE)
[![Deploy Status](https://img.shields.io/github/actions/workflow/status/vex-rune/vex-wiki/deploy-aliyun-oss.yml?style=flat-square)](https://github.com/vex-rune/vex-wiki/actions)

**主理人**：雷鸣（Luke） · **品牌**：VEX · **站点**：[vexrune.top](https://vexrune.top/) · **Wiki**：[wiki.vexrune.top](https://wiki.vexrune.top/)

---

## 🌟 功能特性

| 功能 | 说明 |
|------|------|
| ✅ **Material 主题** | Material for MkDocs：即时加载、深色 / 浅色切换、Mermaid、KaTeX、社交卡片 |
| ✅ **中文搜索** | 内置 lunr-languages 中文分词，全文检索 |
| ✅ **响应式设计** | 移动端友好，桌面 / 平板 / 手机自适应 |
| ✅ **CI/CD 部署** | GitHub Actions 自动部署到阿里云 OSS |
| ✅ **社交链接** | GitHub / Gitee / B站 / 抖音 集中展示 |

---

## 🛠️ 技术栈

| 分类 | 组件 | 版本 |
|------|------|------|
| **文档框架** | MkDocs | 1.6+ |
| **主题** | Material for MkDocs | 9.5+ |
| **导航权重** | mkdocs-nav-weight | 0.3+ |
| **Markdown** | PyMdown Extensions | 10.7+ |
| **部署** | 阿里云 OSS | - |
| **CI/CD** | GitHub Actions | - |

---

## 📁 项目结构

```
vex-wiki/                            # 项目根目录
├── .github/                         # GitHub 配置
│   └── workflows/                   # GitHub Actions 工作流
│       ├── deploy-aliyun-oss.yml    # 阿里云 OSS 部署
│       └── deploy-ecs.yml           # ECS 部署
├── .obsidian/                       # Obsidian 编辑器配置
├── docs/                            # 文档源文件 (Markdown)
│   ├── 博客与阅读/                  # Blog + 读书笔记
│   ├── 工程技术/                    # 软件 / 数据库 / 运维 / 嵌入式 / AI
│   ├── 创意设计/                    # Blender / Ae / 3D 建模
│   ├── 内容创作/                    # 小说创作体系 + 原创作品
│   ├── 学习与职业/                  # 产品经理 / 项目管理 / 提示词工程
│   ├── assets/                      # 站点图标、Logo
│   ├── stylesheets/                 # 自定义 CSS
│   └── index.md                     # 首页
├── overrides/                       # Material 主题模板覆盖
│   └── main.html                    # 自定义 footer（社交链接）
├── site/                            # 构建产物（gitignore）
├── mkdocs.yml                       # MkDocs 主配置
├── requirements.txt                 # Python 依赖
└── README.md
```

---

## 🚀 快速开始

### 前置条件

- Python 3.11+
- Git

### 安装与启动

```bash
# 1. 克隆仓库
git clone https://github.com/vex-rune/vex-wiki.git
cd vex-wiki

# 2. 创建并激活虚拟环境
python -m venv .venv
source .venv/bin/activate        # Linux / macOS
# .venv\Scripts\Activate.ps1    # Windows PowerShell

# 3. 安装依赖
pip install -r requirements.txt

# 4. 启动本地开发服务器（默认 http://localhost:8000）
mkdocs serve

# 5. 构建静态站点（输出到 site/ 目录）
mkdocs build
```

---

## 🎨 主题与扩展

本站启用 Material 主题的完整特性集，包括：

- **导航**：tabs / sections / top / indexes / instant / instant.progress / tracking / footer / prune
- **搜索**：suggest / highlight / share（中日韩分词）
- **内容**：code.copy / code.annotate / tabs.link / action.edit / action.view / tooltips / icons / links
- **配色**：浅色（`default`）+ 深色（`slate`）双方案，一键切换
- **Markdown**：PyMdown 全家桶（highlight / superfences / tabbed / tasklist / emoji / snippets / keys 等）

---

## 📚 内容分类

| 分类 | 说明 |
|------|------|
| [博客与阅读](docs/博客与阅读/) | Blog、读书笔记与个人思考 |
| [学习与职业](docs/学习与职业/) | 产品经理、项目管理与提示词工程 |
| [工程技术](docs/工程技术/) | 软件、数据库、运维、嵌入式与 AI |
| [创意设计](docs/创意设计/) | Blender、Ae 与 3D 打印 |
| [内容创作](docs/内容创作/) | 小说创作体系与个人作品 |

---

## 📊 站点规模

| 指标 | 数值 |
|------|------|
| 文档目录 | 158 |
| Markdown 文件 | 728 |

---

## 🔗 参考链接

| 资源 | 链接 |
|------|------|
| Material for MkDocs | https://squidfunk.github.io/mkdocs-material/ |
| MkDocs 官网 | https://www.mkdocs.org/ |
| PyMdown Extensions | https://facelessuser.github.io/pymdown-extensions/ |
| mkdocs-nav-weight | https://github.com/shu307/mkdocs-nav-weight |
| 阿里云 OSS | https://www.aliyun.com/product/oss |

---

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

---

*Built with ❤️ using MkDocs & Material for MkDocs*
# Markdown 转换专家 Pro

一款专业的 Markdown 转换工具，支持实时预览、导出 PDF/Docx/长图，完美适配移动端。

## ✨ 功能特性

### 📝 实时预览
- 左右分栏布局，编辑与预览同步滚动
- 支持 GitHub 风格 Markdown 语法
- 代码高亮显示

### 📤 多格式导出
| 格式 | 说明 |
|------|------|
| **PDF/打印** | 直接弹出打印对话框，无需打开新标签页 |
| **Docx** | 导出为 Word 文档格式 |
| **长图** | 生成完整内容的 PNG 长图 |

### 💧 水印功能
- 自定义水印文字内容
- 可调节倾斜角度（0°-90°）
- 可调节透明度（10%-100%）
- 可调节字体大小（12px-36px）
- 自定义水印颜色
- 支持预览水印效果

### 🔢 数学公式支持
基于 KaTeX 引擎，支持 LaTeX 数学公式渲染：

```
$$ f(x | \mu, \sigma^2) = \frac{1}{\sqrt{2\pi\sigma^2}} e^{-\frac{(x-\mu)^2}{2\sigma^2}} $$
```

### 📱 移动端适配
- 响应式布局，自动切换上下堆叠模式
- 优化触控操作体验
- 表格支持横向滑动

### 🛠 调试功能
- 右键菜单支持调试选中内容
- 查看 Markdown 原文与解析后的 HTML

## 🚀 快速开始

### 在线使用
直接打开 `index.html` 文件即可使用。

### 本地运行

```bash
# 方式一：Python 简易服务器
python3 -m http.server 8080

# 方式二：Node.js 服务器
npx serve .
```

然后访问 http://localhost:8080

## 📦 技术栈

| 库 | 用途 |
|---|------|
| [Tailwind CSS](https://tailwindcss.com/) | 样式框架 |
| [Marked.js](https://marked.js.org/) | Markdown 解析 |
| [KaTeX](https://katex.org/) | 数学公式渲染 |
| [html2canvas](https://html2canvas.hertzen.com/) | 生成长图 |
| [html-docx-js](https://github.com/evidenceprime/html-docx-js) | 导出 Docx |

## 📖 支持的 Markdown 语法

- 标题（H1-H6）
- 段落与换行
- **粗体**、*斜体*、~~删除线~~
- 有序列表、无序列表
- 任务列表
- 代码块与行内代码
- 引用块
- 表格
- 水平分割线
- 链接与图片
- 数学公式（LaTeX）

## 🎯 使用技巧

1. **智能文件命名**：导出时自动以首行非空内容作为文件名
2. **水印预览**：设置水印时可实时预览效果
3. **移动端操作**：长按可唤起调试菜单

## 📄 许可证

MIT License

---

Made with ❤️ by Markdown 转换专家团队

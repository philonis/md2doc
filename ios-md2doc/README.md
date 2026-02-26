# Md2Doc iOS App

基于 React Native (Expo) 的 iOS 应用，支持 iPhone 和 iPad。

## 功能特性

- Markdown 编辑器
- 支持导出 DOCX/PDF/图片格式
- 水印配置功能
- iPad 适配优化

## 安装

```bash
# 安装依赖
npm install

# 启动开发服务器
npm start

# 运行 iOS 应用
npm run ios
```

## iPad 适配

应用已针对 iPad 进行优化：
- 响应式布局适配不同屏幕尺寸
- iPad 上更大的字体和间距
- 支持横屏和竖屏模式
- 优化的内容宽度

## 所需资源文件

在运行前，请确保 `assets` 目录下有以下文件：
- `icon.png` - 应用图标 (1024x1024)
- `splash-icon.png` - 启动画面图标
- `adaptive-icon.png` - Android 自适应图标
- `favicon.png` - Web 图标

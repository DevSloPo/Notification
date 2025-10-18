# XK Hub - Roblox 通知系统

一个简洁美观的 Roblox 通知系统模块，支持堆叠动画和自定义样式。

## 功能特点

- 🎨 美观的紫色主题 UI
- 📱 响应式通知堆叠
- ⚡ 平滑的动画效果
- 🔊 内置音效反馈
- 🎮 自动处理玩家死亡事件
- 🔧 简单易用的 API

## 安装

1. 将 `XKHub.lua` 放入 `ReplicatedStorage`
2. 在本地脚本中引入：

```lua
local XKHub = require(game.ReplicatedStorage.XKHub)

-- 基本用法
XKHub:Notification("标题", "内容", 持续时间)

-- 示例
XKHub:Notification("欢迎使用", "XK Hub 已加载", 3)
XKHub:Notification("系统提示", "功能正常运行", 2)
XKHub:Notification("警告", "请勿滥用功能", 4)
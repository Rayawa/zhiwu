# zhiwu

[English](README.md) | 简体中文

支持购入成本记录与分类统计的 HarmonyOS 物品管理应用。

归档项目，保留用于参考。

## 项目概述

应用支持新增、编辑及查看物品，记录价格、购入日期、图片与分类；物品模型包含日均成本，并提供列表及统计页面。

## 技术栈与依赖

ArkTS、ArkUI、HarmonyOS 6.0.0（API 20）、OHPM、Hvigor。entry 未声明第三方运行时依赖；测试使用 Hypium 1.0.24 和 Hamock 1.0.0。

## 文件结构

- `entry/src/main/ets/` — ArkTS 应用代码
- `entry/src/main/resources/` — 模块资源与路由
- `AppScope/` — 应用配置与资源
- `build-profile.example.json5` — 可移植构建配置模板
- `oh-package.json5` — 包与测试依赖
- `hvigor/` — 构建配置
- `entry/src/main/ets/model/` — 物品数据模型
- `entry/src/main/ets/view/` — 编辑、详情与统计页面
- `entry/src/main/ets/viewmodel/` — 物品状态与持久化协调

## 快速上手

1. 安装 DevEco Studio 及与 `build-profile.example.json5` 匹配的 HarmonyOS SDK。
2. 将 `build-profile.example.json5` 复制为 `build-profile.json5`，在 IDE 中配置本地 SDK 与签名。
3. 打开仓库根目录，通过 IDE 的 OHPM 恢复依赖并选择 `entry` 模块。
4. 选择兼容设备或模拟器后运行；签名材料与机器路径仅在本地配置。

新增物品，填写分类与购入日期，再查看详情和统计页面。

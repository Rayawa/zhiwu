# zhiwu

English | [简体中文](README_zh.md)

A HarmonyOS item-management application with purchase-cost tracking and category statistics.

Archived project retained for reference.

## Overview

The application supports creating, editing and viewing items with prices, acquisition dates, images and categories. Item models include daily average cost, and separate views provide list and statistical presentations.

## Technology and Dependencies

ArkTS, ArkUI, HarmonyOS 6.0.0 (API 20), OHPM and Hvigor. The entry package declares no third-party runtime dependency. Tests use Hypium 1.0.24 and Hamock 1.0.0.

## Repository Structure

- `entry/src/main/ets/` — ArkTS application code
- `entry/src/main/resources/` — module resources and routes
- `AppScope/` — application metadata and resources
- `build-profile.example.json5` — portable build configuration template
- `oh-package.json5` — package and test dependencies
- `hvigor/` — build configuration
- `entry/src/main/ets/model/` — item data model
- `entry/src/main/ets/view/` — item editing, detail and statistics screens
- `entry/src/main/ets/viewmodel/` — item state and persistence coordination

## Quick Start

1. Install DevEco Studio and a HarmonyOS SDK compatible with `build-profile.example.json5`.
2. Copy `build-profile.example.json5` to `build-profile.json5` and configure the local SDK and signing in DevEco Studio.
3. Open the repository root, restore dependencies with OHPM through the IDE, and select the `entry` module.
4. Select a compatible device or emulator and run the application. Keep signing material and machine-specific paths local.

Add an item, choose its category and acquisition date, and inspect the detail and statistics views.

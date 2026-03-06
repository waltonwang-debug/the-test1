# Autonomic Coach iOS (MVP)

这是一个可落地的 iOS SwiftUI MVP 骨架，覆盖以下能力：

- Onboarding 流程内完成问卷评估与自主神经类型初始化
- 接入可穿戴健康数据（当前提供 `MockHealthDataService`，已预留 `HealthDataService` 协议）
- 每小时健康分评估（HRV 为核心）
- 输出可执行微任务
- 内置 AI 对话 + 连续低分时主动关怀
- 极简生活 Log 记录

## 目录

- `ios/AutonomicHealthApp.swift`：App 入口与容器
- `ios/Models`：领域模型
- `ios/Services`：问卷、评分、任务推荐、AI、日志与健康数据服务
- `ios/ViewModels`：Dashboard 状态管理
- `ios/Views`：主界面
- `preview.html`：可直接运行的高保真界面预览

## 小白也能跑通：一步步看预览（不是截图）

> 你只需要复制粘贴命令，不需要懂代码。

### 方案 A（macOS / Linux 终端）
1. 进入项目目录：
```bash
cd /workspace/the-test1
```
2. 启动预览服务：
```bash
./scripts/run_preview.sh
```
3. 浏览器打开：
```text
http://127.0.0.1:4173/preview.html
```

### 方案 B（Windows CMD）
1. 进入项目目录（示例路径请替换成你的本机路径）：
```cmd
cd /d D:\project\the-test1
```
2. 启动预览服务：
```cmd
scripts\run_preview.cmd
```
3. 浏览器打开：
```text
http://127.0.0.1:4173/preview.html
```

### 可选：自定义端口（避免端口冲突）
- macOS / Linux：
```bash
./scripts/run_preview.sh 5001
```
- Windows CMD：
```cmd
scripts\run_preview.cmd 5001
```
然后打开：
```text
http://127.0.0.1:5001/preview.html
```

### 页面里可以直接点击体验
- `生成类型`
- `立即刷新评估`
- `问 AI：我现在该做什么？`
- `记录：压力4/5 + 咖啡因`

---

## 如果你看到“拒绝访问”，按这个顺序排查

### A. 你是不是在**同一台机器**打开链接？
`127.0.0.1` 只代表“当前这台电脑自己”。
- 如果你在 A 机器启动服务，却在 B 机器打开 `127.0.0.1`，一定会失败。
- 正确做法：在启动服务的那台机器上打开浏览器。

### B. 端口可能被占用，换端口再试
- macOS / Linux：`./scripts/run_preview.sh 5001`
- Windows CMD：`scripts\run_preview.cmd 5001`

### C. 检查服务是否真的启动成功
- macOS / Linux：
```bash
curl -I http://127.0.0.1:4173/preview.html
```
- Windows CMD（PowerShell 也可）：
```cmd
curl -I http://127.0.0.1:4173/preview.html
```
如果返回 `HTTP/1.0 200 OK`，说明服务正常，重点检查地址输入是否有误。

### D. 常见输入错误
- 地址少写了 `/preview.html`
- 端口号写错（服务在 5001，却访问 4173）
- 把 `127.0.0.1` 输成了别的地址

---

## 方式 B：在 iOS 模拟器看 SwiftUI 真界面
当前仓库还没有 `.xcodeproj`，所以第一次需要你在 Xcode 里建一个空工程再把代码放进去（3-5 分钟）。

1. Xcode → `File` → `New` → `Project` → `iOS App`。
2. Product Name 建议填：`AutonomicCoach`，Interface 选 `SwiftUI`。
3. 删除 Xcode 自动生成的 `ContentView.swift`（可选）。
4. 把仓库里的以下文件夹拖入工程（勾选 `Copy items if needed`）：
   - `ios/AutonomicHealthApp.swift`
   - `ios/Models`
   - `ios/Services`
   - `ios/ViewModels`
   - `ios/Views`
5. 在 Target → `General` → `Frameworks, Libraries, and Embedded Content` 中确认无需额外三方库。
6. 选择 iPhone 模拟器（如 iPhone 15）并点击 Run (`⌘R`)。

运行后你会看到和预览页面同一套核心功能：问卷、每小时评分、任务建议、AI 消息、快速 Log。

## 下一步接入建议

1. 将 `MockHealthDataService` 替换为 `HealthKit` 实现，读取 HRV/RHR/睡眠。
2. 用后台任务（`BGTaskScheduler`）触发每小时计算。
3. 接入推送（APNs）用于 AI 主动关怀。
4. 把 AI 服务替换为后端 API，增加安全模板与风险升级策略。

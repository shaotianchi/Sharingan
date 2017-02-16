**Sharingan 是一个移动端的 UI 事件录制与播放的工具。由录制器 (Recorder) 和播放器 (Player) 组成。**目前尚处于开发阶段。
## 主要作用
1. 记录用户操作轨迹
2. 结合 BUG 收集自动重播 BUG 操作
3. 录制测试流程，自动进行 UI 测试  

## Recorder
Recorder 的任务是将记录应用内所有的 UI 事件。  
通过自定义 `UIApplication` 获取应用内的 `UIEvent` ，通过自定义的 `event` 和 `touch` 对象保存事件。

## Player
Player 通过 Recorder 保存的信息进行模拟操作来重新播放。

## 问题
* 目前的播放是基于前后两次事件的间隔时间的，但是考虑到不同的网络环境会造成 UI 内容的不同导致在播放时 UI 事件失效，进而导致后续一连串操作都会失效
* UI 内容的变化，例如 TableView 内容变化会导致播放时与录制时的操作不一致
* 由于只能接收到 `UIEvent` 导致手势无法识别
* 除 `UITouchEvents` 外的 `UIEvent` 处理
* force 处理

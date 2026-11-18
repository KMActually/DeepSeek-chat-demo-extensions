# chat-demo-extensions

给DeepSeek官方开源的DeepSeek本地前端 [chat-demo](https://github.com/deepseek-ai/chat-demo)（v0.1.1）用的一键扩展脚本。

运行前建议先备份

## 改动内容

1. 移除请求中的 `safety_check: high` 参数，不再主动要求额外，几乎解决前端输出一半就显示的”你好，这个问题我暂时无法回答，让我们换个话题再聊聊吧。“的问题
2. 服务端拒绝时保留已生成的思考和正文，不替换成拒绝回答
3. 设置新增“系统提示词”编辑框
4. 被拒绝的消息同样可以朗读和重新生成

## 使用方法

1. 下载官方 chat-demo v0.1.1 源码并解压，得到 `chat-demo` 文件夹。
2. 把本文件夹放到 `chat-demo` 同级目录或里面
3. 双击 `install-extensions.cmd`。
4. 进入 `chat-demo` 双击 `start.cmd`
5. 开始使用DeepSeek-chat-demo

注意，当chat-demo是git仓库时：
1. 不要把脚本文件夹放在 chat-demo 里面，请放在同级目录
2. 已经放进去不会影响安装和启动，但是git status会多一条未跟踪记录
3. 补救：把脚本文件夹移出来，或在chat-demo目录执行:Add-Content .git\info\exclude "chat-demo-extensions/"
4. 如果已经执行过 git add .，再执行：git rm -r --cached chat-demo-extensions
5. 第 3、4 条里的 chat-demo-extensions 换成您的实际的文件夹名

## 卸载

双击 `uninstall-extensions.cmd`，脚本会用官方源文件覆盖回，并删除安装时新增的 `start.cmd`

## 原理与边界

- 本工具只修改本机源码文件，不联网、不上传任何内容
- 审核本身在服务端，工具只是不再主动要求额外审核，敏感内容仍可能被服务端拒绝
- API Key 保存在浏览器本地存储中，不在本工具内
- 只支持官方v0.1.1，其他版本为防止改坏脚本会被拒绝修改，如果运行前修改了源码请先备份

## 许可证

- 本工具：MIT，Copyright (c) 2026 KMActually，见 [LICENSE](LICENSE)。
- `files/` 内包含基于 [deepseek-ai/chat-demo](https://github.com/deepseek-ai/chat-demo) 修改的源码，遵循其 MIT 许可证，Copyright (c) 2026 DeepSeek，见 [LICENSE-chat-demo.txt](LICENSE-chat-demo.txt)。

本项目与 DeepSeek 官方无关。使用时请遵守 DeepSeek 服务条款及当地法律法规。

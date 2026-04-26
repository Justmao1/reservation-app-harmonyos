# 健身场馆预约 App

基于 HarmonyOS ArkTS 开发的健身场馆预约应用，包含首页资讯、场馆动态、运动常识、场馆预约、用户登录注册、个人中心、资料修改等功能。项目使用 DevEco Studio 构建，用户相关数据通过 `http + json-server` 与本地服务交互。

## 技术栈

- HarmonyOS / ArkTS
- ArkUI 声明式 UI
- DevEco Studio / Hvigor
- `@ohos.net.http` 网络请求
- `json-server` 模拟后端服务
- 本地关系型数据库 `relationalStore`，用于当前预约记录存储

## 项目结构

```text
ReservationApp4
├── AppScope                         # 应用级配置
├── entry                            # HarmonyOS 主模块
│   └── src/main
│       ├── ets
│       │   ├── entity               # 实体类
│       │   ├── pages                # 页面组件
│       │   │   ├── home             # 首页
│       │   │   ├── know             # 运动常识
│       │   │   ├── message          # 场馆动态
│       │   │   ├── mine             # 我的、登录、注册、资料修改
│       │   │   ├── restime          # 场馆预约、报名、详情、预约列表
│       │   │   └── common           # 公共详情/列表页
│       │   └── utils                # HTTP、数据库工具类
│       └── resources                # 图片、页面配置、字符串资源
├── server                           # json-server 模拟服务
│   ├── db.json                      # 用户与快捷入口数据
│   └── public                       # 服务端静态图片资源
├── build-profile.json5              # 构建配置
└── oh-package.json5                 # OpenHarmony 包配置
```

## 主要功能

- 首页快捷入口：展示场馆动态、运动常识和各类场馆预约入口。
- 场馆动态：展示场馆开放、维护、预约提醒等图文动态。
- 运动常识：展示运动安全、训练技巧等内容。
- 场馆预约：支持选择预约日期、选择场馆类型、填写预约人资料并生成预约详情。
- 用户系统：支持注册、登录、退出登录、登录状态保持。
- 个人中心：展示用户头像、用户名、今日预约入口、所有预约、资料修改、关于我们等。
- 资料修改：支持修改用户名、手机号、头像，并通过 HTTP 更新到 json-server。

## 后端服务

项目使用 `server/db.json` 作为 json-server 数据源。当前主要接口包括：

```text
GET    /quicks          查询首页快捷入口
GET    /user            查询用户列表，登录时本地匹配用户名和密码
POST   /user            注册用户
PUT    /user/:id        修改用户资料
```

启动服务示例：

```bash
cd server
npx json-server --host 0.0.0.0 --port 3000 db.json
```

如果没有安装 `json-server`，可以先执行：

```bash
npm install -g json-server
```

## 运行项目

1. 使用 DevEco Studio 打开项目根目录 `ReservationApp4`。
2. 启动 json-server 后端服务。
3. 修改后端请求地址。

   打开 [MyHttp.ets](entry/src/main/ets/utils/MyHttp.ets)，将下面地址改为当前电脑的局域网 IP：

   ```ts
   private static baseUrl: string = 'http://192.168.5.7:3000/'
   ```

   说明：模拟器或真机访问电脑服务时通常不能使用 `127.0.0.1`，需要使用电脑在同一局域网下的真实 IP。

4. 在 DevEco Studio 中选择 `entry` 模块运行，或使用 Hvigor 构建：

   ```bash
   "C:\Users\mao\AppData\Local\Huawei\DevEco Studio\tools\node\node.exe" "C:\Users\mao\AppData\Local\Huawei\DevEco Studio\tools\hvigor\bin\hvigorw.js" --mode module -p product=default -p module=entry@default assembleHap --analyze=normal --parallel --incremental --daemon
   ```

## 测试账号

可在 [db.json](server/db.json) 的 `user` 数组中查看和维护用户数据。当前已有示例用户包括：

```text
mary / 1234
Jerry / 1234
bean / 1234
kitty / 1234
```

如果登录失败，请先确认：

- json-server 是否已经启动。
- `MyHttp.ets` 中的 IP 地址是否是当前电脑局域网 IP。
- 手机/模拟器和电脑是否处在同一网络。
- `db.json` 中用户名和密码是否匹配。

## 任务完成情况说明

### 2、完成鸿蒙 + json-server 的健身预约 App 应用，要求

本项目已完成基于 HarmonyOS ArkTS 的健身预约 App 基础功能，并引入 `json-server` 作为模拟后端服务。App 通过 `@ohos.net.http` 请求 `server/db.json` 中的数据，实现用户注册、登录、用户资料修改以及首页快捷入口数据加载。

后端数据文件位于 [db.json](server/db.json)，HTTP 请求封装位于 [MyHttp.ets](entry/src/main/ets/utils/MyHttp.ets)。运行项目时，需要先启动 json-server 服务，并将 [MyHttp.ets](entry/src/main/ets/utils/MyHttp.ets) 中的 `baseUrl` 修改为当前电脑的局域网 IP。

### （1）完成个人中心的用户资料修改，要使用 http + json + server

该任务已完成。个人中心进入“修改个人资料”页面后，可以修改用户名、手机号和头像。提交时通过 HTTP `PUT /user/:id` 请求更新 json-server 中的用户数据，服务端数据会同步写入 [db.json](server/db.json) 的 `user` 表。

涉及文件：

- [Mine.ets](entry/src/main/ets/pages/mine/Mine.ets)：个人中心页面，展示当前登录用户的头像和用户名，并提供“修改个人资料”入口。
- [Update.ets](entry/src/main/ets/pages/mine/Update.ets)：用户资料修改页面，支持修改用户名、手机号和头像。
- [MyHttp.ets](entry/src/main/ets/utils/MyHttp.ets)：封装 HTTP 请求，其中 `updateById` 方法使用 `PUT` 请求更新用户资料。
- [User.ets](entry/src/main/ets/entity/User.ets)：用户实体类，包含 `username`、`password`、`mobile`、`avatar` 等字段。
- [db.json](server/db.json)：json-server 数据源，保存用户信息。

完成效果：

- 登录后，“我的”页面能够显示当前用户信息。
- 点击“修改个人资料”可以进入资料修改页面。
- 修改用户名、手机号或头像后点击保存，会通过 HTTP 请求更新服务端数据。
- 修改成功后会同步刷新 AppStorage 中的用户信息，返回个人中心后可以看到最新资料。

### （2）优化并完善个人中心跳转的 TestInfo.ets 组件，要求图文并茂

该任务已完成。`TestInfo.ets` 已从简单测试页面优化为图文结合的信息展示组件，用于承接个人中心中的 Navigation 跳转示例。页面加入了图片、标题、说明文字和跳转参数展示，整体内容更完整，符合“图文并茂”的要求。

涉及文件：

- [Mine.ets](entry/src/main/ets/pages/mine/Mine.ets)：个人中心中提供 `Navigation跳转` 入口，并向 TestInfo 页面传递参数。
- [TestInfo.ets](entry/src/main/ets/pages/mine/TestInfo.ets)：优化后的图文展示组件，展示图片、说明内容和跳转参数。
- [main_pages.json](entry/src/main/resources/base/profile/main_pages.json)：页面路由配置文件，包含个人中心相关页面。

完成效果：

- 在“我的”页面点击 `Navigation跳转` 后，可以进入 TestInfo 展示页。
- TestInfo 页面包含图片展示、文字说明和参数信息，不再是单一文字测试页。
- 页面视觉效果更完整，能够作为个人中心跳转示例和项目功能说明页面使用。


## 常见问题


### 服务端可以打开，但 App 请求失败

优先检查 `MyHttp.ets` 的 `baseUrl`。模拟器访问电脑上的 json-server 时，应使用电脑局域网 IP，例如：

```text
http://192.168.x.x:3000/
```

不要直接使用：

```text
http://127.0.0.1:3000/
```

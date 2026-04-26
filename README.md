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

## 当前实现状态

已完成：

- 用户注册、登录、资料修改接入 `http + json-server`。
- 登录成功后返回原页面，不再重复打开新的“我的”页面。
- 登录状态在“我的”和“预约”页面同步展示。
- 头像支持默认显示、修改和保存。
- 首页、场馆动态、场馆预约列表的占位文案已替换为中文内容。
- 个人中心、登录页、注册页 UI 已优化。

待完善：

- 预约提交目前仍使用本地 `PlayerDao` / `relationalStore`，尚未完全迁移到 `http + json-server`。
- `server/db.json` 当前还没有独立的预约记录表。
- 所有预约页暂未实现取消预约。
- 手机日程、分发到其它设备目前是占位提示功能。
- 场馆可预约时段、库存和占用状态目前是前端静态展示。

## 常见问题

### 构建提示 `DEVECO_SDK_HOME` 无效

说明 DevEco Studio SDK 环境变量配置异常。可以在 DevEco Studio 中重新检查 SDK 路径，或按提示执行 `hvigorw --stop-daemon` 后重新构建。

### 服务端可以打开，但 App 请求失败

优先检查 `MyHttp.ets` 的 `baseUrl`。模拟器访问电脑上的 json-server 时，应使用电脑局域网 IP，例如：

```text
http://192.168.x.x:3000/
```

不要直接使用：

```text
http://127.0.0.1:3000/
```

### 修改 `db.json` 后数据没有变化

确认 json-server 是否正在使用当前项目的 [db.json](server/db.json)。如果服务未自动刷新，可以停止后重新启动 json-server。

## 开发建议

后续如果要继续完善预约模块，建议新增 `reservations` 表，并在 `MyHttp.ets` 中补充预约相关接口：

```text
GET    /reservations?mobile=xxx
POST   /reservations
DELETE /reservations/:id
PUT    /reservations/:id
```

然后将 [Application.ets](entry/src/main/ets/pages/restime/Application.ets) 的提交逻辑和 [Reports.ets](entry/src/main/ets/pages/restime/Reports.ets) 的查询逻辑统一迁移到 HTTP 服务端，这样用户数据和预约数据就都能通过 json-server 管理。

//页面的切换有两种方式：
// 系统的路由对象router(简洁,页面顶部与底部需要自定义)，Navigation导航组件(功能强大，自带顶部与底航条)。
//导入导航子组件文件
import Info from './TestInfo';
//导入Player实体类
import Player from '../../entity/Player'
import PlayerDao from '../../utils/PlayerDao'

//声明方法，获取当前登录的用户名
function go() {
  let uname = AppStorage.get('username') as string;
  if (uname != undefined && uname != null && uname != "") {
    return uname;
  } else {
    return '';
  }
}

/**
 * 关于我的组件
 */
@Preview
@Component
export default struct Mine {
  @State message: string = "您今天没有预约哦~";
  @StorageLink('username') username: string = ''; //调用函数
  @StorageLink('mobile') mobile: string = '';
  @StorageLink('avatar') avatar: string = 'myback.png';
  //隐藏或显示预约按钮
  @State flag1: Visibility = Visibility.Visible;
  //隐藏或显示出示二维码接钮
  @State flag2: Visibility = Visibility.None;
  //二维码码显示设置
  @State qcflag: Visibility = Visibility.None;
  //今天的玩家报名信息,用于生成二维码
  @State curPlayer: Player | null = null;
  //切换登录与注销
  @State login: string = '用户登录';
  @State loginColor: string = '#fff';
  ////导航路径栈,官方建议通过Navigation实现跳转,用于替代router,进阶课程将全面应用它///
  private navpath: NavPathStack = new NavPathStack();

  @Builder
  buildMenuItem(title: string, desc: string, color: string, action: () => void) {
    Row() {
      Column() {
        Text(title)
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333')
        Text(desc)
          .fontSize(13)
          .fontColor('#999')
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Text('>')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor(color)
        .width(28)
        .textAlign(TextAlign.End)
    }
    .width('100%')
    .padding({ left: 18, right: 18, top: 15, bottom: 15 })
    .backgroundColor(Color.White)
    .onClick(action)
  }

  //Navigation导航组件，要求声明切换到目标页面的函数
  @Builder
  pageMap(name: string) {
    //指定的页面名称
    if (name == 'info') {
      //加载目标组件页面
      Info();
    }
  }

  //初始化预约数据,注意组件生命周期的特点,不能用aboutappear
  aboutToAppear() {
    //取已登录过的用户
    this.username = go();
    //获取登录用户的手机号,以便获得报名信息
    if (this.username != '') {
      this.login = "用户退出"
      this.loginColor = '#fcc';
      if (this.mobile != undefined) {
        ////修改为通过http请示：查询json-server服务器拿到数据////
        //查询内置SQLite数据库,用户所有的预约信息,注意此下的调用方式
        PlayerDao.queryAll(this.mobile).then((data) => {
          if (data.length > 0) { //直接将数据提供给UI
            for (let i = 0; i < data.length; i++) {
              if (data[i].state == '进行中') {
                this.curPlayer = data[i];
                this.message = this.curPlayer.venue;
                this.flag1 = Visibility.None;
                this.flag2 = Visibility.Visible;
                break;
              }
            }
          } else {
            this.message = '您今天没有预约哦！';
            this.flag1 = Visibility.Visible;
            this.flag2 = Visibility.None;
          }
        })
      }
    } else { //用户未登录
      this.flag1 = Visibility.Visible;
      this.flag2 = Visibility.None;
      this.login = "用户登录"
      this.loginColor = '#fff';
    }
  }

  ////构建UI
  build() {
    ////使用一下官方推荐的导航组件Navigation实现跳转,在进阶课程将完全使用此组件////
    Navigation(this.navpath) {
      Column() {
        //生成当前用户对应的二维码
        Column() {
          //将当前用户报名信息生成二维码
          Text('预约人：' + (this.curPlayer != null ? this.curPlayer?.name : '') + ' ' +
            (this.curPlayer != null ? this.curPlayer?.pdate : ''))
            .fontSize(20).height(30).margin({ top: 10 })
          //二维码组件,传一个json字符串
          QRCode(JSON.stringify(this.curPlayer)).size({ width: 230, height: 230 }).margin({ top: 10, bottom: 20 })
          Button('退出展示')
            .width(150)
            .backgroundColor(Color.Pink)
            .fontColor('#555')
            .fontSize(16)
            .onClick(() => { //隐藏二维码
              this.qcflag = Visibility.None;
            })
        }
        .width('100%')
        .height('100%')
        .backgroundColor(Color.White)
        //用到了定位
        .position({ y: 200 })
        .zIndex(88)
        .visibility(this.qcflag);

        Column() {
          Row() {
            Image($rawfile(`imgs/yuyue/${this.avatar == '' ? 'myback.png' : this.avatar}`))
              .width(72)
              .height(72)
              .borderRadius(36)
              .objectFit(ImageFit.Cover)
              .border({ width: 4, color: '#E9FFF7' })
              .margin({ right: 16 })
              .onClick(() => {
                if (this.username != '') {
                  this.getUIContext().getRouter().pushUrl({ url: 'pages/mine/Update' })
                }
              })

            Column() {
              Text(this.username == '' ? '欢迎使用健身预约' : this.username)
                .fontColor(Color.White)
                .fontSize(27)
                .fontWeight(FontWeight.Bold)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
              Text(this.username == '' ? '登录后查看预约和个人资料' : '欢迎回来，今天也动起来')
                .fontColor('#E9FFF7')
                .fontSize(14)
                .margin({ top: 8 })
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Start)
          }
          .width('100%')
          .padding({ left: 24, right: 24, top: 42 })

          Row() {
            Button(this.username == '' ? '用户登录' : '用户退出')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.username == '' ? '#27C189' : '#C43A3A')
              .backgroundColor(Color.White)
              .height(38)
              .borderRadius(19)
              .onClick(() => {
                if (this.username == '') {
                  this.getUIContext().getRouter().pushUrl({ url: 'pages/mine/Login' })
                } else {
                  this.username = '';
                  this.message = '您今天没有预约哦！';
                  this.flag1 = Visibility.Visible;
                  this.flag2 = Visibility.None;
                  AppStorage.clear();
                }
              })
            Button('马上注册')
              .fontSize(16)
              .fontColor(Color.White)
              .backgroundColor('rgba(255,255,255,0.22)')
              .height(38)
              .borderRadius(19)
              .margin({ left: 12 })
              .visibility(this.username == '' ? Visibility.Visible : Visibility.None)
              .onClick(() => {
                this.getUIContext().getRouter().pushUrl({ url: 'pages/mine/Register' })
              })
          }
          .width('100%')
          .padding({ left: 24, right: 24, top: 18 })
        }
        .width('100%')
        .height('28%')
        .backgroundColor('#27C189');

        ////1.今日预约
        Column() {
          Row() {
            Text('今日预约')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor('#222')
              .layoutWeight(1)
            Text(this.flag2 == Visibility.Visible ? '进行中' : '暂无预约')
              .fontSize(14)
              .fontColor(this.flag2 == Visibility.Visible ? '#27C189' : '#999')
              .backgroundColor(this.flag2 == Visibility.Visible ? '#E9FFF7' : '#F2F2F2')
              .borderRadius(12)
              .padding({ left: 10, right: 10, top: 4, bottom: 4 })
          }
          .width('100%')
          Row() {
            //提示信息
            Text(this.message)
              .fontSize(18)
              .fontColor('#666')
              .layoutWeight(1)
            //去预约
            Button('马上预约')
              .backgroundColor('#FFF3F3')
              .fontSize(15)
              .fontColor('#D93030')
              .height(34)
              .borderRadius(17)
              .onClick(() => {
                if (this.username == null || this.username == undefined || this.username == '') {
                  AlertDialog.show({ title: '登录提示', message: '请您先登录后再进行修改!' })
                } else {
                  this.getUIContext()
                    .getRouter()
                    .pushUrl({ url: 'pages/restime/MyRestime', params: { player: this.curPlayer } })
                }
              })
              .visibility(this.flag1);
            //生成二维码
            Button('出示二维码')
              .backgroundColor('#E9FFF7')
              .fontSize(15)
              .fontColor('#27C189')
              .height(34)
              .borderRadius(17)
              .visibility(this.flag2)
              .onClick(() => {
                this.qcflag = Visibility.Visible;
              })
            //直接生成二维码
          }.margin({ top: 18 }).width('100%')
        }
        .width('92%')
        .height('15%')
        .backgroundColor(Color.White)
        .borderRadius(12)
        .margin({ top: -18 })
        .padding(18)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Start)

        Column() {
          this.buildMenuItem('我的所有预约', '查看全部预约记录和状态', '#27C189', () => {
            if (this.username == '' || this.username == null || this.username == undefined) {
              AlertDialog.show({ title: '查询提示', message: '请先登录后再查询！' })
            } else { //我的报告
              this.getUIContext().getRouter().pushUrl({ url: 'pages/mine/Reports' })
            }
          })
          Divider().width('92%').alignSelf(ItemAlign.Center).color('#EEEEEE')
          this.buildMenuItem('修改个人资料', '更新手机号、密码和头像', '#27C189', () => {
            if (this.username == '' || this.username == undefined) {
              //最的对话框，需要通过上下文对象来取
              this.getUIContext().showAlertDialog({ title: '登录提示', message: '请您先登录后再进行修改!' })
            } else { //我的更新
              this.getUIContext().getRouter().pushUrl({ url: 'pages/mine/Update' })
            }
          })
          Divider().width('92%').alignSelf(ItemAlign.Center).color('#EEEEEE')
          this.buildMenuItem('关于我们', '了解应用服务和团队信息', '#27C189', () => {
            this.getUIContext().showAlertDialog({
              title: '健身预约',
              message: '提供场馆查询、预约报名、个人预约管理等服务，让运动安排更轻松。'
            });
          })
          Divider().width('92%').alignSelf(ItemAlign.Center).color('#EEEEEE')
          this.buildMenuItem('Navigation跳转', '查看导航组件图文说明', '#B12A2A', () => {
            //通过导航组件跳转到下一页TestInfo：组件名,传递参数
            //name的值必须与pageMap方法中定义的name==“名称”中的名称一样
            this.navpath.pushPath({ name: 'info', param: '来自个人中心的导航参数' })
            //或者
            //this.navpath.pushPathByName('Info','你好DeepSeek!');
          })
        }
        .width('92%')
        .backgroundColor(Color.White)
        .borderRadius(12)
        .margin({ top: 12 })
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F7F6')
      .alignSelf(ItemAlign.Center);
      ////目标导航组件设置,传一个跳转方法名,不能带()////
    }.navDestination(this.pageMap)
    ///隐藏菜单标题
    .hideTitleBar(true)
    ///隐藏底部导航条
    .hideToolBar(true)
    //标题模式，这里是全屏模式:free,mini
    .titleMode(NavigationTitleMode.Full)
  } //build
}

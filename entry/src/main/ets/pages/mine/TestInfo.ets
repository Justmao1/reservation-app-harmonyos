/**
 * 测试信息组件, 用于演示 Navigation 导航组件的页面跳转与参数传递。
 * 在 Mine.ets 中导入并通过 navDestination 加载。
 */
@Preview
@Component
export default struct TestInfo {
  @State info: string = '暂无传参';
  @State navstack: NavPathStack = new NavPathStack();

  @Builder
  buildFeature(title: string, desc: string, icon: Resource) {
    Row() {
      Image(icon)
        .width(46)
        .height(46)
        .borderRadius(8)
        .objectFit(ImageFit.Cover)
        .margin({ right: 12 })

      Column() {
        Text(title)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#222')
          .width('100%')
        Text(desc)
          .fontSize(14)
          .fontColor('#666')
          .lineHeight(20)
          .margin({ top: 6 })
          .width('100%')
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(14)
    .backgroundColor(Color.White)
    .borderRadius(10)
    .margin({ top: 10 })
  }

  @Builder
  buildStep(index: string, title: string, desc: string) {
    Row() {
      Text(index)
        .width(32)
        .height(32)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)
        .backgroundColor('#27C189')
        .borderRadius(16)
        .margin({ right: 12 })

      Column() {
        Text(title)
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333')
        Text(desc)
          .fontSize(14)
          .fontColor('#777')
          .lineHeight(20)
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
    }
    .width('100%')
    .margin({ top: 14 })
  }

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          Stack({ alignContent: Alignment.BottomStart }) {
            Image($rawfile('imgs/yuyue/reserv.png'))
              .width('100%')
              .height(190)
              .objectFit(ImageFit.Cover)
              .borderRadius(12)

            Column() {
              Text('Navigation 详情页')
                .fontSize(26)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
              Text('个人中心跳转测试与功能说明')
                .fontSize(15)
                .fontColor('#F4FFFB')
                .margin({ top: 6 })
            }
            .alignItems(HorizontalAlign.Start)
            .padding({ left: 18, right: 18, bottom: 18 })
            .width('100%')
            .linearGradient({
              angle: 0,
              colors: [['rgba(0,0,0,0.62)', 0.0], ['rgba(0,0,0,0.05)', 1.0]]
            })
            .borderRadius(12)
          }
          .width('100%')
          .height(190)

          Column() {
            Text('接收到的参数')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#222')
              .width('100%')
            Text(this.info)
              .fontSize(16)
              .fontColor('#27C189')
              .fontWeight(FontWeight.Medium)
              .margin({ top: 8 })
              .width('100%')
          }
          .alignItems(HorizontalAlign.Start)
          .padding(16)
          .width('100%')
          .backgroundColor(Color.White)
          .borderRadius(10)
          .margin({ top: 14 })

          Text('页面亮点')
            .fontSize(21)
            .fontWeight(FontWeight.Bold)
            .fontColor('#222')
            .width('100%')
            .margin({ top: 18 })

          this.buildFeature(
            '图文展示',
            '使用项目已有图片资源，让测试页面不再只是文字说明，视觉上更接近真实业务页面。',
            $rawfile('imgs/quicks/meet1.png')
          )
          this.buildFeature(
            '参数接收',
            '从个人中心通过 NavPathStack 传入参数，并在当前页面中展示，便于验证跳转链路。',
            $rawfile('imgs/quicks/news1.png')
          )
          this.buildFeature(
            '业务入口',
            '可以作为个人中心扩展页面的模板，后续能继续承载关于我们、使用说明或服务介绍。',
            $rawfile('imgs/yuyue/play7.jpg')
          )

          Column() {
            Text('跳转流程')
              .fontSize(21)
              .fontWeight(FontWeight.Bold)
              .fontColor('#222')
              .width('100%')

            this.buildStep('1', '点击个人中心入口', '用户在“我的”页面点击 Navigation 跳转。')
            this.buildStep('2', '压入导航路径', 'Mine.ets 调用 navpath.pushPath 进入当前组件。')
            this.buildStep('3', '读取页面参数', 'TestInfo.ets 在 onReady 中读取 pathStack 参数并渲染到页面。')
          }
          .alignItems(HorizontalAlign.Start)
          .padding(16)
          .width('100%')
          .backgroundColor(Color.White)
          .borderRadius(10)
          .margin({ top: 14, bottom: 20 })
        }
        .width('100%')
        .padding({ left: 14, right: 14, top: 12 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F3F6F5')
    }.onReady((context: NavDestinationContext) => {
      this.navstack = context.pathStack;
      let temp = this.navstack.getParamByName('info') as string[];
      if (temp != null && temp.length > 0) {
        this.info = temp[0];
      }
    })
    .title('Navigation导航组件')
  }
}

import Msg from '../../entity/News';

/**
 * 场馆动态组件
 */
@Preview
@Component
export default struct Message {
  @State message: string = '场馆动态'

  private msgs: Array<Msg> = [
    new Msg(
      'play5',
      '优天地网球馆重新开放，场外扫码自助入场',
      '网球馆前台系统升级已完成。用户可通过预约码核验入场，场外扫码完成签到，减少排队等待时间。',
      '2024-5-22'
    ),
    new Msg(
      'play2',
      '公告 | 羽毛球场恢复对外开放通知',
      '羽毛球馆照明与地胶维护已结束，今日起恢复预约。请按预约时段到场，运动前做好热身。',
      '2024-5-20'
    ),
    new Msg(
      'play4',
      '乒乓球场预约开放，请提前锁定时段',
      '乒乓球区晚间时段较为热门，建议提前预约。到场后请出示预约信息，由工作人员核验入场。',
      '2024-5-20'
    ),
    new Msg(
      'play1',
      '通知 | 明晚社区足球友谊赛开放报名',
      '社区足球友谊赛将于明晚举行，欢迎足球爱好者报名参与。名额有限，报名成功后请准时到场。',
      '2024-5-18'
    ),
    new Msg(
      'play3',
      '篮球场临时维护，开放时间另行通知',
      '生活广场篮球场正在进行篮架与地面维护，维护期间暂停预约。恢复开放后将第一时间发布通知。',
      '2024-5-16'
    )
  ]

  build() {
    Column() {
      Row() {
        Text('<')
          .width('10%')
          .height('100%')
          .textAlign(TextAlign.Center)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .onClick(() => {
            this.getUIContext().getRouter().back();
          })
        Text(this.message)
          .width('90%')
          .height('100%')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
          .padding({ right: 36 })
      }
      .width('100%')
      .height('12%')
      .backgroundColor('#27C189')

      List({ space: 12 }) {
        ForEach(this.msgs, (item: Msg) => {
          ListItem() {
            Column() {
              Text(item.title)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor('#222')
                .margin({ bottom: 10 })
                .width('100%')

              Row() {
                Image($rawfile(`imgs/yuyue/` + item.pic + `.jpg`))
                  .width(105)
                  .height(82)
                  .margin({ right: 8 })
                  .borderRadius(8)
                  .objectFit(ImageFit.Cover)
                Text(item.info)
                  .height(82)
                  .layoutWeight(1)
                  .fontSize(18)
                  .fontColor('#555')
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(4)
                  .align(Alignment.TopStart)
              }
              .width('100%')

              Text(item.date)
                .width('100%')
                .fontColor(Color.Grey)
                .margin({ top: 8 })
            }
          }
          .backgroundColor('#fff')
          .borderRadius(10)
          .padding(10)
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({
              url: 'pages/common/MyDetail',
              params: { title: '场馆动态', jsonstr: JSON.stringify(item) }
            })
          })
        })
      }
      .width('94%')
      .height('100%')
      .layoutWeight(1)
      .listDirection(Axis.Vertical)
      .margin({ top: 8 })
    }
    .width('100%')
    .height('100%')
  }
}

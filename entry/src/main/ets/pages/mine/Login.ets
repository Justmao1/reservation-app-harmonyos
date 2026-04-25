import { promptAction } from '@kit.ArkUI';
import Request from '../../utils/MyHttp'

@Entry
@Component
struct Login {
  @State username: string = '';
  @State password: string = '';

  build() {
    Column() {
      Row() {
        Text('<')
          .width(48)
          .height('100%')
          .textAlign(TextAlign.Center)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .onClick(() => {
            this.getUIContext().getRouter().back()
          })
        Text('用户登录')
          .layoutWeight(1)
          .height('100%')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
          .padding({ right: 48 })
      }
      .width('100%')
      .height('12%')
      .backgroundColor('#27C189')

      Column() {
        Text('欢迎回来')
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .fontColor('#222')
          .width('100%')
        Text('登录后即可查看预约记录和个人资料')
          .fontSize(15)
          .fontColor('#888')
          .margin({ top: 8, bottom: 28 })
          .width('100%')

        Text('用户名')
          .fontSize(16)
          .fontColor('#555')
          .width('100%')
        TextInput({ placeholder: '请输入用户名' })
          .width('100%')
          .height(52)
          .margin({ top: 10, bottom: 18 })
          .fontSize(17)
          .backgroundColor('#F5F7F6')
          .borderRadius(10)
          .padding({ left: 14, right: 14 })
          .onChange((value: string) => {
            this.username = value
          })

        Text('密码')
          .fontSize(16)
          .fontColor('#555')
          .width('100%')
        TextInput({ placeholder: '请输入密码' })
          .width('100%')
          .height(52)
          .margin({ top: 10, bottom: 28 })
          .fontSize(17)
          .type(InputType.Password)
          .backgroundColor('#F5F7F6')
          .borderRadius(10)
          .padding({ left: 14, right: 14 })
          .onChange((value: string) => {
            this.password = value;
          })

        Button('登录')
          .width('100%')
          .height(48)
          .backgroundColor('#27C189')
          .borderRadius(24)
          .fontSize(18)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            if (this.username == '' || this.username == undefined || this.username == null) {
              promptAction.openToast({ message: '用户名不能为空' })
              return;
            } else if (this.password == '' || this.password == undefined || this.password == null) {
              promptAction.openToast({ message: '密码不能为空' })
              return;
            }
            Request.login(this.username, this.password).then((res: string) => {
              if (res === 'ok') {
                AppStorage.setOrCreate<string>('username', this.username)
                this.getUIContext().getRouter().back()
                return;
              } else {
                promptAction.openToast({ message: res })
              }
            })
          })

        Row() {
          Text('还没有账号？')
            .fontSize(15)
            .fontColor('#999')
          Text('马上注册')
            .fontSize(15)
            .fontColor('#27C189')
            .fontWeight(FontWeight.Bold)
            .margin({ left: 6 })
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({ url: 'pages/mine/Register' })
            })
        }
        .margin({ top: 22 })
        .justifyContent(FlexAlign.Center)
        .width('100%')
      }
      .width('88%')
      .padding(24)
      .backgroundColor(Color.White)
      .borderRadius(14)
      .margin({ top: 36 })
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F7F6')
  }
}

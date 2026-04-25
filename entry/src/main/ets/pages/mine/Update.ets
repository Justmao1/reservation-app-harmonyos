import { router } from '@kit.ArkUI';
import User from '../../entity/User';
////请修改为http方式与json-server方式来实现
import MyHttp from '../../utils/MyHttp';

/**
 * 更新个人资料
 */
@Entry
@Component
struct Update {
  @State message: string = '个人资料更新'
  //用户基本信息
  @State username: string = '';
  @State mobile: string = '';
  @State password: string = '';
  @State avatar: string = 'myback.png';
  @State user: User | null = null;
  private avatars: string[] = ['myback.png', 'play1.jpg', 'play2.jpg', 'play7.jpg'];

  //初始用户信息
  aboutToAppear() {
    this.user = AppStorage.get<User>('user') as User;
    //重新赋值
    if (this.user != null) {
      this.username = this.user.username;
      this.password = this.user.password;
      this.mobile = this.user.mobile;
      this.avatar = this.user.avatar != undefined && this.user.avatar != '' ? this.user.avatar : 'myback.png';
    }
  }

  ////构建UI
  build() {
    Column() {
      ////1.修改提示
      Row() {
        Text('<')
          .width('10%')
          .height('100%')
          .textAlign(TextAlign.Center)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .onClick(() => { //返回我的
            router.back();
          })
        Text(this.message)
          .width('90%')
          .height('100%')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
          .padding({ right: 36 })
      }.width('100%')
      .height('12%')
      .backgroundColor('#27C189')

      ////2.用户信息修改
      Text('头像：').fontSize(20).margin({ top: 26, left: 10 })
      Row() {
        ForEach(this.avatars, (item: string) => {
          Image($rawfile(`imgs/yuyue/${item}`))
            .width(62)
            .height(62)
            .borderRadius(31)
            .objectFit(ImageFit.Cover)
            .border({ width: this.avatar == item ? 3 : 1, color: this.avatar == item ? '#27C189' : '#ddd' })
            .margin({ right: 12 })
            .onClick(() => {
              this.avatar = item;
            })
        })
      }
      .width('80%')
      .height(78)
      .alignSelf(ItemAlign.Center)
      .alignItems(VerticalAlign.Center)

      //用户
      Text('用户名：').fontSize(20).margin({ top: 12, left: 10 })
      TextInput({ placeholder: '修改用户名', text: this.username })
        .width('80%')
        .height(50)
        .alignSelf(ItemAlign.Center)
        .margin({ top: 20 })
        .fontSize(18)
        .onChange((value: string) => {
          this.username = value;
        })

      //密码
      Text(`密   码：`).fontSize(20).margin({ top: 20, left: 10 })
      TextInput({ placeholder: '修改密码', text: this.password })
        .width('80%')
        .height(50)
        .alignSelf(ItemAlign.Center)
        .margin({ top: 20 })
        .fontSize(18)
        .type(InputType.Password)
        .onChange((value: string) => {
          this.password = value;
        })
      Text('手机号：').fontSize(20).margin({ top: 20, left: 10 })
      TextInput({ placeholder: '修改手机号', text: this.mobile })
        .width('80%')
        .height(50)
        .alignSelf(ItemAlign.Center)
        .margin({ top: 20 })
        .fontSize(18)
        .onChange((value: string) => {
          this.mobile = value;
        })

      Button('确认修改')
        .width('86%')
        .height(50)
        .alignSelf(ItemAlign.Center)
        .backgroundColor(0x27C189)
        .fontSize(20)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 30 })
        .onClick(() => { //执行修改
          if (this.username == '') {
            //系统对话框提示
            AlertDialog.show({ message: '用户名不能为空' })
            return;
          }
          if (this.password == '') {
            //系统对话框提示
            AlertDialog.show({ message: '密码不能为空' })
            return;
          }
          if (this.mobile == '') {
            //系统对话框提示
            AlertDialog.show({ message: '手机号不能为空' })
            return;
          }
          if (this.user != null) {
            //更新用户信息
            this.user.username = this.username;
            this.user.password = this.password;
            this.user.mobile = this.mobile;
            this.user.avatar = this.avatar;
            //执行json-server修改
            MyHttp.updateById(this.user.id, this.user).then((res: User) => {
              //重新存入缓存
              AppStorage.setOrCreate<string>('username', res.username);
              AppStorage.setOrCreate<string>('mobile', res.mobile);
              AppStorage.setOrCreate<string>('avatar', res.avatar != undefined && res.avatar != '' ? res.avatar : 'myback.png');
              AppStorage.setOrCreate<User>('user', res);
              //修改成功直接返回
              AlertDialog.show({ message: '修改成功!' })
            }).catch(() => {
              AlertDialog.show({ message: '修改失败，请检查json-server服务是否启动' })
            })
            return;
          }
          AlertDialog.show({ message: '未获取到登录用户信息，请重新登录' })
        })
    } //column-end
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .height('100%')
  }
}

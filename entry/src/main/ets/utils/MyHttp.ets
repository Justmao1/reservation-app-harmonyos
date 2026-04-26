import http from '@ohos.net.http'
import Quick from '../entity/Quick';
import User from '../entity/User';

/**
 * @Date 2026-04-17
 * @Author 天涯
 * @Email t8899@sina.com
 * 与后台服务器交互的网络请求
 * http封装各种方法，实现get/post/delete/put请求
 * 请将以下代码封装为通用方式：结合async(同步)与await及Promise异步对象，实现异步方式同步执行。
 */
export default class MyHttp {
  //通用的IP地址，在Previewer中可用，手机模拟器不可用。
  //private static baseUrl: string = 'http://127.0.0.1:3000/'
  ////这里用ipconfig查询到真实IP后，改为你自己的IP地址，手机模拟器可用。
  private static baseUrl: string = 'http://192.168.5.7:3000/'
  /**
   * 1.实现网络请求，查询金刚区所有图片文件
   */
  static getAllImages(): Promise<Array<Quick>> {
    return new Promise<Array<Quick>>((resolve, reject) => {
      //创建请求对象
      let httpRequest = http.createHttp();
      //服务器中表的地址
      httpRequest.request(MyHttp.baseUrl + 'quicks', {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'application/json'
        },
        connectTimeout: 3000,
        readTimeout: 3000
      }, //取数据
        (err, data) => {
          if (err) {
            reject(err);
          } else {
            //创建数组
            let quicks: Array<Quick> = [];
            quicks = JSON.parse(data.result.toString());
            //返回的数据
            resolve(quicks);
          }
        }
      )
    })
  }

  /**
   * 2.用户登录,在服务中添加数据
   */
  static login(username: string, password: string): Promise<string> {
    return new Promise<string>((resolve, reject) => {
      //////1.创建请求对象
      let httpRequest = http.createHttp();
      //////2.服务器请求
      httpRequest.request(MyHttp.baseUrl + 'user', {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'application/json'
        },
        connectTimeout: 3000,
        readTimeout: 3000
      }, (err, data) => { //异常判断
        if (err) { //系统有误
          reject(err)
          return;
        }
        //系统正常,拿到json字符串数组转成数组[{username:'tom',password:'1234',mobile:'13127683502'}]
        //data.result->返回[]或[{id:1002,username:'tom',password:'1234',mobile:'13127683502'}]
        let users = JSON.parse(data.result.toString()) as Array<User>;
        let temp: User | null = null;
        for (let i = 0; i < users.length; i++) {
          if (users[i].username == username && users[i].password == password) {
            temp = users[i];
            break;
          }
        }
        //判断是否查询到此用户
        if (temp != null) {
          //存储用户信息,是数组第一个元素，以后修改用户信息
          AppStorage.setOrCreate<User>("user", temp);
          AppStorage.setOrCreate<string>("username", temp.username);
          AppStorage.setOrCreate<string>("mobile", temp.mobile);
          AppStorage.setOrCreate<string>("avatar", temp.avatar != undefined && temp.avatar != '' ? temp.avatar : 'play3.jpg');
          resolve('ok')
        } else {
          resolve('用户名或密码有误')
        }
      })//request-end
    })//promise-end
  }

  /**
   * 3.用户注册
   */
  static register(user: User): Promise<string> { //泛型string是实际返回数据类型
    return new Promise<string>((resolve, reject) => { //lamda表达式函数
      /////1.创建请求对象
      let httpRequest = http.createHttp();
      /////2.发送请求，服务器的请求方法(url,{      },(err,data)=>{ })
      //(地址+表名,请求配置对象{ },回调函数(err,data)=>{ })
      httpRequest.request(MyHttp.baseUrl + 'user', {
        //请求配置对象
        method: http.RequestMethod.POST, //请求的方式
        header: {
          //请求头对象
          'Content-Type': 'application/json'
        },
        extraData: {
          //传递的数据,此处为user对象,不需要传id号
          //传注册的数据
          username: user.username,
          password: user.password,
          mobile: user.mobile,
          avatar: user.avatar
        }
      }, (err, data) => { //异常判断
        if (err) { //系统有误,返回错误
          reject(err)
          return;
        }
        //系统正常,拿到json字符串数组转成数组
        let temp = JSON.parse(data.result.toString()) as User;
        //判断是否查询到此用户
        if (temp != null) {
          resolve('ok')
        } else {
          resolve('用户注册有误')
        }
      })//request-end
    })//promise-end
  }
  /////////////////以下实现更新方法///////////////////
   /**
    * 4.通过http实现用户资料修改
    */
  static updateById(id: number, user: User): Promise<User> {
    return new Promise<User>((resolve, reject) => {
      let httpRequest = http.createHttp();
      httpRequest.request(MyHttp.baseUrl + 'user/' + id, {
        method: http.RequestMethod.PUT,
        header: {
          'Content-Type': 'application/json'
        },
        extraData: {
          id: id,
          username: user.username,
          password: user.password,
          mobile: user.mobile,
          avatar: user.avatar
        },
        connectTimeout: 3000,
        readTimeout: 3000
      }, (err, data) => {
        if (err) {
          reject(err);
          return;
        }
        let temp = JSON.parse(data.result.toString()) as User;
        AppStorage.setOrCreate<User>('user', temp);
        AppStorage.setOrCreate<string>('username', temp.username);
        AppStorage.setOrCreate<string>('mobile', temp.mobile);
        AppStorage.setOrCreate<string>('avatar', temp.avatar != undefined && temp.avatar != '' ? temp.avatar : 'play3.jpg');
        resolve(temp);
      })
    })
  }
}

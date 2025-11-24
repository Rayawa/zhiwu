import { TopNavBar } from "../../components/TopNavBar";

interface GeneratedObjectLiteralInterface_1 {
  action: string;
  entities: string[];
  uri: string;
}

@Entry
@Component
struct about {
  @State isDialogShow: boolean = false; // 控制对话框显示

  build() {
    Stack() {
      Column() {
        Column()
          .width('100%')
          .height(90)


        Column() {
          Image($r('app.media.app_icon')).height(100).width(100).borderRadius($r('sys.float.corner_radius_level6')).margin({top:10})
          Text('知物').fontWeight(800).fontSize(30).margin({top:10})
          Divider().margin(5)
          Row() {
            Text('版本信息').margin({ left: 7 }).fontSize(20)
            Text('1.0.0').margin({ left: 7 }).fontSize(15).fontColor(Color.Grey)
          }
          .height(60)
          .width('90%')
          .justifyContent(FlexAlign.SpaceBetween)

          Divider().margin(5)
          Row() {
            Text('作者').margin({ left: 7 }).fontSize(20)
            Text('Rayawa').margin({ left: 7 }).fontSize(15).fontColor(Color.Grey)
          }
          .height(60)
          .width('90%')
          .justifyContent(FlexAlign.SpaceBetween)
          Divider().margin(5)
        }
        .borderRadius($r('sys.float.corner_radius_level4'))
        .backgroundColor('#05000000')
        .width('90%')
        .margin(10)

        Column(){
          Text('本应用备案域名：rayawa.top')
          Hyperlink('https://beian.miit.gov.cn/#/Integrated/index', '备案号')
            .color(Color.Blue)
          // Text('备案号')
          //   .fontColor(Color.Blue)
          //   .onClick(() => {
          //     this.isDialogShow = true;
          //     AlertDialog.show(
          //       {
          //         title: '即将离开应用',
          //         message: '您将要访问ICP/IP地址/域名信息备案管理系统，是否继续？',
          //         primaryButton: {
          //           value: '取消',
          //           action: () => {
          //             this.isDialogShow = false; // 隐藏对话框
          //             // 用户取消，不执行任何操作
          //           }
          //         },
          //         secondaryButton: {
          //           value: '确定',
          //           action: () => {
          //             this.isDialogShow = false; // 隐藏对话框
          //           }
          //         },
          //         autoCancel: true // 点击对话框外部可关闭
          //       }
          //     )
          //   })
        }
        .justifyContent(FlexAlign.Center)
        .margin(20)
      TopNavBar()

      }
      .width('100%')
      .height('100%')
    }


  }
}
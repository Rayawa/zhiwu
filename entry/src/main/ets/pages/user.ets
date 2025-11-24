import { router } from "@kit.ArkUI"
import { TopNavBar } from '../components/TopNavBar'

@Entry
@Component
struct user {
  build() {
    Stack() {
      Column() {
        Column()
          .width('100%')
          .height(90)

        Column() {
          Row() {
            Row(){
              Image($r('app.media.log')).height(25).width(25)
              Text('更新日志').margin({ left: 6 }).fontSize(20)
            }
            Image($r('app.media.right')).height(25).width(25)
          }
          .onClick(() => router.pushUrl({ url: 'pages/user/log' }))
          .height(60)
          .width('90%')
          .justifyContent(FlexAlign.SpaceBetween)

          Divider().margin(5).width('90%')
          Row() {
            Row(){
              Image($r('app.media.contact')).height(25).width(25)
              Text('联系我们').margin({ left: 7 }).fontSize(20)
            }
            Image($r('app.media.right')).height(25).width(25)
          }
          .onClick(() => router.pushUrl({ url: 'pages/user/contact' }))
          .height(60)
          .width('90%')
          .justifyContent(FlexAlign.SpaceBetween)
      }
        .borderRadius($r('sys.float.corner_radius_level4'))
        .backgroundColor('#05000000')
        .width('90%')
        .margin(10)

        Column() {
          Row() {
            Row(){
              Image($r('app.media.settings')).height(25).width(25)
              Text('关于').margin({ left: 7 }).fontSize(20)
            }
            Image($r('app.media.right')).height(30).width(30)
          }
          .onClick(() => router.pushUrl({ url: 'pages/user/about' }))
          .height(60)
          .width('90%')
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .borderRadius($r('sys.float.corner_radius_level4'))
        .backgroundColor('#05000000')
        .width('90%')
        .margin(10)

        TopNavBar()
    }
    .width('100%')
    .height('100%')
  }
}
}
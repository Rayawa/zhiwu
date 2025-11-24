import { router } from '@kit.ArkUI';
@Component
export struct TopNavBar {
  build() {
    Column() {
      Column() {
        Text('\n').fontSize(14)
      }
      Row() {
        Text('我的物品')
          .fontSize(21)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 15 })
        Row() {
          Image($r('app.media.statistics'))
            .height(24).width(24)
            .margin({ right: 30 })
            .onClick(() => router.pushUrl({ url: 'pages/statistics' }))
          Image($r('app.media.user'))
            .height(24).width(24)
            .margin({ right: 30 })
            .onClick(() => router.pushUrl({ url: 'pages/user' }))
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .height(45)

      Rect()
        .width('100%')
        .height(0.5)
        .fill("#a6d5d5d5")
        .position({ x: 0, y: 78 })

    }
    .backgroundBlurStyle(BlurStyle.Thin)
    .position({ x: 0, y: 0 })
    .width('100%')
  }
}

import { router } from "@kit.ArkUI"

@Entry
@Component
struct statistic {
  build() {
    Column() {
      Column() {
        Column() {
          Text('\n').fontSize(14)
        }
        Row() {
          Text('统计信息')
            .fontSize(21)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 15 })
          Row() {
            Image($r('app.media.back'))
              .height(24).width(24)
              .margin({ right: 30 })
              .onClick(() => router.back())
          }
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .height(45)

        Rect()
          .width('100%')
          .height(0.8)
          .fill($r('app.color.border'))
      }
      .width('100%')
      .backgroundColor($r('app.color.backcolor'))
      Scroll() {
        Column(){

        }
      }

    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.backcolor'))
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
  }
}
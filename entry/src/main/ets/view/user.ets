import { router } from "@kit.ArkUI"

@Entry
@Component
struct User {
  build() {
    Column() {
      Column() {
        Column() {
          Column() {
            Text('\n').fontSize(14)
          }
          Row() {
            Text('我的')
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
            .fill("#a6d5d5d5")
        }
        .width('100%')
        .backgroundColor($r('app.color.backcolor'))

        Column() {
          Column() {
            Row() {
              Image($r('app.media.user_avatar'))
                .height(60)
                .width(60)
                .borderRadius(30)
                .backgroundColor($r('app.color.background'))

              Column() {
                Text('Rayawa')
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)

                Text('欢迎回来！')
                  .fontSize(14)
                  .margin({ top: 4 })
              }
              .margin({ left: 10 })

              Blank()
            }
            .width('100%')
            .padding(16)
          }
          .width('90%')
          .backgroundColor($r('app.color.background'))
          .borderRadius(16)
          .shadow({ radius: 8, color: '#1a000000', offsetX: 0, offsetY: 2 })
          .margin({ top: 20, bottom: 20 })

          // 功能列表
          Column() {
            // 更新日志
            Row() {
              Row() {
                Image($r('app.media.log'))
                  .height(24)
                  .width(24)
                  .objectFit(ImageFit.Contain)

                Text('更新日志')
                  .fontSize(16)
                  .margin({ left: 12 })
              }

              Image($r('app.media.right'))
                .height(16)
                .width(16)
                .objectFit(ImageFit.Contain)
            }
            .onClick(() => router.pushUrl({ url: 'user/log' }))
            .height(56)
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({ left: 16, right: 16 })

            Divider()
              .strokeWidth(0.5)
              .margin({ left: 16, right: 16 })

            // 联系我们
            Row() {
              Row() {
                Image($r('app.media.contact'))
                  .height(24)
                  .width(24)
                  .objectFit(ImageFit.Contain)

                Text('联系我们')
                  .fontSize(16)
                  .margin({ left: 12 })
              }

              Image($r('app.media.right'))
                .height(16)
                .width(16)
                .objectFit(ImageFit.Contain)
            }
            .onClick(() => router.pushUrl({ url: 'user/contact' }))
            .height(56)
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({ left: 16, right: 16 })

            Divider()
              .strokeWidth(0.5)
              .margin({ left: 16, right: 16 })

            // 关于
            Row() {
              Row() {
                Image($r('app.media.settings'))
                  .height(24)
                  .width(24)
                  .objectFit(ImageFit.Contain)

                Text('关于应用')
                  .fontSize(16)
                  .margin({ left: 12 })
              }

              Image($r('app.media.right'))
                .height(16)
                .width(16)
                .objectFit(ImageFit.Contain)
            }
            .onClick(() => router.pushUrl({ url: 'user/about' }))
            .height(56)
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({ left: 16, right: 16 })
          }
          .backgroundColor($r('app.color.background'))
          .borderRadius(16)
          .shadow({ radius: 8, color: '#1a000000', offsetX: 0, offsetY: 2 })
          .width('90%')
          .margin({ bottom: 20 })

          // 底部信息
          Text('Version 1.0.0')
            .fontSize(12)
            .fontColor('#888')
            .margin({ top: 20, bottom: 20 })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .backgroundColor($r('app.color.backcolor'))
  }
}
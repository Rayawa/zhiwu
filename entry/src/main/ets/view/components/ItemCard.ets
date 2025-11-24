import { Item } from '../../model/ItemModel';

@Component
export struct ItemCard {
  @Prop item: Item;
  @Link itemClickHandler: (item: Item) => void;
  @Link deleteClickHandler: (itemId: string) => void;

  build() {
    Column() {
      Image(this.item.imageUri)
        .width('100%')
        .height('200vp')
        .objectFit(ImageFit.Cover)
        .borderRadius(8)

      Column() {
        Text(this.item.name)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 8 })
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Row() {
          Text(`¥${this.item.price}`)
            .fontSize(14)
            .fontColor('#FF6B6B')

          Text(`日均: ¥${this.item.dailyAveragePrice}`)
            .fontSize(12)
            .fontColor('#666')
            .margin({ left: 'auto' })
        }
        .margin({ top: 4 })

        Row() {
          Text(this.item.category)
            .fontSize(12)
            .fontColor('#999')
            .backgroundColor('#F0F0F0')
            .padding({ left: 8, right: 8, top: 2, bottom: 2 })
            .borderRadius(12)

          Text(this.formatDate(this.item.acquireDate))
            .fontSize(12)
            .fontColor('#999')
            .margin({ left: 'auto' })
        }
        .margin({ top: 4 })
      }
      .padding({ left: 8, right: 8, bottom: 8 })
      .width('100%')
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(12)
    .shadow({ radius: 4, color: '#0000001A', offsetX: 0, offsetY: 2 })
    .padding(8)
    .onClick(() => {
      this.itemClickHandler(this.item);
    })
    .gesture(
      LongPressGesture({ repeat: false })
        .onAction(() => {
          this.deleteClickHandler(this.item.id);
        })
    )
  }

  private formatDate(date: Date): string {
    return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
  }
}

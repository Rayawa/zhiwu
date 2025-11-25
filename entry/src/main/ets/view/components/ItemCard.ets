// ItemCard.ets
import { Item } from '../../model/ItemModel';

@Component
export struct ItemCard {
  @Prop item: Item;
  private onItemClick: () => void = () => {};
  private onDeleteClick: () => void = () => {};


  // 使用对象参数接收所有属性，并调用super()
  constructor(params: {
    item: Item;
    onItemClick?: () => void;
    onDeleteClick?: () => void;
  }) {
    super(); // 添加super调用
    this.item = params.item;
    if (params.onItemClick) {
      this.onItemClick = params.onItemClick;
    }
    if (params.onDeleteClick) {
      this.onDeleteClick = params.onDeleteClick;
    }
  }

  build() {
    Column() {
      Image(this.item.imageUri)
        .width('100%')
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
            .fontColor($r('app.color.border'))

          Text(`日均: ¥${this.item.dailyAveragePrice}`)
            .fontSize(12)
            .fontColor('#666')
            .margin({ left: 10 })
        }
        .margin({ top: 4 })

        Row() {
          Text(this.item.category)
            .fontSize(12)
            .fontColor('#999')
            .padding({ left: 8, right: 8, top: 2, bottom: 2 })
            .borderRadius(12)

          Text(this.formatDate(this.item.acquireDate))
            .fontSize(12)
            .fontColor('#999')
            .margin({ left: 10 })
        }
        .margin({ top: 4 })
      }
      .padding({ left: 8, right: 8, bottom: 8 })
      .width('100%')
    }
    .width('100%')
    .backgroundColor($r('app.color.background'))
    .borderRadius(12)
    .shadow({ radius: 4, color: '#0000001A', offsetX: 0, offsetY: 2 })
    .padding(8)
    .onClick(() => {
      this.onItemClick();
    })
    .gesture(
      LongPressGesture({ repeat: false })
        .onAction(() => {
          this.onDeleteClick();
        })
    )
  }

  isDarkMode() {
    throw new Error('Method not implemented.');
  }

  private formatDate(date: Date): string {
    return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
  }
}
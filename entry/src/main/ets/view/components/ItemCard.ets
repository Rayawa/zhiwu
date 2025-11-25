import { Item } from '../../model/ItemModel';

@Component
export struct ItemCard {
  @Prop item: Item;
  private onItemClick: () => void = () => {};
  private onDeleteClick: () => void = () => {};

  constructor(params: {
    item: Item;
    onItemClick?: () => void;
    onDeleteClick?: () => void;
  }) {
    super();
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
      Text(this.item.name)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: 8 , bottom: 1 })
      Text(`¥${this.item.price}`)
        .fontSize(15)
        .fontColor($r('app.color.price'))
        .fontWeight(FontWeight.Bold)
        .margin({bottom:1})
      Text(`日均 ¥${this.item.dailyAveragePrice}`)
        .fontSize(10)
        .fontColor('#777')
        .margin({bottom:1})
        .borderRadius(4)
      Text(this.item.category)
        .fontSize(9)
        .backgroundColor($r('app.color.button'))
        .borderRadius(10)
        .padding({ left: 8, right: 8, top: 2, bottom: 2 })
        .margin({bottom:1})
      Row() {
        Image($r('app.media.calendar'))
          .width(10)
          .height(10)
          .margin({ right: 2 })
        Text(`${this.calculateDays(this.item.acquireDate)}天`)
          .fontSize(9)
          .fontColor($r('app.color.border'))
          .fontWeight(FontWeight.Medium)
      }
      Text(`自${this.formatDate(this.item.acquireDate)}`)
        .fontSize(9)
        .fontColor('#999')
        .margin({bottom:1})
    }
    .width('100%')
    .padding(8)
    .backgroundColor($r('app.color.background'))
    .borderRadius(12)
    .borderWidth(1)
    .borderColor($r('app.color.border'))
    .shadow({
      radius: 8,
      color: '#1824311A',
      offsetX: 0,
      offsetY: 2
    })
    .onClick(() => {
      this.onItemClick();
    })
    .gesture(
      LongPressGesture({ repeat: false }).onAction(() => {this.onDeleteClick();})
    )
  }

  private calculateDays(acquireDate: Date): number {
    try {
      const acquire = acquireDate.getTime();
      const now = new Date().getTime();
      const diffTime = Math.abs(now - acquire);
      const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
      return diffDays;
    } catch (e) {
      console.error('日期计算错误:', e);
      return 0;
    }
  }
  private formatDate(date: Date): string {
    try {
      const year = date.getFullYear();
      const month = (date.getMonth() + 1).toString().padStart(2, '0');
      const day = date.getDate().toString().padStart(2, '0');
      return `${year}-${month}-${day}`;
    } catch (e) {
      console.error('日期格式化错误:', e);
      return '未知日期';
    }
  }
}
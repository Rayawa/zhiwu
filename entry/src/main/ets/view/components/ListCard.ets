import { Item } from '../../model/ItemModel';

@Component
export struct ListCard {
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
    Row() {
      Text(this.item.name)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .layoutWeight(1.5)


      Column() {
        Text(this.item.category)
          .fontSize(9)
          .backgroundColor($r('app.color.button'))
          .padding({ left: 8, right: 8, top: 2, bottom: 2 })
          .borderRadius(10)
        Row() {
          Image($r('app.media.calendar'))
            .width(10)
            .height(10)
            .margin({ right: 2 })
          Text(`${this.calculateDays(this.item.acquireDate)}天`)
            .fontSize(9)
            .fontColor($r('app.color.border'))
            .fontWeight(FontWeight.Medium)
          Text(`自${this.formatDate(this.item.acquireDate)}`)
            .fontSize(9)
            .fontColor('#999')
            .margin({ left: 2 })
        }
        .margin({ top: 4 })
        .alignItems(VerticalAlign.Center)
      }
      .alignItems(HorizontalAlign.Center)
      .layoutWeight(1)

      Column() {
        Text(`¥${this.item.price}`)
          .fontSize(15)
          .fontColor($r('app.color.price'))
          .fontWeight(FontWeight.Bold)
        Text(`日均 ¥${this.item.dailyAveragePrice}`)
          .fontSize(10)
          .fontColor('#777')
          .padding({ left: 4, right: 4, top: 1, bottom: 1 })
          .borderRadius(4)
          .margin({ top: 2 })
      }
      .alignItems(HorizontalAlign.End)
      .layoutWeight(1)
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
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
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .margin({bottom: 4})
    .onClick(() => {
      this.onItemClick();
    })
    .gesture(
      LongPressGesture({ repeat: false }).onAction(() => {this.onDeleteClick();})
    )
  }

  isDarkMode() {
    throw new Error('Method not implemented.');
  }

  private calculateDays(acquireDate: Date): number {
    try {
      const acquire = new Date(acquireDate).getTime();
      const now = new Date().getTime();
      const diffTime = Math.abs(now - acquire);
      const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
      return diffDays;
    } catch (e) {
      console.error('日期计算错误:', e);
      return 0;
    }
  }
  private formatDate(dateString: Date): string {
    try {
      const date = new Date(dateString);
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
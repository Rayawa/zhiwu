// 物品详情页面
import { ItemViewModel } from '../viewmodel/ItemViewModel';
import { Item } from '../model/ItemModel';
import router from '@ohos.router';

@Entry
@Component
export struct ItemDetailPage {
  private itemViewModel: ItemViewModel = new ItemViewModel();
  @State item: Item | null = null;
  @State isLoading: boolean = true;

  async aboutToAppear() {
    const params = router.getParams() as Record<string, Object> | undefined;
    const itemId = params?.['itemId'] as string;
    if (itemId) {
      await this.loadItemDetail(itemId);
    } else {
      this.showError('物品ID无效');
    }
  }

  build() {
    Column() {
      Column() {
        Column() {
          Text('\n').fontSize(14)
        }
        Row() {
          Text(this.item?.name || '物品详情')
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
          .height(0.5)
          .fill("#a6d5d5d5")
      }
      .width('100%')
      .backgroundColor($r('app.color.backcolor'))
      Scroll() {
        Column() {
          if (this.isLoading) {
            Text('加载中...')
              .fontSize(16)
              .margin({ top: 100 })
          } else if (!this.item) {
            Text('物品不存在')
              .fontSize(16)
              .margin({ top: 100 })
          } else {
            Image(this.item.imageUri)
              .width('95%')
              .borderRadius(8)
              .objectFit(ImageFit.Cover)
              .margin({ bottom: 12 })

            Column() {
              Text(this.item.name)
                .fontSize(24)
                .fontWeight(FontWeight.Bold)
                .margin({ bottom: 12 })

              Row() {
                Text(`价格: ¥${this.item.price}`)
                  .fontSize(18)
                  .fontColor('#FF6B6B')
                Text(`日均: ¥${this.item.dailyAveragePrice}`)
                  .fontSize(16)
                  .fontColor('#666')
                  .margin({ left: 10 })
              }
              .margin({ bottom: 12 })

              Row() {
                Image($r('app.media.calendar'))
                  .width(16)
                  .height(16)
                  .margin({ right: 3 })
                Text(`${this.calculateDays(this.item.acquireDate)}天`)
                  .fontSize(16)
                  .fontColor($r('app.color.border'))
                  .fontWeight(FontWeight.Medium)
                Text(`自${this.formatDate(this.item.acquireDate)}`)
                  .fontSize(16)
                  .fontColor('#999')
                  .margin({ left: 10 })
              }
              .margin({ bottom: 12 })

              Text(`分类: ${this.item.category}`)
                .fontSize(16)
                .fontColor('#666')

              Row() {
                Button('编辑')
                  .width('48%')
                  .height(44)
                  .backgroundColor($r('app.color.border'))
                  .margin({ top: 20 })
                  .onClick((): void => this.editItem())

                Button('删除')
                  .width('48%')
                  .height(44)
                  .backgroundColor($r('app.color.price'))
                  .margin({ top: 20, left: '4%' })
                  .onClick((): void => this.showDeleteDialog())
              }
            }
            .padding({
              top: 20,
              bottom: 20,
              left: 16,
              right: 16
            })
          }
        }
        .backgroundColor($r('app.color.background'))
        .borderRadius(12)
        .borderWidth(1)
        .padding(12)
        .borderColor($r('app.color.border'))
        .width('95%')
        .margin({ top: 10, bottom: 20 })
      }
      .width('100%')
      .layoutWeight(1)
      .align(Alignment.Top)
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.backcolor'))
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
  }

  private async loadItemDetail(itemId: string) {
    this.isLoading = true;
    try {
      const items = await this.itemViewModel.getAllItems();
      this.item = items.find(item => item.id === itemId) || null;
    } catch (error) {
      console.error('加载物品详情失败:', error);
      this.showError('加载失败，请重试');
    } finally {
      this.isLoading = false;
    }
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

  private editItem() {
    if (this.item) {
      AlertDialog.show({
        title: '提示',
        message: '编辑功能暂未实现',
        confirm: {
          value: '确定',
          action: () => {}
        }
      });
    }
  }

  private showDeleteDialog() {
    if (this.item) {
      AlertDialog.show({
        title: '删除物品',
        message: `确定要删除"${this.item.name}"吗？`,
        confirm: {
          value: '删除',
          action: (): void => {
            this.deleteItem();
          },
          fontColor: '#FF4D4F'
        },
        cancel: () => {
          // 取消操作
        }
      });
    }
  }

  private async deleteItem() {
    if (this.item) {
      try {
        await this.itemViewModel.deleteItem(this.item.id);
        AlertDialog.show({
          title: '成功',
          message: '物品已删除',
          confirm: {
            value: '确定',
            action: () => {
              router.back();
            }
          }
        });
      } catch (error) {
        console.error('删除物品失败:', error);
        this.showError('删除失败，请重试');
      }
    }
  }

  private showError(message: string) {
    AlertDialog.show({
      title: '错误',
      message: message,
      confirm: {
        value: '确定',
        action: () => {
          router.back();
        }
      }
    });
  }
}
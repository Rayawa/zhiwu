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
  private readonly NAV_HEIGHT: number = 85;
  @State scrollY: number = 0;

  async aboutToAppear() {
    // 正确获取路由参数
    const params = router.getParams() as Record<string, Object> | undefined;
    const itemId = params?.['itemId'] as string;
    if (itemId) {
      await this.loadItemDetail(itemId);
    } else {
      this.showError('物品ID无效');
    }
  }

  build() {
    Stack(){
      Column() {
        Column()
          .width('100%')
          .height(Math.max(this.NAV_HEIGHT - this.scrollY, 0))
        if (this.isLoading) {
          Text('加载中...')
            .fontSize(16)
            .margin({ top: 100 })
        } else if (!this.item) {
          Text('物品不存在')
            .fontSize(16)
            .margin({ top: 100 })
        } else {
          // 物品图片
          Image(this.item.imageUri)
            .width('95%')
            .height(300)
            .objectFit(ImageFit.Cover)

          // 物品信息
          Column() {
            Text(this.item.name)
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 20 })

            Row() {
              Text(`价格: ¥${this.item.price}`)
                .fontSize(18)
                .fontColor('#FF6B6B')

              Text(`日均: ¥${this.item.dailyAveragePrice}`)
                .fontSize(16)
                .fontColor('#666')
                .margin({ left: 10 })
            }
            .margin({ top: 16 })

            Row() {
              Text(`分类: ${this.item.category}`)
                .fontSize(16)
                .fontColor('#666')

              Text(`获取时间: ${this.formatDate(this.item.acquireDate)}`)
                .fontSize(16)
                .fontColor('#666')
                .margin({ left: 10 })
            }
            .margin({ top: 12 })

            // 操作按钮
            Row() {
              Button('编辑')
                .width('48%')
                .height(44)
                .backgroundColor('#007AFF')
                .margin({ top: 40 })
                .onClick((): void => this.editItem())

              Button('删除')
                .width('48%')
                .height(44)
                .backgroundColor('#FF4D4F')
                .margin({ top: 40, left: '4%' })
                .onClick((): void => this.showDeleteDialog())
            }
          }
          .padding({ top: 20, bottom: 20 })
          .padding({ left: 16, right: 16 })
        }

      }
      .width('95%')

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
              .onClick(() => router.pushUrl({ url: 'pages/user' }))
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

  private formatDate(date: Date): string {
    return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
  }

  private editItem() {
    if (this.item) {
      // 使用正确的 AlertDialog API
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
        // 删除成功提示
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
// 主页面，展示物品列表（WaterFlow 版本）
import { ItemViewModel } from '../viewmodel/ItemViewModel';
import { Item } from '../model/ItemModel';
import { ItemCard } from './components/ItemCard';
import router from '@ohos.router';

class ItemDataSource implements IDataSource {
  private data: Item[] = []
  private listener?: DataChangeListener

  totalCount(): number {
    return this.data.length
  }

  getData(index: number): Item {
    return this.data[index]
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    this.listener = listener
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    this.listener = undefined
  }

  pushData(items: Item[]): void {
    this.data = items
    this.listener?.onDataReloaded()
  }
}

@Entry
@Component
export struct MainPage {
  private itemViewModel: ItemViewModel = new ItemViewModel();
  private dataSource: ItemDataSource = new ItemDataSource();
  @State items: Item[] = [];
  @State isLoading: boolean = true;

  async aboutToAppear() {
    await this.loadItems();
  }
  async onPageShow() {
    await this.loadItems();
  }

  build() {
    Stack() {
      Column() {
        if (this.isLoading) {
          LoadingProgress()
            .width(50)
            .height(50)
            .color(Color.Blue)
            .margin({ top: 100 })
        } else if (this.items.length === 0) {
          Column() {
            Image($r('app.media.noItem'))
              .width(250)
              .height(250)
              .margin({ top:40, bottom: 20 })
            Text('还没有添加任何物品')
              .fontSize(20)
              .fontColor('#999')
          }
          .width('100%')
          .height('100%')
        } else {
          WaterFlow() {
            LazyForEach(this.dataSource, (item: Item) => {
              FlowItem() {
                ItemCard({
                  item: item,
                  onItemClick: () => {this.navigateToDetail(item);},
                  onDeleteClick: () => {this.deleteItem(item.id);}
                })
              }
              .width('100%')
              .borderRadius(12)
            }, (item: Item) => item.id)
          }
          .cachedCount(3)
          .columnsTemplate('1fr 1fr')
          .columnsGap(6)
          .rowsGap(6)
          .padding({
            left: 10,
            right: 10,
            top: 10,
            bottom: 80
          })
          .onScrollFrameBegin((offset: number) => {
            if (offset < -100) {
              this.loadItems();
            }
            return { offsetRemain: offset };
          })
        }
        Button() {
          Image($r('app.media.addItem'))
            .width(24)
            .height(24)
        }
        .type(ButtonType.Circle)
        .backgroundColor($r('app.color.button'))
        .width(50)
        .height(50)
        .shadow({
          radius: 4,
          color: '#182431',
          offsetX: 2,
          offsetY: 4
        })
        .stateEffect(true)
        .position({ x: 20, y: '90%' })
        .zIndex(999)
        .hitTestBehavior(HitTestMode.Transparent)
        .onClick((): void => this.navigateToAdd())
      }
      .width('100%')
      .margin({ bottom: 10 })

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
              .onClick(() => router.pushUrl({ url: 'view/Statistic' }))

            Image($r('app.media.user'))
              .height(24).width(24)
              .margin({ right: 30 })
              .onClick(() => router.pushUrl({ url: 'view/user' }))
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

  private async loadItems() {
    this.isLoading = true;
    this.items = await this.itemViewModel.getAllItems();
    this.dataSource.pushData(this.items);
    this.isLoading = false;
  }

  private navigateToAdd() {
    router.push({ url: 'view/AddItemPage' });
  }

  private navigateToDetail(item: Item) {
    router.push({
      url: 'view/ItemDetailPage',
      params: { itemId: item.id }
    });
  }

  private async deleteItem(itemId: string) {
    await this.itemViewModel.deleteItem(itemId);
    await this.loadItems();
  }
}

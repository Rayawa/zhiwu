// 主页面，展示物品列表
import { ItemViewModel } from '../viewmodel/ItemViewModel';
import { Item } from '../model/ItemModel';
import { ItemCard } from './components/ItemCard';
import router from '@ohos.router';

// 数据源实现
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

  build() {
    Column() {
      if (this.isLoading) {
        LoadingProgress()
          .width(50)
          .height(50)
          .color(Color.Blue)
          .margin({ top: 100 })
      } else if (this.items.length === 0) {
        Column() {
          Image($r('app.media.noitem'))
            .width(200)
            .height(200)
            .margin({ bottom: 20 })

          Text('还没有添加任何物品')
            .fontSize(16)
            .fontColor('#999')
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      } else {
        Scroll() {
          // 使用 Grid 组件替代 WaterFlow
          Grid() {
            ForEach(this.items, (item: Item) => {
              GridItem() {
                ItemCard({
                  item: item,
                  onItemClick: (item: Item): void => this.navigateToDetail(item),
                  onDeleteClick: (itemId: string): Promise<void> => this.deleteItem(itemId)
                })
              }
              .width('100%')
            }, (item: Item) => item.id)
          }
          .columnsTemplate('1fr 1fr')
          .columnsGap(10)
          .rowsGap(10)
          .padding({ left: 10, right: 10, top: 10, bottom: 80 })
        }
        .onScrollFrameBegin((offset: number, state: ScrollState) => {
          // 手动实现下拉刷新
          if (offset < -100 && state === ScrollState.Scroll) {
            this.loadItems();
          }
          // 必须返回这个对象
          return { offsetRemain: offset };
        })
      }

      Button() {
        Image($r('app.media.add'))
          .width(24)
          .height(24)
          .colorBlend(Color.White)
      }
      .width(56)
      .height(56)
      .backgroundColor('#007AFF')
      .borderRadius(28)
      .position({ x: '50%', y: '95%' })
      .margin({ left: -28 })
      .shadow({ radius: 4, color: '#00000033', offsetX: 0, offsetY: 2 })
      .onClick((): void => this.navigateToAdd())
    }
    .width('100%')
  }

  private async loadItems() {
    this.isLoading = true;
    this.items = await this.itemViewModel.getAllItems();
    this.dataSource.pushData(this.items);
    this.isLoading = false;
  }

  private navigateToAdd() {
    router.push({
      url: 'view/AddItemPage'
    });
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
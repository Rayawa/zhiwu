import { ItemViewModel } from '../viewmodel/ItemViewModel';
import { Item } from '../model/ItemModel';
import { ItemCard } from './components/ItemCard';
import { ListCard } from './components/ListCard'
import router from '@ohos.router';
import { prompt } from '@kit.ArkUI';

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
  @State columnMode: number = 3;
  @State columnsTemplateWidth: string = '1fr 1fr 1fr';
  private hasTriggered: boolean = false;
  @State WaterFlow: boolean = true;

  async aboutToAppear() {
    await this.loadItems();
  }
  async onPageShow() {
    await this.loadItems();
  }

  build() {
    Column() {
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
          .height(0.8)
          .fill("#a6d5d5d5")
      }
      .width('100%')
      .backgroundColor($r('app.color.backcolor'))
      Scroll() {
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
            if (this.WaterFlow) {
              WaterFlow() {
                LazyForEach(this.dataSource, (item: Item) => {
                  FlowItem() {
                    ItemCard({
                      item: item,
                      onItemClick: () => {
                        this.navigateToDetail(item);
                      },
                      onDeleteClick: () => {
                        this.deleteItem(item.id);
                      }
                    })
                  }
                  .width('100%')
                  .borderRadius(12)
                }, (item: Item) => item.id)
              }
              .cachedCount(3)
              .columnsTemplate(this.columnsTemplateWidth)
              .columnsGap(6)
              .rowsGap(6)
            } else {
              List({ space: 12 }) {
                LazyForEach(this.dataSource, (item: Item) => {
                  ListItem() {
                    ListCard({
                      item: item,
                      onItemClick: () => {
                        this.navigateToDetail(item);
                      },
                      onDeleteClick: () => {
                        this.deleteItem(item.id);
                      }
                    })
                  }
                  .borderRadius(12)
                }, (item: Item) => item.id)
              }
              .width('100%')
              .layoutWeight(1) // 占据剩余空间
              .cachedCount(3)
            }
          }
        }
        .gesture(
          PinchGesture({ fingers: 2 })
            .onActionStart(() => {
              this.hasTriggered = false;
            })
            .onActionUpdate((event: GestureEvent) => {
              if (this.hasTriggered) {
                return;
              }

              if (event.scale > 1.2) {
                this.handlePinchIn();
                this.hasTriggered = true;
              } else if (event.scale < 0.8) {
                this.handlePinchOut();
                this.hasTriggered = true;
              }
            })
            .onActionEnd(() => {
              this.hasTriggered = false;
            })
        )
        .backgroundColor($r('app.color.backcolor'))
        .width('95%')
        .margin({ top: 10, bottom: 20 })
      }
      .width('100%')
      .layoutWeight(1)
      .align(Alignment.Top)
      Button() {
        Image($r('app.media.addItem'))
          .width(24)
          .height(24)
      }
      .type(ButtonType.Circle)
      .backgroundColor($r('app.color.button'))
      .width(50)
      .height(50)
      .shadow({ radius: 4, color: '#182431', offsetX: 2, offsetY: 4 })
      .stateEffect(true)
      .zIndex(999)
      .margin({ bottom: 12 })
      .hitTestBehavior(HitTestMode.Transparent)
      .onClick((): void => this.navigateToAdd())
      .position({ x: 20, y: '90%' })

    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.backcolor'))
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
  }

  private handlePinchOut() {
    if (this.columnMode < 4) {
      this.columnMode++;
      this.updateColumnsTemplate();
    } else {
      prompt.showToast({
        message: '不能再缩小了',
        duration: 500
      });
    }
  }

  private handlePinchIn() {
    if (this.columnMode > 2) {
      this.columnMode--;
      this.updateColumnsTemplate();
    } else {
      prompt.showToast({
        message: '不能再放大了',
        duration: 500
      });
    }
  }

  private updateColumnsTemplate() {
    let columnText = '';
    switch (this.columnMode) {
      case 2:
        this.columnsTemplateWidth = '1fr 1fr';
        columnText = '两列';
        break;
      case 3:
        this.columnsTemplateWidth = '1fr 1fr 1fr';
        columnText = '三列';
        break;
      case 4:
        this.columnsTemplateWidth = '1fr 1fr 1fr 1fr';
        columnText = '四列';
        break;
    }

    prompt.showToast({
      message: `列数切换为${columnText}`,
      duration: 500
    });
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
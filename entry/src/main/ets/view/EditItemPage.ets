import { Item } from '../model/ItemModel';
import { ItemCategory } from '../model/ItemModel';
import { StorageUtil } from '../utils/StorageUtil';
import router from '@ohos.router';
import type { BusinessError } from '@kit.BasicServicesKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { prompt } from '@kit.ArkUI';

@Entry
@Component
export struct EditItemPage {
  private categories: string[] = Object.values(ItemCategory);

  @State itemId: string = '';

  // 物品字段
  @State name: string = '';
  @State price: string = '';
  @State selectedDate: Date = new Date();
  @State selectedCategory: string = this.categories[0];
  @State imageUri: string = '';
  @State selectedImage: ResourceStr = '';
  @State backBlur: boolean = false;

  @State isSubmitting: boolean = false;

  async aboutToAppear() {
    const params = router.getParams() as Record<string, Object> | undefined;

    if (!params?.['itemId']) {
      prompt.showToast({ message: '物品 ID 无效', duration: 1000 });
      router.back();
      return;
    }

    this.itemId = params['itemId'] as string;

    // 加载旧数据
    const items: Item[] = await StorageUtil.getItems();
    const item = items.find(i => i.id === this.itemId);

    if (!item) {
      prompt.showToast({ message: '物品不存在', duration: 1000 });
      router.back();
      return;
    }

    // 预填数据
    this.name = item.name;
    this.price = String(item.price);
    this.selectedDate = item.acquireDate;
    this.selectedCategory = item.category;
    this.imageUri = item.imageUri;
    this.selectedImage = item.imageUri;

    if (this.selectedImage && this.selectedImage.length > 0) {
      this.backBlur = true;
    }
  }

  build() {
    Column() {
      // 顶部标题栏
      Column() {
        Column() {
          Text('\n').fontSize(14)
        }
        Row() {
          Text('编辑物品')
            .fontSize(21)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 15 })

          Row() {
            Image($r('app.media.back'))
              .height(24).width(24)
              .margin({ right: 30 })
              .onClick(() => router.back())

            Image($r('app.media.add'))
              .height(24).width(24)
              .margin({ right: 30 })
              .onClick(() => this.saveItem())
          }
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .height(45)

        Rect()
          .width('100%')
          .height(0.8)
          .fill($r('app.color.border'))
      }
      .width('100%')
      .backgroundColor($r('app.color.backcolor'))

      // 内容 Scroll
      Scroll() {
        Column() {
          // 图片
          Column() {
            Text('物品图片')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 8 })

            Stack({ alignContent: Alignment.Bottom }) {
              Image(this.selectedImage)
                .objectFit(ImageFit.Contain)
                .borderRadius($r('sys.float.corner_radius_level5'))
                .height(150)
                .padding(2)
                .width('100%')
                .borderWidth(1)
                .borderColor($r('app.color.border'))

              Button('选择图片')
                .buttonStyle(ButtonStyleMode.NORMAL)
                .backgroundBlurStyle(
                  this.backBlur ? BlurStyle.BACKGROUND_THICK : BlurStyle.NONE,
                  { colorMode: ThemeColorMode.SYSTEM, adaptiveColor: AdaptiveColor.DEFAULT, scale: 1.0 }
                )
                .fontColor(this.backBlur ? $r('sys.color.font_on_primary') : $r('app.color.border'))
                .height(40)
                .fontWeight(FontWeight.Medium)
                .fontSize($r('sys.float.Body_L'))
                .margin({ bottom: 36 })
                .onClick(() => this.selectImage())
            }
          }
          .backgroundColor($r('app.color.backcolor'))
          .borderRadius($r('sys.float.corner_radius_level5'))
          .padding(12)
          .margin({ bottom:20 })

          // 名称
          Column() {
            Text('物品名称')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 8 })
            TextInput({ placeholder: '请输入物品名称', text: this.name })
              .height('44vp')
              .borderRadius(8)
              .padding({ left: 12, right: 12 })
              .onChange((v: string) => { this.name = v; })
          }
          .backgroundColor($r('app.color.backcolor'))
          .borderRadius($r('sys.float.corner_radius_level5'))
          .padding(12)
          .margin({ bottom:20 })

          // 价格
          Column() {
            Text('物品价格')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom:8 })
            TextInput({ placeholder: '请输入物品价格', text: this.price })
              .height('44vp')
              .borderRadius(8)
              .padding({ left: 12, right: 12 })
              .type(InputType.Number)
              .onChange((v: string) => { this.price = v; })
          }
          .backgroundColor($r('app.color.backcolor'))
          .borderRadius($r('sys.float.corner_radius_level5'))
          .padding(12)
          .margin({ bottom:20 })

          // 日期 —— 修复点：校验 year/month/day 是否存在
          Column() {
            Text('获取时间')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom:8 })
            DatePicker({
              start: new Date('1975-01-01'),
              end: new Date(),
              selected: this.selectedDate
            })
              .width('100%')
              .borderRadius(8)
              .onChange((v: DatePickerResult) => {
                if (v && typeof v.year === 'number' && typeof v.month === 'number' && typeof v.day === 'number') {
                  this.selectedDate = new Date(v.year, v.month - 1, v.day);
                } else {
                  console.warn('DatePicker returned incomplete value, ignore update.', v);
                }
              })
          }
          .backgroundColor($r('app.color.backcolor'))
          .borderRadius($r('sys.float.corner_radius_level5'))
          .padding(12)
          .margin({ bottom:20 })

          Column() {
            Text('物品分类')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom:8 })

            Select(this.getCategoryOptions())
              .width('100%')
              .value(this.selectedCategory)
              .onSelect((index: number) => {
                if (typeof index === 'number' && index >= 0 && index < this.categories.length) {
                  this.selectedCategory = this.categories[index];
                }
              })

          }
          .backgroundColor($r('app.color.backcolor'))
          .borderRadius($r('sys.float.corner_radius_level5'))
          .padding(12)
          .margin({ bottom:20 })

          // 保存按钮
          Button(this.isSubmitting ? '保存中...' : '保存修改')
            .width('100%')
            .height('48vp')
            .backgroundColor($r('app.color.border'))
            .fontColor(Color.White)
            .fontSize(16)
            .margin({ bottom:20 })
            .enabled(!this.isSubmitting)
            .onClick(() => this.saveItem())
        }
        .width('95%')
        .backgroundColor($r('app.color.backcolor'))
        .borderRadius(12)
        .margin({ top: 10, bottom: 20 })
      }
      .layoutWeight(1)
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.backcolor'))
  }

  private selectImage(): void {
    try {
      const opt = new photoAccessHelper.PhotoSelectOptions();
      opt.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
      opt.maxSelectNumber = 1;

      const picker = new photoAccessHelper.PhotoViewPicker();
      picker.select(opt)
        .then((res: photoAccessHelper.PhotoSelectResult) => {
          if (Array.isArray(res.photoUris) && res.photoUris.length > 0) {
            this.imageUri = res.photoUris[0];
            this.selectedImage = this.imageUri;
            this.backBlur = true;
          }
        })
        .catch((err: BusinessError) => {
          console.error('Photo select failed:', err);
        });
    } catch (error) {
      const err = error as BusinessError;
      console.error('Photo error:', err);
    }
  }

  private async saveItem(): Promise<void> {
    if (!this.name.trim()) {
      prompt.showToast({ message: '请输入名称', duration: 800 });
      return;
    }
    if (!this.price.trim() || isNaN(Number(this.price))) {
      prompt.showToast({ message: '请输入有效价格', duration: 800 });
      return;
    }

    this.isSubmitting = true;

    const updated: Item = {
      id: this.itemId,
      name: this.name.trim(),
      price: Number(this.price),
      category: this.selectedCategory,
      imageUri: this.imageUri,
      acquireDate: this.selectedDate,
      description: '',
      dailyAveragePrice: this.calcDailyAverage(Number(this.price), this.selectedDate)
    };

    try {
      await StorageUtil.updateItem(updated);
      prompt.showToast({ message: '已保存修改', duration: 1000 });

      setTimeout(() => router.back(), 500);
    } catch (e) {
      console.error('更新失败:', e);
      prompt.showToast({ message: '更新失败', duration: 1000 });
      this.isSubmitting = false;
    }
  }
  private getCategoryOptions(): SelectOption[] {
    return this.categories.map((c: string) => ({ value: c } as SelectOption));
  }


  private calcDailyAverage(price: number, date: Date): number {
    const days = Math.max(1, Math.ceil((Date.now() - date.getTime()) / 86400000));
    return Number((price / days).toFixed(2));
  }
}

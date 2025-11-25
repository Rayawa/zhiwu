// 添加物品页面
import { ItemViewModel, ItemInput } from '../viewmodel/ItemViewModel';
import { ItemCategory } from '../model/ItemModel';
import router from '@ohos.router';
import type { BusinessError } from '@kit.BasicServicesKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
@Entry
@Component
export struct AddItemPage {
  private itemViewModel: ItemViewModel = new ItemViewModel();
  private categories: string[] = Object.values(ItemCategory);

  @State name: string = '';
  @State price: string = '';
  @State selectedDate: Date = new Date();
  @State selectedCategory: string = this.categories[0];
  @State imageUri: string = '';
  @State imgDatas: string[] = [];
  @State selectedImage: ResourceStr = '';
  @State backBlur: boolean = false;
  @State isSubmitting: boolean = false;
  private readonly NAV_HEIGHT: number = 85;
  @State scrollY: number = 0;

  // 将分类转换为 SelectOption 数组
  private getCategoryOptions(): SelectOption[] {
    const options: SelectOption[] = [];
    for (let i = 0; i < this.categories.length; i++) {
      options.push({ value: this.categories[i] });
    }
    return options;
  }

  build() {
    Stack(){
      Scroll(){
        Column() {
          // 顶层占位
          Column()
            .width('100%')
            .height(Math.max(this.NAV_HEIGHT - this.scrollY, 0))
          // 图片选择
          Column(){
            Text('物品图片')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 8 })
            Stack({ alignContent: Alignment.Bottom }) {
              Image(this.selectedImage)
                .objectFit(ImageFit.Contain)
                .borderRadius($r('sys.float.corner_radius_level5'))
                .height(150)
                .width('100%')
                .borderWidth(1)
                .borderColor($r('app.color.border'))

              Button('选择图片')
                .buttonStyle(ButtonStyleMode.NORMAL)
                .backgroundBlurStyle(this.backBlur ? BlurStyle.BACKGROUND_THICK : BlurStyle.NONE,
                  {
                    colorMode: ThemeColorMode.SYSTEM,
                    adaptiveColor: AdaptiveColor.DEFAULT,
                    scale: 1.0
                  })
                .fontColor(this.backBlur ? $r('sys.color.font_on_primary') : $r('app.color.border'))
                .height(40)
                .fontWeight(FontWeight.Medium)
                .fontSize($r('sys.float.Body_L'))
                .margin({ bottom: 36 })
                .onClick(() => {
                  try {
                    const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
                    photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
                    photoSelectOptions.maxSelectNumber = 1;
                    const photoPicker = new photoAccessHelper.PhotoViewPicker();
                    photoPicker.select(photoSelectOptions)
                      .then((photoSelectResult: photoAccessHelper.PhotoSelectResult) => {
                        this.imgDatas = photoSelectResult.photoUris;
                        this.imageUri = this.imgDatas[0];
                        this.selectedImage = this.imgDatas[0];
                        if (this.selectedImage.length > 0) {
                          this.backBlur = true;
                        }
                        console.info(`PhotoViewPicker.select successfully, PhotoSelectResult uri: ${photoSelectResult.photoUris[0]}`);

                      })
                      .catch((err: BusinessError) => {
                        console.info(`PhotoViewPicker.select failed with err: ${err.code}, ${err.message}`);
                      });
                  } catch (error) {
                    const err: BusinessError = error as BusinessError;
                    console.error(`PhotoViewPicker failed with err: ${err.code}, ${err.message}`);
                  }
                })
            }
          }
          .backgroundColor($r('app.color.background'))
          .borderRadius($r('sys.float.corner_radius_level5'))
          .padding(12)
          .margin({bottom:20})

          // 物品名称
          Column() {
            Text('物品名称')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 8 })

            TextInput({ placeholder: '请输入物品名称' })
              .height('44vp')
              .borderRadius(8)
              .padding({ left: 12, right: 12 })
              .onChange((value: string) => {
                this.name = value;
              })
          }
          .backgroundColor($r('app.color.background'))
          .borderRadius($r('sys.float.corner_radius_level5'))
          .padding(12)
          .margin({bottom:20})

          // 物品价格
          Column() {
            Text('物品价格')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .margin({bottom:8})

            TextInput({ placeholder: '请输入物品价格' })
              .height('44vp')
              .borderRadius(8)
              .padding({ left: 12, right: 12 })
              .type(InputType.Number)
              .onChange((value: string) => {
                this.price = value;
              })
          }
          .backgroundColor($r('app.color.background'))
          .borderRadius($r('sys.float.corner_radius_level5'))
          .padding(12)
          .margin({bottom:20})

          // 获取时间
          Column() {
            Text('获取时间')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 8 })

            DatePicker({
              start: new Date('1975-01-01'),
              end: new Date(),
              selected: this.selectedDate
            })
              .width('100%')
              .borderRadius(8)
              .onChange((value: DatePickerResult) => {
                if (value.year !== undefined && value.month !== undefined && value.day !== undefined) {
                  this.selectedDate = new Date(value.year, value.month - 1, value.day);
                }
              })
          }
          .backgroundColor($r('app.color.background'))
          .borderRadius($r('sys.float.corner_radius_level5'))
          .padding(12)
          .margin({bottom:20})

          // 物品分类
          Column() {
            Text('物品分类')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 8 })

            Select(this.getCategoryOptions())
              .width('100%')
              .value(this.selectedCategory)
              .onSelect((index: number) => {
                if (index >= 0 && index < this.categories.length) {
                  this.selectedCategory = this.categories[index];
                }
              })
          }
          .backgroundColor($r('app.color.background'))
          .borderRadius($r('sys.float.corner_radius_level5'))
          .padding(12)
          .margin({bottom:20})

          // 保存按钮
          Button(this.isSubmitting ? '保存中...' : '保存')
            .width('100%')
            .height('48vp')
            .backgroundColor($r('app.color.border'))
            .fontColor(Color.White)
            .fontSize(16)
            .margin({bottom:20})
            .onClick(() => {
              this.saveItem();
            })
            .enabled(!this.isSubmitting)
        }
        .padding({ left: 20, right: 20 })
        .margin({bottom:20})
      }
      Column() {
        Column() {
          Text('\n').fontSize(14)
        }
        Row() {
          Text('添加物品')
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
              .onClick(() => {
                this.saveItem();
              })
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

  // 保存物品
  private async saveItem() {
    // 表单验证
    if (!this.name.trim()) {
      this.showAlertDialog('提示', '请输入物品名称');
      return;
    }

    if (!this.price.trim() || isNaN(Number(this.price)) || Number(this.price) <= 0) {
      this.showAlertDialog('提示', '请输入有效的价格');
      return;
    }

    this.isSubmitting = true;

    try {
      // 创建符合 ItemInput 接口的明确类型对象
      const itemInput: ItemInput = {
        name: this.name.trim(),
        price: Number(this.price),
        acquireDate: this.selectedDate,
        category: this.selectedCategory,
        imageUri: this.imageUri
      };

      await this.itemViewModel.addItem(itemInput);

      // 保存成功，返回主页面
      this.showAlertDialog('成功', '物品添加成功', () => {
        router.back();
      });
    } catch (error) {
      console.error('保存物品失败:', error);
      this.showAlertDialog('错误', '保存失败，请重试');
      this.isSubmitting = false;
    }
  }

  // 显示弹窗
  private showAlertDialog(title: string, message: string, callback?: () => void) {
    AlertDialog.show({
      title: title,
      message: message,
      confirm: {
        value: '确定',
        action: () => {
          if (callback) {
            callback();
          }
        }
      }
    });
  }
}
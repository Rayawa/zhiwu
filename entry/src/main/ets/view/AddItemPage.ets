// 添加物品页面
import { ItemViewModel, ItemInput } from '../viewmodel/ItemViewModel';
import { ItemCategory } from '../model/ItemModel';
import router from '@ohos.router';
import { BusinessError } from '@ohos.base';
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
  @State isSubmitting: boolean = false;

  // 将分类转换为 SelectOption 数组
  private getCategoryOptions(): SelectOption[] {
    const options: SelectOption[] = [];
    for (let i = 0; i < this.categories.length; i++) {
      options.push({ value: this.categories[i] });
    }
    return options;
  }

  build() {
    Scroll() {
      Column() {
        // 图片选择区域
        Column() {
          if (this.imageUri) {
            Image(this.imageUri)
              .width('100%')
              .height('200vp')
              .objectFit(ImageFit.Cover)
              .borderRadius(8)
          } else {
            Column() {
              Text('点击上传图片')
                .fontSize(16)
                .fontColor('#999')
            }
            .width('100%')
            .height('200vp')
            .backgroundColor('#F0F0F0')
            .borderRadius(8)
            .justifyContent(FlexAlign.Center)
          }

          Button('选择图片')
            .width('100%')
            .height('44vp')
            .backgroundColor('#007AFF')
            .margin({ top: 10 })
            .onClick(() => this.selectImage())
        }
        .padding({ left: 20, right: 20, top: 20 })

        // 表单区域
        Column() {
          // 物品名称
          Column() {
            Text('物品名称')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 8 })

            TextInput({ placeholder: '请输入物品名称' })
              .width('100%')
              .height('44vp')
              .backgroundColor('#F5F5F5')
              .borderRadius(8)
              .padding({ left: 12, right: 12 })
              .onChange((value: string) => {
                this.name = value;
              })
          }
          .margin({ bottom: 20, top: 20 })

          // 物品价格
          Column() {
            Text('物品价格')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 8 })

            TextInput({ placeholder: '请输入物品价格' })
              .width('100%')
              .height('44vp')
              .backgroundColor('#F5F5F5')
              .borderRadius(8)
              .padding({ left: 12, right: 12 })
              .type(InputType.Number)
              .onChange((value: string) => {
                this.price = value;
              })
          }
          .margin({ bottom: 20, top: 20 })

          // 获取时间
          Column() {
            Text('获取时间')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 8 })

            DatePicker({
              start: new Date('2000-01-01'),
              end: new Date(),
              selected: this.selectedDate
            })
              .width('100%')
              .onChange((value: DatePickerResult) => {
                if (value.year !== undefined && value.month !== undefined && value.day !== undefined) {
                  this.selectedDate = new Date(value.year, value.month - 1, value.day);
                }
              })
          }
          .margin({ bottom: 20, top: 20 })

          // 物品分类 - 使用正确的 SelectOption 类型
          Column() {
            Text('物品分类')
              .fontSize(14)
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
          .margin({ bottom: 20, top: 20 })

          // 保存按钮
          Button(this.isSubmitting ? '保存中...' : '保存')
            .width('100%')
            .height('48vp')
            .backgroundColor('#007AFF')
            .fontColor(Color.White)
            .fontSize(16)
            .margin({ top: 40, bottom: 40 })
            .onClick(() => {
              this.saveItem();
            })
            .enabled(!this.isSubmitting)
        }
        .padding({ left: 20, right: 20 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }

  // 选择图片
  private async selectImage() {
    try {
      console.info('选择图片功能');
      // 模拟选择图片
      this.imageUri = 'file://media/thumbnail/sample_image';
    } catch (error) {
      const err = error as BusinessError<object>;
      console.error(`选择图片失败: ${err.code}, ${err.message}`);
      this.showAlertDialog('错误', '选择图片失败，请重试');
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

    if (!this.imageUri) {
      this.showAlertDialog('提示', '请上传物品图片');
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
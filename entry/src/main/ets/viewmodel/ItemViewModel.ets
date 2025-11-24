// 物品视图模型，处理业务逻辑
import { Item, ItemCategory } from '../model/ItemModel';
import { StorageUtil } from '../utils/StorageUtil';

export interface ItemInput {
  name: string;
  price: number;
  category: string;
  imageUri: string;
  acquireDate: Date;
  description?: string;
}

export class ItemViewModel {
  private items: Item[] = [];
  private itemCategories: string[] = Object.values(ItemCategory);

  // 获取所有物品
  public async getAllItems(): Promise<Item[]> {
    this.items = await StorageUtil.getItems();
    // 计算每个物品的日均价格 - 不使用展开运算符
    const updatedItems: Item[] = [];
    for (let i = 0; i < this.items.length; i++) {
      const item = this.items[i];
      const updatedItem: Item = {
        id: item.id,
        name: item.name,
        price: item.price,
        category: item.category,
        imageUri: item.imageUri,
        acquireDate: item.acquireDate,
        description: item.description,
        dailyAveragePrice: this.calculateDailyAveragePrice(item.price, item.acquireDate)
      };
      updatedItems.push(updatedItem);
    }
    this.items = updatedItems;
    return this.items;
  }

  // 添加物品 - 使用 ItemInput 接口而不是 Omit
  public async addItem(itemInput: ItemInput): Promise<Item> {
    const newItem: Item = {
      id: this.generateId(),
      name: itemInput.name,
      price: itemInput.price,
      category: itemInput.category,
      imageUri: itemInput.imageUri,
      acquireDate: itemInput.acquireDate,
      description: itemInput.description,
      dailyAveragePrice: this.calculateDailyAveragePrice(itemInput.price, itemInput.acquireDate)
    };
    await StorageUtil.addItem(newItem);
    this.items.push(newItem);
    return newItem;
  }

  // 更新物品
  public async updateItem(updatedItem: Item): Promise<void> {
    // 创建新的物品对象，而不是修改原对象
    const itemToUpdate: Item = {
      id: updatedItem.id,
      name: updatedItem.name,
      price: updatedItem.price,
      category: updatedItem.category,
      imageUri: updatedItem.imageUri,
      acquireDate: updatedItem.acquireDate,
      description: updatedItem.description,
      dailyAveragePrice: this.calculateDailyAveragePrice(updatedItem.price, updatedItem.acquireDate)
    };

    await StorageUtil.updateItem(itemToUpdate);
    const index = this.items.findIndex(item => item.id === updatedItem.id);
    if (index !== -1) {
      this.items[index] = itemToUpdate;
    }
  }

  // 删除物品
  public async deleteItem(itemId: string): Promise<void> {
    await StorageUtil.deleteItem(itemId);
    this.items = this.items.filter(item => item.id !== itemId);
  }

  // 根据分类筛选物品
  public async getItemsByCategory(category: string): Promise<Item[]> {
    const allItems = await this.getAllItems();
    const filteredItems: Item[] = [];
    for (let i = 0; i < allItems.length; i++) {
      if (allItems[i].category === category) {
        filteredItems.push(allItems[i]);
      }
    }
    return filteredItems;
  }

  // 搜索物品
  public async searchItems(keyword: string): Promise<Item[]> {
    const allItems = await this.getAllItems();
    const searchResults: Item[] = [];
    const lowerKeyword = keyword.toLowerCase();

    for (let i = 0; i < allItems.length; i++) {
      const item = allItems[i];
      if (item.name.toLowerCase().includes(lowerKeyword) ||
        (item.description && item.description.toLowerCase().includes(lowerKeyword))) {
        searchResults.push(item);
      }
    }
    return searchResults;
  }

  // 获取所有分类
  public getCategories(): string[] {
    return this.itemCategories;
  }

  // 计算日均价格
  private calculateDailyAveragePrice(price: number, acquireDate: Date): number {
    const now = new Date();
    const diffTime = Math.abs(now.getTime() - acquireDate.getTime());
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    return diffDays > 0 ? parseFloat((price / diffDays).toFixed(2)) : price;
  }

  // 生成唯一ID
  private generateId(): string {
    return Date.now().toString(36) + Math.random().toString(36).substring(2, 11);
  }
}
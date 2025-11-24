// 存储工具类，用于处理数据持久化
import dataPreferences from '@ohos.data.preferences';
import { Item } from '../model/ItemModel';
import { BusinessError } from '@ohos.base';

const STORAGE_KEY: string = 'items';
const PREFERENCES_NAME: string = 'item_manager_preferences';

// 定义序列化用的物品接口（避免Date类型）
interface SerializableItem {
  id: string;
  name: string;
  price: number;
  category: string;
  imageUri: string;
  acquireDate: string; // 存储为ISO字符串
  description?: string;
  dailyAveragePrice: number;
}

// 定义 JSON 解析后的可能类型
type ParsedData = SerializableItem[] | Record<string, never> | null;

export class StorageUtil {
  private static preferences: dataPreferences.Preferences | null = null;

  // 初始化Preferences - 使用正确的Context类型
  public static async initPreferences(context: Context): Promise<void> {
    if (StorageUtil.preferences !== null) {
      return;
    }

    try {
      StorageUtil.preferences = await dataPreferences.getPreferences(context, PREFERENCES_NAME);
    } catch (error) {
      const err = error as BusinessError<object>;
      console.error('Failed to initialize preferences:' + JSON.stringify(err));
      throw new Error('Failed to initialize preferences: ' + JSON.stringify(err));
    }
  }

  // 保存物品列表
  public static async saveItems(items: Item[]): Promise<void> {
    if (StorageUtil.preferences === null) {
      throw new Error('Preferences not initialized');
    }
    try {
      // 转换为可序列化的格式
      const serializableItems: SerializableItem[] = [];
      for (let i = 0; i < items.length; i++) {
        const item = items[i];
        const serializableItem: SerializableItem = {
          id: item.id,
          name: item.name,
          price: item.price,
          category: item.category,
          imageUri: item.imageUri,
          acquireDate: item.acquireDate.toISOString(), // 转换为字符串
          description: item.description,
          dailyAveragePrice: item.dailyAveragePrice
        };
        serializableItems.push(serializableItem);
      }

      await StorageUtil.preferences.put(STORAGE_KEY, JSON.stringify(serializableItems));
      await StorageUtil.preferences.flush();
    } catch (error) {
      const err = error as BusinessError<object>;
      console.error('Failed to save items:' + JSON.stringify(err));
      throw new Error('Failed to save items: ' + JSON.stringify(err));
    }
  }

  // 获取物品列表
  public static async getItems(): Promise<Item[]> {
    if (StorageUtil.preferences === null) {
      throw new Error('Preferences not initialized');
    }
    try {
      const itemsJson: dataPreferences.ValueType = await StorageUtil.preferences.get(STORAGE_KEY, '[]');
      const itemsString: string = itemsJson.toString();

      // 为 parsedData 添加明确的类型注解
      const parsedData: ParsedData = JSON.parse(itemsString) as ParsedData;
      const serializableItems: SerializableItem[] = Array.isArray(parsedData) ? parsedData : [];

      // 转换回Item对象
      const items: Item[] = [];
      for (let i = 0; i < serializableItems.length; i++) {
        const serializableItem = serializableItems[i];
        const item: Item = {
          id: serializableItem.id,
          name: serializableItem.name,
          price: serializableItem.price,
          category: serializableItem.category,
          imageUri: serializableItem.imageUri,
          acquireDate: new Date(serializableItem.acquireDate), // 转换回Date对象
          description: serializableItem.description,
          dailyAveragePrice: serializableItem.dailyAveragePrice
        };
        items.push(item);
      }
      return items;
    } catch (error) {
      const err = error as BusinessError<object>;
      console.error('Failed to get items:' + JSON.stringify(err));
      return [];
    }
  }

  // 添加物品
  public static async addItem(item: Item): Promise<void> {
    const items = await StorageUtil.getItems();
    const newItems: Item[] = [];

    // 复制现有物品
    for (let i = 0; i < items.length; i++) {
      newItems.push(items[i]);
    }

    // 添加新物品
    newItems.push(item);
    await StorageUtil.saveItems(newItems);
  }

  // 更新物品
  public static async updateItem(updatedItem: Item): Promise<void> {
    const items = await StorageUtil.getItems();
    const newItems: Item[] = [];
    let found: boolean = false;

    for (let i = 0; i < items.length; i++) {
      const item = items[i];
      if (item.id === updatedItem.id) {
        newItems.push(updatedItem);
        found = true;
      } else {
        newItems.push(item);
      }
    }

    if (found) {
      await StorageUtil.saveItems(newItems);
    } else {
      throw new Error('Item with id ' + updatedItem.id + ' not found');
    }
  }

  // 删除物品
  public static async deleteItem(itemId: string): Promise<void> {
    const items = await StorageUtil.getItems();
    const newItems: Item[] = [];

    for (let i = 0; i < items.length; i++) {
      const item = items[i];
      if (item.id !== itemId) {
        newItems.push(item);
      }
    }

    await StorageUtil.saveItems(newItems);
  }

  // 清空所有数据（用于测试或重置）
  public static async clearAll(): Promise<void> {
    if (StorageUtil.preferences === null) {
      throw new Error('Preferences not initialized');
    }
    try {
      await StorageUtil.preferences.delete(STORAGE_KEY);
      await StorageUtil.preferences.flush();
    } catch (error) {
      const err = error as BusinessError<object>;
      console.error('Failed to clear data:' + JSON.stringify(err));
      throw new Error('Failed to clear data: ' + JSON.stringify(err));
    }
  }

  // 检查是否已初始化
  public static isInitialized(): boolean {
    return StorageUtil.preferences !== null;
  }
}
export interface Item {
  id: string;
  name: string;
  price: number;
  category: string;
  imageUri: string;
  acquireDate: Date;
  description?: string;
  dailyAveragePrice: number;
}

export enum ItemCategory {
  DEFAULT = '默认',
  ELECTRONICS = '电子数码',
  HOME_APPLIANCES = '家电设备',
  PERSONAL_ITEMS = '个人用品',
  TRANSPORTATION = '交通出行',
  HOME_LIVING = '居家生活',
  ENTERTAINMENT = '文娱爱好',
  WORK_TOOLS = '工作工具',
  OTHER = '其他'
}
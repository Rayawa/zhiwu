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
  ELECTRONICS = '电子产品',
  CLOTHING = '服装',
  BOOKS = '图书',
  FURNITURE = '家具',
  SPORTS = '运动用品',
  OTHER = '其他'
}
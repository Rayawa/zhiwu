import { TopNavBar } from '../components/TopNavBar'

@Entry
@Component
struct Index {
  build() {
    Stack() {
      Column() {
        Text('111')

      }
      TopNavBar()
    }
    .width('100%')
    .height('100%')
  }
}

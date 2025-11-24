import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { StorageUtil } from '../utils/StorageUtil';
import { BusinessError } from '@ohos.base';

const DOMAIN = 0x0000;
const TAG = 'EntryAbility';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      const error = err as BusinessError<object>;
      hilog.error(DOMAIN, TAG, 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(error));
    }
    hilog.info(DOMAIN, TAG, 'Ability onCreate');

    StorageUtil.initPreferences(this.context)
      .then(() => {
        hilog.info(DOMAIN, TAG, 'StorageUtil initialized successfully');
      })
      .catch((err: BusinessError<object>) => {
        hilog.error(DOMAIN, TAG, 'Failed to initialize StorageUtil: %{public}s', JSON.stringify(err));
      });
  }

  onDestroy(): void {
    hilog.info(DOMAIN, TAG, 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, TAG, 'Ability onWindowStageCreate');

    // 设置全局沉浸式效果
    this.setGlobalImmersive(windowStage);

    // 使用 Promise 方式的 loadContent
    windowStage.loadContent('view/MainPage')
      .then(() => {
        hilog.info(DOMAIN, TAG, 'Succeeded in loading the content.');
      })
      .catch((err: BusinessError<object>) => {
        hilog.error(DOMAIN, TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
      });
  }

  // 设置全局沉浸式效果
  async setGlobalImmersive(windowStage: window.WindowStage): Promise<void> {
    try {
      // 获取窗口对象
      const windowClass = await windowStage.getMainWindow();

      // 设置窗口全屏布局
      await windowClass.setWindowLayoutFullScreen(true);

      // 设置系统栏可见性（状态栏和导航栏）
      await windowClass.setWindowSystemBarEnable(['status', 'navigation']);

      // 设置系统栏属性 - 完全透明
      const systemBarProperties: window.SystemBarProperties = {
        statusBarColor: '#00000000', // 完全透明
        navigationBarColor: '#00000000', // 完全透明
        statusBarContentColor: '#FFffffff', // 状态栏图标和文字颜色（白色）
        navigationBarContentColor: '#FFffffff' // 导航栏图标颜色（白色）
      };
      await windowClass.setWindowSystemBarProperties(systemBarProperties);

      // 设置窗口背景色延伸至系统栏下方
      const barIconProperties: window.SystemBarProperties = {
        isStatusBarLightIcon: true, // 状态栏浅色图标
        isNavigationBarLightIcon: true // 导航栏浅色图标
      };
      await windowClass.setWindowSystemBarProperties(barIconProperties);

      hilog.info(DOMAIN, TAG, 'Global immersive mode set successfully');

      // 处理摄像头挖孔区域的安全区域
      await this.setCutoutMode(windowStage);

    } catch (err) {
      const error = err as BusinessError<object>;
      hilog.error(DOMAIN, TAG, 'Failed to set global immersive mode. Cause: %{public}s', JSON.stringify(error));
    }
  }

  // 处理摄像头挖孔区域的安全区域
  async setCutoutMode(windowStage: window.WindowStage): Promise<void> {
    try {
      const windowClass = await windowStage.getMainWindow();

      // 设置布局延伸到摄像头挖孔区域
      await windowClass.setWindowLayoutFullScreen(true);

      // 获取安全区域信息
      const avoidArea = await windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      hilog.info(DOMAIN, TAG, 'Avoid area: %{public}s', JSON.stringify(avoidArea));

      // 设置内容延伸到挖孔区域，但通过padding避免内容被遮挡
      await windowClass.setFullScreen(true);

    } catch (err) {
      const error = err as BusinessError<object>;
      hilog.error(DOMAIN, TAG, 'Failed to set cutout mode. Cause: %{public}s', JSON.stringify(error));
    }
  }

  onWindowStageDestroy(): void {
    hilog.info(DOMAIN, TAG, 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    hilog.info(DOMAIN, TAG, 'Ability onForeground');

    // 应用回到前台时重新设置沉浸式
    this.resetImmersiveMode();
  }

  onBackground(): void {
    hilog.info(DOMAIN, TAG, 'Ability onBackground');
  }

  // 重置沉浸式模式
  async resetImmersiveMode(): Promise<void> {
    try {
      const windowClass = await window.getLastWindow(this.context);
      if (windowClass) {
        const systemBarProperties: window.SystemBarProperties = {
          statusBarColor: '#00000000',
          navigationBarColor: '#00000000',
          statusBarContentColor: '#FFffffff',
          navigationBarContentColor: '#FFffffff'
        };
        await windowClass.setWindowSystemBarProperties(systemBarProperties);
      }
    } catch (err) {
      const error = err as BusinessError<object>;
      hilog.error(DOMAIN, TAG, 'Failed to reset immersive mode. Cause: %{public}s', JSON.stringify(error));
    }
  }
}
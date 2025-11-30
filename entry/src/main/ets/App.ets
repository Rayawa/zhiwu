import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import hilog from '@ohos.hilog';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@ohos.base';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'EntryAbility', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'EntryAbility', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(0x0000, 'EntryAbility', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/MainPage')
      .then(() => {
        hilog.info(0x0000, 'EntryAbility', 'Succeeded in loading the content');
      })
      .catch((err: BusinessError) => {
        hilog.error(0x0000, 'EntryAbility', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
      });
  }

  onWindowStageDestroy(): void {
    hilog.info(0x0000, 'EntryAbility', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    hilog.info(0x0000, 'EntryAbility', 'Ability onForeground');
  }

  onBackground(): void {
    hilog.info(0x0000, 'EntryAbility', 'Ability onBackground');
  }
}
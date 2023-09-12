# Plugin for React Native
Official Jumio Mobile SDK plugin for React Native

This plugin is compatible with version 4.6.0 of the Jumio Android SDK and 4.6.1 of the Jumio iOS SDK.    
If you have questions, please reach out to your Account Manager or contact [Jumio Support](#support).

# Table of Contents
- [Compatibility](#compatibility)
- [Setup](#setup)
- [Integration](#integration)
  - [iOS](#ios)
  - [Android](#ios)
    - [Proguard](#proguard)
- [Usage](#usage)
  - [Retrieving Information](#retrieving-information)
- [Customization](#customization)
- [Callbacks](#callbacks)
- [FAQ](#faq)
   - [iOS Runs on Debug, Crashes on Release Build](#ios-runs-on-debug-crashes-on-release-build)
   - [Using iOS Dynamic Frameworks with React Native Sample App](#using-ios-dynamic-frameworks-with-react-native-sample-app)
   - [iOS Build Fails for React 0.71.2](#ios-build-fails-for-react-0712)
   - [iOS Localization](#ios-localization)
   - [iProov String Keys](#iproov-string-keys)
- [Support](#support)

## Compatibility
We only ensure compatibility with a minimum React Native version of 0.72.4

## Setup
Create React Native project and add the Jumio Mobile SDK module to it.

```sh
react-native init MyProject
cd MyProject
npm install --save https://github.com/Jumio/mobile-react.git#v4.6.1
cd ios && pod install
```

## Integration

### iOS
1. Add the "**NSCameraUsageDescription**"-key to your Info.plist file.
2. Your app's deployment target must be at least iOS 11.0

#### Device Risk
To include Jumio's Device Risk functionality, you need to add `pod Jumio/DeviceRisk` to your Podfile.

### Android
__AndroidManifest__    
Open your AndroidManifest.xml file and change `allowBackup` to false. 
```xml
<application
...
android:allowBackup="false">
</application>
```

Make sure your compileSdkVersion and buildToolsVersion are high enough.

```groovy
android {
  compileSdkVersion 33
  buildToolsVersion "33.0.0"
  ...
}
```

__Enable MultiDex__    
Follow the Android developers guide: https://developer.android.com/studio/build/multidex.html

```groovy
android {
  ...
  defaultConfig {
    ...
    multiDexEnabled true
  }
}
```

__Upgrade Gradle build tools__    
The plugin requires at least version 4.0.0 of the Android build tools. This transitively requires and upgrade of the Gradle wrapper to version 7 and an update to Java 11.

Upgrade build tools version to 7.2.0 in android/build.gradle:

```groovy
buildscript {
  ...
  dependencies {
    ...
    classpath 'com.android.tools.build:gradle:7.2.0'
  }
}
```

Modify the Gradle Wrapper version in android/gradle.properties.

__Repository__    
Add the Jumio Mobile SDK repository:

```groovy
exclusiveContent {
  forRepository {
    maven {
      url 'https://repo.mobile.jumio.ai'
    }
  }
  filter {
    includeGroup "com.jumio.android"
    includeGroup "com.iproov.sdk"
  }
}
```

#### Proguard 
For information on Android Proguard Rules concerning the Jumio SDK, please refer to our [Android guides](https://github.com/Jumio/mobile-sdk-android#proguard).

## Usage

1. Add __"NativeModules"__ to the import of 'react-native'.

```javascript
import {
  ...
  NativeModules
} from 'react-native';
```

2. Create a variable of your iOS module:

```javascript
const { JumioMobileSDK } = NativeModules;
```

3. The SDKs can be initialized with the following calls.

```javascript
JumioMobileSDK.initialize(<AUTHORIZATION_TOKEN>, <DATACENTER>);
```

Datacenter can either be **US**, **EU** or **SG**.

As soon as the SDK is initialized, the SDK is started by the following call.

```javascript
  JumioMobileSDK.start();
```

Optionally, it is possible to check whether a device is rooted / jailbroken with the following method:
```javascript
  const isRooted = await JumioMobileSDK.isRooted();
```

### Retrieving information

You can listen to events to retrieve the scanned data:

* `EventResult` for Jumio results.
* `EventError` for Jumio error.

First add `NativeEventEmitter` to the import from 'react-native' and listen to the events.

```javascript
import {
...
NativeEventEmitter
} from 'react-native';
```

The event receives a JSON object with all the data.
The example below shows how to retrieve the information of each emitter as a String:

```javascript
const emitterJumio = new NativeEventEmitter(JumioMobileSDK);
emitterJumio.addListener(
    'EventResult',
    (EventResult) => console.warn("EventResult: " + JSON.stringify(EventResult))
);
emitterJumio.addListener(
    'EventError',
    (EventError) => console.warn("EventError: " + JSON.stringify(EventError))
);
```

## Customization
### Android
JumioSDK Android appearance can be customized by overriding the custom theme `AppThemeCustomJumio`. A customization example of all values can be found in the [`styles.xml`](DemoApp/android/app/src/main/res/values/styles.xml) of the DemoApp.

### iOS
JumioSDK iOS appearance can be customized to your respective needs. You can customize each color based on the device's set appearance, for either Dark mode or Light mode, or you can set a single color for both appearances. Customization is optional and not required.

You can pass the following customization options to the [`setupCustomizations()`](DemoApp/index.js#L30) function:

| Customization key                               |
|:------------------------------------------------|
| iProovAnimationForeground                       |
| iProovAnimationBackground                       |
| iProovFilterForegroundColor                     |
| iProovFilterBackgroundColor                     |
| iProovTitleTextColor                            |
| iProovCloseButtonTintColor                      |
| iProovSurroundColor                             |
| iProovPromptTextColor                           |
| iProovPromptBackgroundColor                     |
| genuinePresenceAssuranceReadyOvalStrokeColor    |
| genuinePresenceAssuranceNotReadyOvalStrokeColor |
| livenessAssuranceOvalStrokeColor                |
| livenessAssuranceCompletedOvalStrokeColor       |
| primaryButtonBackground                         |
| primaryButtonBackgroundPressed                  |
| primaryButtonBackgroundDisabled                 |
| primaryButtonText                               |
| secondaryButtonBackground                       |
| secondaryButtonBackgroundPressed                |
| secondaryButtonBackgroundDisabled               |
| secondaryButtonText                             |
| bubbleBackground                                |
| bubbleForeground                                |
| bubbleBackgroundSelected                        |
| bubbleCircleItemForeground                      |
| bubbleCircleItemBackground                      |
| bubbleSelectionIconForeground                   |
| loadingCirclePlain                              |
| loadingCircleGradientStart                      |
| loadingCircleGradientEnd                        |
| loadingErrorCircleGradientStart                 |
| loadingErrorCircleGradientEnd                   |
| loadingCircleIcon                               |
| scanOverlay                                     |
| scanOverlayFill                                 |
| scanOverlayTransparent                          |
| scanOverlayBackground                           |
| nfcPassportCover                                |
| nfcPassportPageDark                             |
| nfcPassportPageLight                            |
| nfcPassportForeground                           |
| nfcPhoneCover                                   |
| scanViewBubbleForeground                        |
| scanViewBubbleBackground                        |
| scanViewForeground                              |
| scanViewAnimationShutter                        |
| searchBubbleBackground                          |
| searchBubbleForeground                          |
| searchBubbleListItemSelected                    |
| confirmationImageBackground                     |
| confirmationImageBackgroundBorder               |
| confirmationIndicatorActive                     |
| confirmationIndicatorDefault                    |
| background                                      |
| navigationIconColor                             |
| textForegroundColor                             |
| primaryColor                                    |

All colors are provided with a HEX string in the following formats: `#ff00ff` or `#66ff00ff` if you want to set the alpha level.

**Customization example**

Example for setting color based on Dark or Light mode:
```
JumioMobileSDK.setupCustomizations({
    primaryColor: { light:"ffffff", dark:"000000" }
    primaryButtonBackground: { light:ffffff, dark:"000000" }
});
```

Example for setting same color for both Dark and Light mode:
```
JumioMobileSDK.setupCustomizations({
    primaryColor: "ffffff"
    primaryButtonBackground: "ffffff"
});
```

## Callbacks
In oder to get information about result fields, Retrieval API, Delete API, global settings and more, please read our [page with server related information](https://github.com/Jumio/implementation-guides/blob/master/api-guide/api_guide.md#callback).

## Result Objects
The JSON object with all the extracted data that is returned for the specific products is described in the following subchapters:

### EventResult

| Parameter            | Type     | Max. length | Description                                                                                                |
|:---------------------|:---------|:------------|:-----------------------------------------------------------------------------------------------------------|
| selectedCountry      | String   | 3           | [ISO 3166-1 alpha-3](http://en.wikipedia.org/wiki/ISO_3166-1_alpha-3) country code as provided or selected |
| selectedDocumentType | String   | 16          | PASSPORT, DRIVER_LICENSE, IDENTITY_CARD or VISA                                                            |
| idNumber             | String   | 100         | Identification number of the document                                                                      |
| personalNumber       | String   | 14          | Personal number of the document                                                                            |
| issuingDate          | Date     |             | Date of issue                                                                                              |
| expiryDate           | Date     |             | Date of expiry                                                                                             |
| issuingCountry       | String   | 3           | Country of issue as ([ISO 3166-1 alpha-3](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3)) country code  |
| lastName             | String   | 100         | Last name of the customer                                                                                  |
| firstName            | String   | 100         | First name of the customer                                                                                 |
| dob                  | Date     |             | Date of birth                                                                                              |
| gender               | String   | 1           | m, f or x                                                                                                  |
| originatingCountry   | String   | 3           | Country of origin as ([ISO 3166-1 alpha-3](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3)) country code |
| addressLine          | String   | 64          | Street name                                                                                                |
| city                 | String   | 64          | City                                                                                                       |
| subdivision          | String   | 3           | Last three characters of [ISO 3166-2:US](http://en.wikipedia.org/wiki/ISO_3166-2:US) state code            |
| postCode             | String   | 15          | Postal code                                                                                                |
| mrzData              | MRZ-DATA |             | MRZ data, see table below                                                                                  |
| optionalData1        | String   | 50          | Optional field of MRZ line 1                                                                               |
| optionalData2        | String   | 50          | Optional field of MRZ line 2                                                                               |
| placeOfBirth         | String   | 255         | Place of Birth                                                                                             |

### MRZ-Data

| Parameter           | Type   | Max. length | Description                                                                    |
|:--------------------|:-------|:------------|:-------------------------------------------------------------------------------|
| format              | String | 8           | MRP, TD1, TD2, CNIS, MRVA, MRVB or UNKNOWN                                     |
| line1               | String | 50          | MRZ line 1                                                                     |
| line2               | String | 50          | MRZ line 2                                                                     |
| line3               | String | 50          | MRZ line 3                                                                     |
| idNumberValid       | BOOL   |             | True if ID number check digit is valid, otherwise false                        |
| dobValid            | BOOL   |             | True if date of birth check digit is valid, otherwise false                    |
| expiryDateValid     | BOOL   |             | True if date of expiry check digit is valid or not available, otherwise false  |
| personalNumberValid | BOOL   |             | True if personal number check digit is valid or not available, otherwise false |
| compositeValid      | BOOL   |             | True if composite check digit is valid, otherwise false                        |


## Local Models for JumioDocfinder

If you are using our JumioDocFinder module, you can download our encrypted models and add them to your bundle from [here](https://cdn.mobile.jumio.ai/model/classifier_on_device_ep_99_float16_quant.enc) and [here](https://cdn.mobile.jumio.ai/model/normalized_ensemble_passports_v2_float16_quant.enc).

We recommend to download the files and add them to your project without changing their names (the same way you add Localization files). This will save two network requests on runtime to download these files.

### iOS

You also need to copy those files to the "ios/Assets" folder for React to recognize them.

### Android

You need to copy those files to the assets folder of your Android project (Path: "app/src/main/assets/")


## FAQ

### iOS Simulator shows a white-screen, when the Jumio SDK is started
The Jumio SDK does not support the iOS Simulator. Please run the Jumio SDK only on physical devices.

### iOS Runs on Debug, Crashes on Release Build
This happens due to Xcode 13 introducing a new option to their __App Store Distribution Options__:

__"Manage Version and Build Number"__ (see image below)

If checked, this option changes the version and build number of all content of your app to the overall application version, including third-party frameworks. __This option is enabled by default.__ Please make sure to disable this option when archiving / exporting your application to the App Store. Otherwise, the Jumio SDK version check, which ensures all bundled frameworks are up to date, will fail.

![Xcode13 Issue](images/known_issues_xcode13.png)

Alternatively, it is also possible to set the key `manageAppVersionAndBuildNumber` in the __exportOptions.plist__ to `false`:
```
<key>manageAppVersionAndBuildNumber</key>
<false/>
```

### Using iOS Dynamic Frameworks with React Native Sample App
Jumio SDK version 3.8.0 and newer use iProov dependencies that need need to be built as dynamic frameworks.
Since React Native supports only static libraries, a pre-install hook has been added to ensure that pods added as `dynamic_frameworks` are actually built as dynamic frameworks, while all other pods are built as static libraries.

```
dynamic_frameworks = ['Socket.IO-Client-Swift', 'Starscream', 'iProov']
pre_install do |installer|
  installer.pod_targets.each do |pod|
    if !dynamic_frameworks.include?(pod.name)
      puts "Overriding the static_framework? method for #{pod.name}"
      def pod.static_framework?;
        true
      end
      def pod.build_type;
        Pod::BuildType.static_library
      end
    end
  end
end
```

Additionally, a post install hook needs to be added to the Podfile to ensure dependencies are build for distribution:
```
post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      end
    end
end
```

Please refer to the iOS section of our [DemoApp guide](DemoApp/README.md#iOS) for additional details.

### iOS Build Fails for React 0.71.2
`use_frameworks!` needs to be included in the `Podfile` and properly executed in order for Jumio dynamic frameworks to install correctly.
Make sure [the necessary `pre_install` and `post_install` hooks](#using-dynamic-frameworks-with-react-native-sample-app) have been included.
Also make sure that [Flipper](https://fbflipper.com/) is disabled for your project, since Flipper is not compatible with iOS dynamic frameworks at the moment.

Please also refer to the [Podfile](DemoApp/ios/Podfile) of our sample application for further details.

### iOS Localization
After installing Cocoapods, please localize your iOS application using the languages provided at the following path:   
`ios -> Pods -> Jumio -> Localizations -> xx.lproj`

![Localization](images/RN_localization.gif)

### iProov String Keys
Please note that as of 3.8.0. the following keys have been added to the SDK:

* `"IProov_IntroFlash"`
* `"IProov_IntroLa"`
* `"IProov_PromptLivenessAlignFace"`
* `"IProov_PromptLivenessNoTarget"`
* `"IProov_PromptLivenessScanCompleted"`
* `"IProov_PromptTooClose"`
* `"IProov_PromptTooFar"`

Make sure your `Podfile` is up to date and that new pod versions are installed properly so your `Localizable` files include new strings.
For more information, please refer to our [Changelog](https://github.com/Jumio/mobile-sdk-ios/blob/master/docs/changelog) and [Transition Guide](https://github.com/Jumio/mobile-sdk-ios/blob/master/docs/transition-guide_id-verification-fastfill.md#3.8.0).

# Support

## Contact
If you have any questions regarding our implementation guide please contact Jumio Customer Service at support@jumio.com or https://support.jumio.com. The Jumio online helpdesk contains a wealth of information regarding our service including demo videos, product descriptions, FAQs and other things that may help to get you started with Jumio. Check it out at: https://support.jumio.com.

## Licenses
The software contains third-party open source software. For more information, please see [Android licenses](https://github.com/Jumio/mobile-sdk-android/tree/master/licenses) and [iOS licenses](https://github.com/Jumio/mobile-sdk-ios/tree/master/licenses)

This software is based in part on the work of the Independent JPEG Group.

## Copyright
&copy; Jumio Corp. 268 Lambert Avenue, Palo Alto, CA 94306

The source code and software available on this website (“Software”) is provided by Jumio Corp. or its affiliated group companies (“Jumio”) "as is” and any express or implied warranties, including, but not limited to, the implied warranties of merchantability and fitness for a particular purpose are disclaimed. In no event shall Jumio be liable for any direct, indirect, incidental, special, exemplary, or consequential damages (including but not limited to procurement of substitute goods or services, loss of use, data, profits, or business interruption) however caused and on any theory of liability, whether in contract, strict liability, or tort (including negligence or otherwise) arising in any way out of the use of this Software, even if advised of the possibility of such damage.
In any case, your use of this Software is subject to the terms and conditions that apply to your contractual relationship with Jumio. As regards Jumio’s privacy practices, please see our privacy notice available here: [Privacy Policy](https://www.jumio.com/legal-information/privacy-policy/).

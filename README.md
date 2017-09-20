# Plugin for React Native

Official Jumio Mobile SDK plugin for React Native

## Compatibility

With every release, we only ensure compatibility with the latest version of React Native.

## Setup

Create React Native project and add the Jumio Mobile SDK module to it.
```
react-native init MyProject 
cd MyProject
npm install --save https://github.com/Jumio/mobile-react.git#v2.8.0
react-native link react-native-jumio-mobilesdk
```

## Integration

### iOS

1. Add the Jumio Mobile SDK to your React Native iOS project. Manual integration or dependency management via cocoapods possible, please see [the official documentation of the Jumio Mobile SDK for iOS](https://github.com/Jumio/mobile-sdk-ios/tree/v2.8.0#basic-setup)
2. Now open the workspace and copy the iOS module (**node_modules/react-native-jumio-mobilesdk/ios/JumioMobileSDK**) into the project.
3. Add the "**NSCameraUsageDescription**"-key to your Info.plist file.

### Android

1. Open your AndroidManifest.xml file and change allowBackup to false.
```javascript
<application
    ...
    android:allowBackup="false"
    ...
</application>
```

2. Make sure your compileSdkVersion and buildToolsVersion are high enough.
```javascript
android {
    compileSdkVersion 25
    buildToolsVersion "25.0.3"
    ...
}
```

3. Enable MultiDex
```javascript
android {
    ...
    defaultConfig {
        ...
        multiDexEnabled true
    }
}
```

4. Add the Jumio Mobile SDK repository
```javascript
repositories {  
    maven { url 'http://mobile-sdk.jumio.com' }
}
```

5. Change the extend of your MainActivity to JumioActivity
```javascript
public class MainActivity extends JumioActivity {
```

## Usage

1. Add "**NativeModules**" to the import of 'react-native'.
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

3. Initialize the SDK with the following call.
```javascript
JumioMobileSDK.initNetverify(<API_TOKEN>, <API_SECRET>, <DATACENTER>, {configuration});
JumioMobileSDK.initDocumentVerification(<API_TOKEN>, <API_SECRET>, <DATACENTER>, {configuration});
JumioMobileSDK.initBAM(<API_TOKEN>, <API_SECRET>, <DATACENTER>, {configuration});
```
Datacenter can either be **us** or **eu**.

To get information about the different configuration options, please see the [usage chapter](https://github.com/Jumio/mobile-cordova/blob/master/README.md#usage) of our Cordova plugin.

### Offline scanning

In your Jumio merchant backend on the "Settings" page under "API credentials" you can find your Offline token.

**iOS**

Pass your offline token to your configuration object of BAM Checkout.

```javascript
offlineToken: "TOKEN",
```

### Android Netverify eMRTD

Use `enableEMRTD` to read the NFC chip of an eMRTD.
```javascript
JumioMobileSDK.enableEMRTD();
```

**If BAM Credit Card + ID is used, init BAM and Netverify**

4. Afterwards start the SDK with the following command.
```javascript
JumioMobileSDK.startNetverify();
JumioMobileSDK.startDocumentVerification();
JumioMobileSDK.startBAM();
```

5. Now you can listen to events to retrieve the scanned data:
* **EventDocumentData** for Netverify results.
* **EventCardInformation** for BAM results.
* **EventDocumentVerification** for Document Verification results.
* **EventError** for every error.

6. First add **NativeEventEmitter** for iOS and **DeviceEventEmitter** for android to the import from 'react-native' and listen to the events.

**iOS**
```javascript
import {
    ...
    NativeEventEmitter
} from 'react-native';
```

The event receives a json object with all the data.

```javascript
const emitter = new NativeEventEmitter(JumioMobileSDK);
emitter.addListener(
    'EventDocumentData|EventCardInformation|EventDocumentVerification|EventError',
    (reminder) => alert(JSON.stringify(reminder))
);
```

**Android**
```javascript
import {
    ...
    DeviceEventEmitter
} from 'react-native';
```

The event receives a json string with all the data.

```javascript
DeviceEventEmitter.addListener('EventDocumentData|EventCardInformation|EventDocumentVerification|EventError', function(e: Event) {
    alert(e)
});
```

## Customization

### Android

The Netverify SDK can be customized to the respective needs by following this [customization chapter](https://github.com/Jumio/mobile-sdk-android/blob/v2.8.0/docs/integration_netverify-fastfill.md#customization).

### iOS

The SDK can be customized to the respective needs by using the following initializers instead.
```javascript
JumioMobileSDK.initNetverifyWithCustomization(<API_TOKEN>, <API_SECRET>, <DATACENTER>, {configuration}, {customization});
JumioMobileSDK.initDocumentVerificationWithCustomization(<API_TOKEN>, <API_SECRET>, <DATACENTER>, {configuration}, {customization});
JumioMobileSDK.initBAMWithCustomization(<API_TOKEN>, <API_SECRET>, <DATACENTER>, {configuration}, {customization});
```

You can find all the different customization options by following the [customization chapter](https://github.com/Jumio/mobile-cordova/blob/master/README.md#ios-1) of our Cordova plugin.

## Callbacks

To get information about callbacks, please see the [callback chapter](https://github.com/Jumio/mobile-cordova/blob/master/README.md#callback) of our Cordova plugin.


# Support

## Contact

If you have any questions regarding our implementation guide please contact Jumio Customer Service at support@jumio.com or https://support.jumio.com. The Jumio online helpdesk contains a wealth of information regarding our service including demo videos, product descriptions, FAQs and other things that may help to get you started with Jumio. Check it out at: https://support.jumio.com.

## Copyright

&copy; Jumio Corp. 268 Lambert Avenue, Palo Alto, CA 94306





# Plugin for React Native

Official Jumio Mobile SDK plugin for React Native

## Compatibility

We only ensure compatibility with a minimum React Native version of 0.55.2

## Setup

Create React Native project and add the Jumio Mobile SDK module to it.
```
react-native init MyProject
cd MyProject
npm install --save https://github.com/Jumio/mobile-react.git#v2.11.0
react-native link react-native-jumio-mobilesdk
```

## Integration

### iOS

1. Add the Jumio Mobile SDK to your React Native iOS project by either doing manual integration or using dependency management via cocoapods , please see [the official documentation of the Jumio Mobile SDK for iOS](https://github.com/Jumio/mobile-sdk-ios/tree/v2.11.0#basic-setup)
2. Open the Xcode workspace (/YourApp/ios/YourApp.xcworkspace) and add the module files according to your desired product (see /YourApp/node_modules/react-native-jumio-mobilesdk/ios/) into the app project.
  * Example: For Fastfill/Netverify add `JumioMobileSDKNetverify.h` and `JumioMobileSDKNetverify.m` to the project
3. Add the "**NSCameraUsageDescription**"-key to your Info.plist file.

### Android

1. Open your AndroidManifest.xml file and change allowBackup to false.
```
<application
    ...
    android:allowBackup="false"
    ...
</application>
```

2. Make sure your compileSdkVersion and buildToolsVersion are high enough.
```
android {
    compileSdkVersion 27
    buildToolsVersion "27.0.3"
    ...
}
```

3. Enable MultiDex
Follow the Android developers guide: https://developer.android.com/studio/build/multidex.html

```
android {
    ...
    defaultConfig {
        ...
        multiDexEnabled true
    }
}
```

4. Add the Jumio Mobile SDK repository
```
repositories {  
    maven { url 'http://mobile-sdk.jumio.com' }
}
```

5. Change the extend of your MainActivity to JumioActivity
```
import com.jumio.react.JumioActivity;

public class MainActivity extends JumioActivity {
```

## Usage

1. Add "**NativeModules**" to the import of 'react-native'.
```
import {
    ...
    NativeModules
} from 'react-native';
```

2. Create a variable of your iOS module:
```
const { JumioMobileSDKNetverify } = NativeModules;
const { JumioMobileSDKBamCheckout } = NativeModules;
const { JumioMobileSDKDocumentVerification } = NativeModules;
```

3. Initialize the SDK with the following call.
```
JumioMobileSDKNetverify.initNetverify(<API_TOKEN>, <API_SECRET>, <DATACENTER>, {configuration});
JumioMobileSDKDocumentVerification.initDocumentVerification(<API_TOKEN>, <API_SECRET>, <DATACENTER>, {configuration});
JumioMobileSDKBamCheckout.initBAM(<API_TOKEN>, <API_SECRET>, <DATACENTER>, {configuration});
```
Datacenter can either be **us** or **eu**.

To get information about the different configuration options, please see the [usage chapter](https://github.com/Jumio/mobile-cordova/blob/master/README.md#usage) of our Cordova plugin.

### Offline scanning

If you want to use Fastfill in offline mode please contact Jumio Customer Service at support@jumio.com or https://support.jumio.com. Once this feature is enabled for your account, you can find your offline token in your Jumio customer portal on the "Settings" page under "API credentials".

**iOS**

Pass your offline token to your configuration object of BAM Checkout.

```
offlineToken: "TOKEN",
```

**Android**

Offline scanning not supported yet.

### Android Netverify eMRTD

Use `enableEMRTD` to read the NFC chip of an eMRTD.
```
JumioMobileSDKNetverify.enableEMRTD();
```

**If BAM Credit Card + ID is used, init BAM and Netverify**

4. Afterwards start the SDK with the following command.
```javascript
JumioMobileSDKNetverify.startNetverify();
JumioMobileSDKDocumentVerification.startDocumentVerification();
JumioMobileSDKBamCheckout.startBAM();
```

5. Now you can listen to events to retrieve the scanned data:
* **EventDocumentData** for Netverify results.
* **EventCardInformation** for BAM results.
* **EventDocumentVerification** for Document Verification results.
* **EventError** for every error.

6. First add **NativeEventEmitter** to the import from 'react-native' and listen to the events.

```
import {
    ...
    NativeEventEmitter
} from 'react-native';
```

The event receives a json object with all the data.

```
const emitterNetverify = new NativeEventEmitter(JumioMobileSDKNetverify);
emitterNetverify.addListener(
    'EventDocumentData',
	(EventDocumentData) => console.warn("EventDocumentData: " + JSON.stringify(EventDocumentData))
);
emitterNetverify.addListener(
    'EventError',
    (EventError) => console.warn("EventError: " + JSON.stringify(EventError))
);

const emitterDocumentVerification = new NativeEventEmitter(JumioMobileSDKDocumentVerification)
emitterDocumentVerification.addListener(
    'EventDocumentVerification',
    (EventDocumentVerification) => console.warn("EventDocumentVerification: " + JSON.stringify(EventDocumentVerification))
);
emitterDocumentVerification.addListener(
    'EventError',
    (EventError) => console.warn("EventError: " + JSON.stringify(EventError))
);

const emitterBamCheckout = new NativeEventEmitter(JumioMobileSDKBamCheckout)
emitterBamCheckout.addListener(
    'EventCardInformation',
    (EventCardInformation) => console.warn("EventCardInformation: " + JSON.stringify(EventCardInformation))
);
emitterBamCheckout.addListener(
    'EventError',
    (EventError) => console.warn("EventError: " + JSON.stringify(EventError))
);
```

## Customization

### Android

#### Netverify
The Netverify SDK can be customized to the respective needs by following this [customization chapter](https://github.com/Jumio/mobile-sdk-android/blob/v2.11.0/docs/integration_netverify-fastfill.md#customization).

#### BAM Checkout
The Netverify SDK can be customized to the respective needs by following this [customization chapter](https://github.com/Jumio/mobile-sdk-android/blob/v2.11.0/docs/integration_bam-checkout.md#customization).

#### Document Verification
The Netverify SDK can be customized to the respective needs by following this [customization chapter](https://github.com/Jumio/mobile-sdk-android/blob/v2.11.0/docs/integration_document-verification.md#customization).


### iOS

The SDK can be customized to the respective needs by using the following initializers instead.
```javascript
JumioMobileSDKNetverify.initNetverifyWithCustomization(<API_TOKEN>, <API_SECRET>, <DATACENTER>, {configuration}, {customization});
JumioMobileSDKDocumentVerification.initDocumentVerificationWithCustomization(<API_TOKEN>, <API_SECRET>, <DATACENTER>, {configuration}, {customization});
JumioMobileSDKBamCheckout.initBAMWithCustomization(<API_TOKEN>, <API_SECRET>, <DATACENTER>, {configuration}, {customization});
```

You can find all the different customization options by following the [customization chapter](https://github.com/Jumio/mobile-cordova#ios-1) of our Cordova plugin.

## Callbacks

To get information about callbacks, please see the [callback chapter](https://github.com/Jumio/mobile-cordova/blob/master/README.md#callback) of our Cordova plugin.

# Support

## Contact

If you have any questions regarding our implementation guide please contact Jumio Customer Service at support@jumio.com or https://support.jumio.com. The Jumio online helpdesk contains a wealth of information regarding our service including demo videos, product descriptions, FAQs and other things that may help to get you started with Jumio. Check it out at: https://support.jumio.com.

# Copyright

© Jumio Corp. 268 Lambert Avenue, Palo Alto, CA 94306

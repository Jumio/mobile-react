# Plugin for React Native

Official Jumio Mobile SDK plugin for React Native

## Compatibility

We only ensure compatibility with a minimum React Native version of 0.59.4

## Setup

Create React Native project and add the Jumio Mobile SDK module to it.
```
react-native init MyProject
cd MyProject
npm install --save https://github.com/Jumio/mobile-react.git#v3.1.0
react-native link react-native-jumio-mobilesdk
```

## Integration

### iOS

1. Add the Jumio Mobile SDK to your React Native iOS project by either doing manual integration or using dependency management via cocoapods , please see [the official documentation of the Jumio Mobile SDK for iOS](https://github.com/Jumio/mobile-sdk-ios/tree/v3.1.0#basic-setup)
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
    compileSdkVersion 28
    buildToolsVersion "28.0.3"
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

6. Add Proguard rules:
[Proguard](https://developer.android.com/studio/build/shrink-code) is a tool for shrinking and obfuscating code your release application for the app store. You need to add this rules for building an Android release app in your `proguard-rules.pro` file as documented in the [Jumio Android proguard chapter](https://github.com/Jumio/mobile-sdk-android#proguard)

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
const { JumioMobileSDKAuthentication } = NativeModules;
const { JumioMobileSDKBamCheckout } = NativeModules;
const { JumioMobileSDKDocumentVerification } = NativeModules;
```

3. Initialize the SDK with the following call.
```
JumioMobileSDKNetverify.initNetverify(<API_TOKEN>, <API_SECRET>, <DATACENTER>, {configuration});
JumioMobileSDKAuthentication.initAuthentication(<API_TOKEN>, <API_SECRET>, <DATACENTER>, {configuration});
JumioMobileSDKDocumentVerification.initDocumentVerification(<API_TOKEN>, <API_SECRET>, <DATACENTER>, {configuration});
JumioMobileSDKBamCheckout.initBAM(<API_TOKEN>, <API_SECRET>, <DATACENTER>, {configuration});
```
Datacenter can either be **us** or **eu**.

## Usage

### Netverify / Fastfill

To initialize the SDK, perform the following call.

```javascript
JumioMobileSDKNetverify.initNetverify(<API_TOKEN>, <API_SECRET>, <DATACENTER>, {configuration});
```

Datacenter can either be **US** or **EU**.



Configure the SDK with the *configuration*-Object.

| Configuration | Datatype | Description |
| ------ | -------- | ----------- |
| enableVerification | Boolean | Enable ID verification |
| callbackUrl | String | Specify an URL for individual transactions |
| enableIdentityVerification | Boolean | Enable face match during the ID verification for a specific transaction |
| preselectedCountry | Boolean | Specify the issuing country (ISO 3166-1 alpha-3 country code) |
| customerInternalReference | String | Allows you to identify the scan (max. 100 characters) |
| reportingCriteria | String | Use this option to identify the scan in your reports (max. 100 characters) |
| userReference | String | Set a customer identifier (max. 100 characters) |
| sendDebugInfoToJumio | Boolean | Send debug information to Jumio. |
| dataExtractionOnMobileOnly | Boolean | Limit data extraction to be done on device only |
| cameraPosition | String | Which camera is used by default. Can be **FRONT** or **BACK**. |
| preselectedDocumentVariant | String | Which types of document variants are available. Can be **PAPER** or **PLASTIC** |
| documentTypes | String-Array | An array of accepted document types: Available document types: **PASSPORT**, **DRIVER_LICENSE**, **IDENTITY_CARD**, **VISA** |


Initialization example with configuration.

```javascript
JumioMobileSDKNetverify.initNetverify("API_TOKEN", "API_SECRET", "US", {
    enableVerification: false,
    userReference: "CUSTOMERID",
    preselectedCountry: "USA",
    cameraPosition: "BACK",
    documentTypes: ["DRIVER_LICENSE", "PASSPORT", "IDENTITY_CARD", "VISA"]
});
```

***Android eMRTD scanning***

If you are using eMRTD scanning, following lines are needed in your Manifest file:

```javascript
-keep class net.sf.scuba.smartcards.IsoDepCardService {*;}
-keep class org.jmrtd.** { *; }
-keep class net.sf.scuba.** {*;}
-keep class org.bouncycastle.** {*;}
-keep class org.ejbca.** {*;}

-dontwarn java.nio.**
-dontwarn org.codehaus.**
-dontwarn org.ejbca.**
-dontwarn org.bouncycastle.**
```

Add the needed dependencies following [this chapter](https://github.com/Jumio/mobile-sdk-android/blob/master/docs/integration_netverify-fastfill.md#dependencies) of the android integration guide.

Enable eMRTD by using the following method in your native android code:

```javascript
netverifySDK.setEnableEMRTD(true);
```


As soon as the sdk is initialized, the sdk is started by the following call.

```javascript
JumioMobileSDKNetverify.startNetverify(successCallback, errorCallback);
```

Example

```javascript
JumioMobileSDKNetverify.startNetverify(function(documentData) {
    // YOUR CODE
}, function(error) {
    // YOUR CODE
});
```

### Authentication

To initialize and start the SDK, perform the following call.
```javascript
  JumioMobileSDKAuthentication.initAuthentication(<API_TOKEN>, <API_SECRET>, <DATACENTER>, {configuration});
```

Datacenter can either be **US** or **EU**.

Configure the SDK with the *configuration*-Object. **(configuration marked with * are mandatory)**

| Configuration | Datatype | Description |
| ------ | -------- | ----------- |
| **enrollmentTransactionReference*** | String | The reference of the enrollment scan to authenticate for |
| **userReference*** | String | Set a customer identifier (max. 100 characters) |

Initialization example with configuration:
```javascript
const startAuthentication = () => {
  JumioMobileSDKAuthentication.initAuthentication('API_TOKEN', 'API_SECRET', 'US', {
	  enrollmentTransactionReference: "EnrollmentTransactionReference",
	  userReference: "UserReference"
    callbackUrl: "URL"
  });  
};
```

### Document Verification

To initialize the SDK, perform the following call.

```javascript
JumioMobileSDKDocumentVerification.initDocumentVerification(<API_TOKEN>, <API_SECRET>, <DATACENTER>, {configuration});
```

Datacenter can either be **US** or **EU**.

Configure the SDK with the *configuration*-Object. **(configuration marked with * are mandatory)**

| Configuration | Datatype | Description |
| ------ | -------- | ----------- |
| **type*** | String | See the list below |
| **userReference*** | String | Set a customer identifier (max. 100 characters) |
| **country*** | String | Set the country (ISO-3166-1 alpha-3 code) |
| **customerInternalReference*** | String | Allows you to identify the scan (max. 100 characters) |
| reportingCriteria | String | Use this option to identify the scan in your reports (max. 100 characters) |
| callbackUrl | String | Specify an URL for individual transactions |
| documentName | String | Override the document label on the help screen |
| customDocumentCode | String | Set your custom document code (set in the merchant backend under "Settings" - "Multi Documents" - "Custom" |
| cameraPosition | String | Which camera is used by default. Can be **FRONT** or **BACK**. |

Possible types:

*  BS (Bank statement)
*  IC (Insurance card)
*  UB (Utility bill, front side)
*  CAAP (Cash advance application)
*  CRC (Corporate resolution certificate)
*  CCS (Credit card statement)
*  LAG (Lease agreement)
*  LOAP (Loan application)
*  MOAP (Mortgage application)
*  TR (Tax return)
*  VT (Vehicle title)
*  VC (Voided check)
*  STUC (Student card)
*  HCC (Health care card)
*  CB (Council bill)
*  SENC (Seniors card)
*  MEDC (Medicare card)
*  BC (Birth certificate)
*  WWCC (Working with children check)
*  SS (Superannuation statement)
*  TAC (Trade association card)
*  SEL (School enrolment letter)
*  PB (Phone bill)
*  USSS (US social security card)
*  SSC (Social security card)
*  CUSTOM (Custom document type)

Initialization example with configuration.

```javascript
JumioMobileSDKDocumentVerification.initDocumentVerification("API_TOKEN", "API_SECRET", "US", {
    type: "BC",
    userReference: "CUSTOMER ID",
    country: "USA",
    customerInternalReference: "YOURSCANREFERENCE",
    cameraPosition: "BACK"
});
```

As soon as the SDK is initialized, the SDK is started by the following call.

```javascript
JumioMobileSDKDocumentVerification.startDocumentVerification(successCallback, errorCallback);
```

Example

```javascript
JumioMobileSDKDocumentVerification.startDocumentVerification(function(documentData) {
    // YOUR CODE
}, function(error) {
    // YOUR CODE
});
```

### BAM Checkout

To Initialize the SDK, perform the following call.

```javascript
JumioMobileSDKBamCheckout.initBAM(<API_TOKEN>, <API_SECRET>, <DATACENTER>, {configuration});
```
Datacenter can either be **US** or **EU**.

Configure the SDK with the *configuration*-Object.

| Configuration | Datatype | Description |
| ------ | -------- | ----------- |
| cardHolderNameRequired | Boolean |
| sortCodeAndAccountNumberRequired | Boolean |
| expiryRequired | Boolean |
| cvvRequired | Boolean |
| expiryEditable | Boolean |
| cardHolderNameEditable | Boolean |
| reportingCriteria | String | Overwrite your specified reporting criteria to identify each scan attempt in your reports (max. 100 characters)
| vibrationEffectEnabled | Boolean |
| enableFlashOnScanStart | Boolean |
| cardNumberMaskingEnabled | Boolean |
| offlineToken | String | In your Jumio merchant backend on the "Settings" page under "API credentials" you can find your Offline token. In case you use your offline token, you must not set the API token and secret|
| cameraPosition | String | Which camera is used by default. Can be **FRONT** or **BACK**. |
| cardTypes | String-Array | An array of accepted card types. Available card types: **VISA**, **MASTER_CARD**, **AMERICAN_EXPRESS**, **CHINA_UNIONPAY**, **DINERS_CLUB**, **DISCOVER**, **JCB** |

Initialization example with configuration.

```javascript
JumioMobileSDKBamCheckout.initBAM("API_TOKEN", "API_SECRET", "US", {
    cardHolderNameRequired: false,
    cvvRequired: true,
    cameraPosition: "BACK",
    cardTypes: ["VISA", "MASTER_CARD"]
});
```


As soon as the sdk is initialized, the sdk is started by the following call.

```javascript
JumioMobileSDKBamCheckout.startBAM(successCallback, errorCallback);
```

Example

```javascript
JumioMobileSDKBamCheckout.startBAM(function(cardInformation) {
    // YOUR CODE
}, function(error) {
    // YOUR CODE
});
```

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
* **EventAuthentication** for Authentication results
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

const emitterAuthentication = new NativeEventEmitter(JumioMobileSDKAuthentication);
emitterAuthentication.addListener(
    'EventAuthentication',
	(EventAuthentication) => console.warn("EventAuthentication: " + JSON.stringify(EventAuthentication))
);
emitterAuthentication.addListener(
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
The Netverify SDK can be customized to the respective needs by following this [customization chapter](https://github.com/Jumio/mobile-sdk-android/blob/v3.1.0/docs/integration_netverify-fastfill.md#customization).

#### Authentication
The Authentication SDK can be customized to the respective needs by following this [customization chapter](https://github.com/Jumio/mobile-sdk-android/blob/v3.1.0/docs/integration_authentication.md#customization).

#### BAM Checkout
The BAM Checkout SDK can be customized to the respective needs by following this [customization chapter](https://github.com/Jumio/mobile-sdk-android/blob/v3.1.0/docs/integration_bam-checkout.md#customization).

#### Document Verification
The Document Verification SDK can be customized to the respective needs by following this [customization chapter](https://github.com/Jumio/mobile-sdk-android/blob/v3.1.0/docs/integration_document-verification.md#customization).


### iOS

The SDK can be customized to the respective needs by using the following initializers instead.
```javascript
JumioMobileSDKNetverify.initNetverifyWithCustomization(<API_TOKEN>, <API_SECRET>, <DATACENTER>, {configuration}, {customization});
JumioMobileSDKDocumentVerification.initDocumentVerificationWithCustomization(<API_TOKEN>, <API_SECRET>, <DATACENTER>, {configuration}, {customization});
JumioMobileSDKBamCheckout.initBAMWithCustomization(<API_TOKEN>, <API_SECRET>, <DATACENTER>, {configuration}, {customization});
```

You can pass the following customization options to the initializer:

| Customization key | Type | Description |
|:------------------|:-----|:------------|
| disableBlur       | BOOL | Deactivate the blur effect |
| backgroundColor   | STRING | Change base view's background color |
| foregroundColor   | STRING | Change base view's foreground color |
| tintColor         | STRING | Change the tint color of the navigation bar |
| barTintColor      | STRING | Change the bar tint color of the navigation bar |
| textTitleColor    | STRING | Change the text title color of the navigation bar |
| documentSelectionHeaderBackgroundColor | STRING | Change the background color of the document selection header |
| documentSelectionHeaderTitleColor | STRING | Change the title color of the document selection header |
| documentSelectionHeaderIconColor | STRING | Change the icon color of the document selection header |
| documentSelectionButtonBackgroundColor | STRING | Change the background color of the document selection button |
| documentSelectionButtonTitleColor | STRING | Change the title color of the document selection button |
| documentSelectionButtonIconColor | STRING | Change the icon color of the document selection button |
| fallbackButtonBackgroundColor | STRING | Change the background color of the fallback button |
| fallbackButtonBorderColor | STRING | Change the border color of the fallback button |
| fallbackButtonTitleColor | STRING | Change the title color of the fallback button |
| positiveButtonBackgroundColor | STRING | Change the background color of the positive button |
| positiveButtonBorderColor | STRING | Change the border color of the positive button |
| positiveButtonTitleColor | STRING | Change the title color of the positive button |
| negativeButtonBackgroundColor | STRING | Change the background color of the negative button |
| negativeButtonBorderColor | STRING | Change the border color of the negative button |
| negativeButtonTitleColor | STRING | Change the title color of the negative button |
| scanOverlayStandardColor (NV only) | STRING | Change the standard color of the scan overlay |
| scanOverlayValidColor (NV only) | STRING | Change the valid color of the scan overlay |
| scanOverlayInvalidColor (NV only) | STRING | Change the invalid color of the scan overlay |
| scanOverlayTextColor (BAM only) | STRING | Change the text color of the scan overlay |
| scanOverlayBorderColor (BAM only) | STRING | Change the border color of the scan overlay |

All colors are provided with a HEX string with the following format: #ff00ff.

**Customization example**
```javascript
Jumio.initNetverify("API_TOKEN", "API_SECRET", "US", {
    enableVerification: false,
    ...
}, {
    disableBlur: true,
    backgroundColor: "#ff00ff",
    barTintColor: "#ff1298"
);
```

## Callbacks

To get information about callbacks, Netverify Retrieval API, Netverify Delete API and Global Netverify settings and more, please read our [page with server related information](https://github.com/Jumio/implementation-guides/blob/master/netverify/callback.md).

The JSONObject with all the extracted data that is returned for the specific products is described in the following subchapters:

### Netverify & Fastfill

*NetverifyDocumentData:*

| Parameter | Type | Max. length | Description  |
|:-------------------|:----------- 	|:-------------|:-----------------|
| selectedCountry | String| 3| [ISO 3166-1 alpha-3](http://en.wikipedia.org/wiki/ISO_3166-1_alpha-3) country code as provided or selected |
| selectedDocumentType | String | 16| PASSPORT, DRIVER_LICENSE, IDENTITY_CARD or VISA |
| idNumber | String | 100 | Identification number of the document |
| personalNumber | String | 14| Personal number of the document|
| issuingDate | Date | | Date of issue |
| expiryDate | Date | | Date of expiry |
| issuingCountry | String | 3 | Country of issue as ([ISO 3166-1 alpha-3](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3)) country code |
| lastName | String | 100 | Last name of the customer|
| firstName | String | 100 | First name of the customer|
| middleName | String | 100 | Middle name of the customer |
| dob | Date | | Date of birth |
| gender | String | 1| m, f or x |
| originatingCountry | String | 3|Country of origin as ([ISO 3166-1 alpha-3](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3)) country code |
| addressLine | String | 64 | Street name	|
| city | String | 64 | City |
| subdivision | String | 3 | Last three characters of [ISO 3166-2:US](http://en.wikipedia.org/wiki/ISO_3166-2:US) state code	|
| postCode | String | 15 | Postal code |
| mrzData |  MRZ-DATA | | MRZ data, see table below |
| optionalData1 | String | 50 | Optional field of MRZ line 1 |
| optionalData2 | String | 50 | Optional field of MRZ line 2 |
| placeOfBirth | String | 255 | Place of Birth |
| extractionMethod | String | 12| MRZ, OCR, BARCODE, BARCODE_OCR or NONE |

*MRZ-Data*

| Parameter |Type | Max. length | Description |
|:---------------|:------------- |:-------------|:-----------------|
| format | String |  8| MRP, TD1, TD2, CNIS, MRVA, MRVB or UNKNOWN |
| line1 | String | 50 | MRZ line 1 |
| line2 | String | 50 | MRZ line 2 |
| line3 | String | 50| MRZ line 3 |
| idNumberValid | BOOL| | True if ID number check digit is valid, otherwise false |
| dobValid | BOOL | | True if date of birth check digit is valid, otherwise false |
| expiryDateValid |	BOOL| |	True if date of expiry check digit is valid or not available, otherwise false|
| personalNumberValid | BOOL | | True if personal number check digit is valid or not available, otherwise false |
| compositeValid | BOOL | | True if composite check digit is valid, otherwise false |


### Authentication

*AuthenticationResult:*

| Parameter |Type | Max. length | Description |
|:---------------|:------------- |:-------------|:-----------------|
| authenticationResult | String |  8| SUCCESS or FAILED |

### BAM Checkout

*BAMCardInformation:*

|Parameter | Type | Max. length | Description |
|:---------------------------- 	|:-------------|:-----------------|:-------------|
| cardType | String |  16| VISA, MASTER_CARD, AMERICAN_EXPRESS, CHINA_UNIONPAY, DINERS_CLUB, DISCOVER, JCB or STARBUCKS |
| cardNumber | String | 16 | Full credit card number |
| cardNumberGrouped | String | 19 | Grouped credit card number |
| cardNumberMasked | String | 19 | First 6 and last 4 digits of the grouped credit card number, other digits are masked with "X" |
| cardExpiryMonth | String | 2 | Month card expires if enabled and readable |
| CardExpiryYear | String | 2 | Year card expires if enabled and readable |
| cardExpiryDate | String | 5 | Date card expires in the format MM/yy if enabled and readable |
| cardCVV | String | 4 | Entered CVV if enabled |
| cardHolderName | String | 100 | Name of the card holder in capital letters if enabled and readable, or as entered if editable |
| cardSortCode | String | 8 | Sort code in the format xx-xx-xx or xxxxxx if enabled, available and readable |
| cardAccountNumber | String | 8 | Account number if enabled, available and readable |
| cardSortCodeValid | BOOL |  | True if sort code valid, otherwise false |
| cardAccountNumberValid | BOOL |  | True if account number code valid, otherwise false |

### Document Verification

No data returned.

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

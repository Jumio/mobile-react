/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  NativeModules,
  NativeEventEmitter
} from 'react-native';
import Button from 'react-native-button';

const { JumioMobileSDKNetverify } = NativeModules;
const { JumioMobileSDKBamCheckout } = NativeModules;
const { JumioMobileSDKDocumentVerification } = NativeModules;

// Netverify

const startNetverify = () => {
  JumioMobileSDKNetverify.initNetverify('API_TOKEN', 'API_SECRET', 'DATACENTER', {
	  requireVerification: true,
	  //callbackUrl: "URL",
	  //requireFaceMatch: true,
	  //preselectedCountry: "USA",
	  //merchantScanReference: "123456789",
	  //merchantReportingCriteria: "Criteria",
	  //customerId: "ID",
	  //sendDebugInfoToJumio: true,
	  //dataExtractionOnMobileOnly: false,
	  //cameraPosition: "back",
	  //preselectedDocumentVariant: "plastic",
	  //documentTypes: ["PASSPORT", "DRIVER_LICENSE", "IDENTITY_CARD", "VISA"]
  });
  
  // Android only
  //JumioMobileSDKNetverify.enableEMRTD();
  
  JumioMobileSDKNetverify.startNetverify();
};

// Document Verification

const startDocumentVerification = () => {
  JumioMobileSDKDocumentVerification.initDocumentVerification('API_TOKEN', 'API_SECRET', 'DATACENTER', {
	  type: "BS",
	  customerId: "123456789",
	  country: "USA",
	  merchantScanReference: "123456789",
	  //merchantScanReportingCriteria: "Criteria",
	  //callbackUrl: "URL",
	  //documentName: "Name",
	  //customDocumentCode: "Custom",
    //cameraPosition: "back",
    //enableExtraction: true
  });
  JumioMobileSDKDocumentVerification.startDocumentVerification();
};

// BAM Checkout

const startBAM = () => {
  JumioMobileSDKBamCheckout.initBAM('API_TOKEN', 'API_SECRET', 'DATACENTER', {
	//cardHolderNameRequired: true,
	//sortCodeAndAccountNumberRequired: false,
	//expiryRequired: true,
	//cvvRequired: true,
	//expiryEditable: false,
	//cardHolderNameEditable: false,
	//merchantReportingCriteria: "Criteria",
	//vibrationEffectEnabled: true,
	//enableFlashOnScanStart: false,
	//cardNumberMaskingEnabled: false,
	//offlineToken: "TOKEN",
	//cameraPosition: "back",
	//cardTypes: ["VISA", "MASTER_CARD", "AMERICAN_EXPRESS", "CHINA_UNIONPAY", "DINERS_CLUB", "DISCOVER", "JCB"]
  });
  JumioMobileSDKBamCheckout.startBAM();
};

// Callbacks - (Data is displayed as a warning for demo purposes)
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

export default class DemoApp extends Component {
  render() {
    return (
  	  <View style={styles.container}>
		<Button
			onPress={startNetverify}
			style={styles.buttonStyle}>
			Start Netverify
		</Button>
		<Button
			onPress={startDocumentVerification}
			style={styles.buttonStyle}>
			Start Document Verification
		</Button>
		<Button
			onPress={startBAM}
			style={styles.buttonStyle}>
			Start BAM Checkout
		</Button>
  	  </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
  buttonStyle: {
	  marginBottom: 20
  }
});

AppRegistry.registerComponent('DemoApp', () => DemoApp);

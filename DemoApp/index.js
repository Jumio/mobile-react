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
const { JumioMobileSDKAuthentication } = NativeModules;
const { JumioMobileSDKBamCheckout } = NativeModules;
const { JumioMobileSDKDocumentVerification } = NativeModules;

// Netverify

const startNetverify = () => {
  JumioMobileSDKNetverify.initNetverify('API_TOKEN', 'API_SECRET', 'DATACENTER', {
	  enableVerification: true,
	  //callbackUrl: "URL",
	  //enableIdentityVerification: true,
	  //preselectedCountry: "USA",
	  //customerInternalReference: "123456789",
	  //reportingCriteria: "Criteria",
	  //userReference: "ID",
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

// Authentication

const startAuthentication = () => {
  JumioMobileSDKAuthentication.initAuthentication('API_TOKEN', 'API_SECRET', 'DATACENTER', {
	  enrollmentTransactionReference: "EnrollmentTransactionReference",
	  //userReference: "UserReference",
	  //callbackUrl: "URL"
  });  
};

// Document Verification

const startDocumentVerification = () => {
  JumioMobileSDKDocumentVerification.initDocumentVerification('API_TOKEN', 'API_SECRET', 'DATACENTER', {
	  type: "BS",
	  userReference: "123456789",
	  country: "USA",
	  customerInternalReference: "123456789",
	  //reportingCriteria: "Criteria",
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
	//reportingCriteria: "Criteria",
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

const emitterAuthentication = new NativeEventEmitter(JumioMobileSDKAuthentication);
emitterAuthentication.addListener(
    'EventAuthentication',
	(EventAuthentication) => console.warn("EventAuthentication: " + JSON.stringify(EventAuthentication))
);
emitterAuthentication.addListener(
    'EventError',
    (EventError) => console.warn("EventError: " + JSON.stringify(EventError))
);
emitterAuthentication.addListener(
    'EventInitiateSuccess',
    (EventInitiateSuccess) => JumioMobileSDKAuthentication.startAuthentication()
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
			onPress={startAuthentication}
			style={styles.buttonStyle}>
			Start Authentication
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

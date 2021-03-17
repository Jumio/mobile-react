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

const API_TOKEN = 'YOUR_API_TOKEN'
const API_SECRET = 'YOUR_API_SECRET'
const DATACENTER = 'DATACENTER'
const BAM_API_TOKEN = 'YOUR_BAM_API_TOKEN'
const BAM_API_SECRET = 'YOUR_BAM_API_SECRET'
const BAM_DATACENTER = 'BAM_DATACENTER'

// Netverify

const startNetverify = () => {
  JumioMobileSDKNetverify.initNetverify(API_TOKEN, API_SECRET, DATACENTER, {
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
	  //documentTypes: ["PASSPORT", "DRIVER_LICENSE", "IDENTITY_CARD", "VISA"],
	  //enableWatchlistScreening: ["enabled", "disabled" || "default"],
	  //watchlistSearchProfile: "YOURPROFILENAME"
  });

  JumioMobileSDKNetverify.startNetverify();
};

// Document Verification

const startDocumentVerification = () => {
  JumioMobileSDKDocumentVerification.initDocumentVerification(API_TOKEN, API_SECRET, DATACENTER, {
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
  JumioMobileSDKBamCheckout.initBAM(BAM_API_TOKEN, BAM_API_SECRET, BAM_DATACENTER, {
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
    'EventErrorNetverify',
    (EventErrorNetverify) => console.warn("EventErrorNetverify: " + JSON.stringify(EventErrorNetverify))
);

const emitterDocumentVerification = new NativeEventEmitter(JumioMobileSDKDocumentVerification)
emitterDocumentVerification.addListener(
    'EventDocumentVerification',
    (EventDocumentVerification) => console.warn("EventDocumentVerification: " + JSON.stringify(EventDocumentVerification))
);
emitterDocumentVerification.addListener(
    'EventErrorDocumentVerification',
    (EventErrorDocumentVerification) => console.warn("EventErrorDocumentVerification: " + JSON.stringify(EventErrorDocumentVerification))
);

const emitterBamCheckout = new NativeEventEmitter(JumioMobileSDKBamCheckout)
emitterBamCheckout.addListener(
    'EventCardInformation',
    (EventCardInformation) => console.warn("EventCardInformation: " + JSON.stringify(EventCardInformation))
);
emitterBamCheckout.addListener(
    'EventErrorBam',
    (EventErrorBam) => console.warn("EventErrorBam: " + JSON.stringify(EventErrorBam))
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

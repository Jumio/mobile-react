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
  Button,
  NativeModules,
  NativeEventEmitter
} from 'react-native';

const { JumioMobileSDK } = NativeModules;

// Netverify

const startNetverify = () => {
  JumioMobileSDK.initNetverify('API_TOKEN', 'API_SECRET', 'DATACENTER', {
	  requireVerification: true,
	  //callbackUrl: "URL",
	  //requireFaceMatch: true,
	  //preselectedCountry: "AUT",
	  //merchantScanReference: "ScanRef",
	  //merchantReportingCriteria: "Criteria",
	  //customerId: "ID",
	  //additionalInformation: "Information",
	  //sendDebugInfoToJumio: true,
	  //dataExtractionOnMobileOnly: false,
	  //cameraPosition: "back",
	  //preselectedDocumentVariant: "plastic",
	  //documentTypes: ["PASSPORT", "DRIVER_LICENSE", "IDENTITY_CARD", "VISA"]
  });
  JumioMobileSDK.startNetverify();
};

// Document Verification

const startDocumentVerification = () => {
  JumioMobileSDK.initDocumentVerification('API_TOKEN', 'API_SECRET', 'DATACENTER', {
	  type: "BS",
	  customerId: "123456789",
	  country: "USA",
	  merchantScanReference: "123456789",
	  //merchantScanReportingCriteria: "Criteria",
	  //callbackUrl: "URL",
	  //additionalInformation: "Information",
	  //documentName: "Name",
	  //customDocumentCode: "Custom",
	  //cameraPosition: "back"
  });
  JumioMobileSDK.startDocumentVerification();
};

// BAM Checkout

const startBAM = () => {
  JumioMobileSDK.initBAM('API_TOKEN', 'API_SECRET', 'DATACENTER', {
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
	//cardTypes: ["VISA", "MASTER_CARD", "AMERICAN_EXPRESS", "CHINA_UNIONPAY", "DINERS_CLUB", "DISCOVER", "JCB", "STARBUCKS"]
  });
  JumioMobileSDK.startBAM();
};

// Callbacks

const emitter = new NativeEventEmitter(JumioMobileSDK);
emitter.addListener(
    'EventDocumentData',
    (reminder) => alert(JSON.stringify(reminder))
);
emitter.addListener(
    'EventDocumentVerification',
    (reminder) => alert(JSON.stringify(reminder))
);
emitter.addListener(
    'EventCardInformation',
    (reminder) => alert(JSON.stringify(reminder))
);
emitter.addListener(
    'EventError',
    (reminder) => alert(JSON.stringify(reminder))
);

export default class DemoApp extends Component {
  render() {
    return (
  	  <View style={styles.container}>
  		<Button
    		onPress={startNetverify}
    		title="Start Netverify" />
  		<Button
    		onPress={startBAM}
    		title="Start BAM Checkout" />
  		<Button
    		onPress={startDocumentVerification}
    		title="Start Document Verification" />
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
});

AppRegistry.registerComponent('DemoApp', () => DemoApp);
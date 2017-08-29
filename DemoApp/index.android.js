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
  DeviceEventEmitter
} from 'react-native';
import Button from 'react-native-button';

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
  //JumioMobileSDK.enableEMRTD();
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
	//cvvRequired: false,
	//expiryEditable: false,
	//cardHolderNameEditable: false,
	//merchantReportingCriteria: "Criteria",
	//vibrationEffectEnabled: true,
	//enableFlashOnScanStart: false,
	//cardNumberMaskingEnabled: false,
	//cameraPosition: "back",
	//cardTypes: ["VISA", "MASTER_CARD", "AMERICAN_EXPRESS", "CHINA_UNIONPAY", "DINERS_CLUB", "DISCOVER", "JCB", "STARBUCKS"]
  });
  JumioMobileSDK.startBAM();
};

// Callbacks

DeviceEventEmitter.addListener('EventDocumentData', function(e: Event) {
    alert(e)
});

DeviceEventEmitter.addListener('EventDocumentVerification', function(e: Event) {
    alert(e)
});

DeviceEventEmitter.addListener('EventCardInformation', function(e: Event) {
    alert(e)
});

DeviceEventEmitter.addListener('EventError', function(e: Event) {
    alert(e)
});

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
/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, {Component, useState} from 'react';
import {
    AppRegistry,
    Button,
    Platform,
    StyleSheet,
    View,
    NativeModules,
    NativeEventEmitter, TextInput
} from 'react-native';
import { LogBox } from 'react-native';

LogBox.ignoreLogs(['new NativeEventEmitter']);

const {JumioMobileSDK} = NativeModules;

const DATACENTER = 'DATACENTER'

// Jumio SDK
const startJumio = (authorizationToken) => {
    JumioMobileSDK.initialize(authorizationToken, DATACENTER);

    // Setup iOS customizations
//    JumioMobileSDK.setupCustomizations(
//        {
//            loadingCircleIcon: "#000000",
//            loadingCirclePlain: "#000000",
//            loadingCircleGradientStart: "#000000",
//            loadingCircleGradientEnd: "#000000",
//            loadingErrorCircleGradientStart: "#000000",
//            loadingErrorCircleGradientEnd: "#000000",
//            primaryButtonBackground: {"light": "#FFC0CB", "dark": "#FF1493"}
//        }
//    );

    JumioMobileSDK.start();
};

const isDeviceRooted = async () => {
    const isRooted = await JumioMobileSDK.isRooted();
    console.warn("Device is rooted: " + isRooted)
}

// Callbacks - (Data is displayed as a warning for demo purposes)
const emitterJumio = new NativeEventEmitter(JumioMobileSDK);
emitterJumio.addListener(
    'EventResult',
    (EventResult) => console.warn("EventResult: " + JSON.stringify(EventResult))
);
emitterJumio.addListener(
    'EventError',
    (EventError) => console.warn("EventError: " + JSON.stringify(EventError))
);

export default class DemoApp extends Component {
    render() {
        return (
            <View style={styles.container}>
                <AuthTokenInput/>
            </View>
        );
    }
}

const AuthTokenInput = () => {
    const [authorizationToken, setAuthorizationToken] = useState("");

    return (
        <View>
            <TextInput
                style={styles.input}
                placeholder="Authorization token"
                placeholderTextColor="#000"
                returnKeyType="done"
                onChangeText={text => setAuthorizationToken(text)}
                value={authorizationToken}
            />
            <Button
                title="Start"
                onPress={() => startJumio(authorizationToken)}
            />
        </View>
    );
};

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
    input: {
        width: 240,
        height: 40,
        marginBottom: 20,
        borderWidth: 1,
        color: 'black'
    },
});

AppRegistry.registerComponent('DemoApp', () => DemoApp);
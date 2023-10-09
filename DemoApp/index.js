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
    NativeEventEmitter,
    TextInput,
    Text
} from 'react-native';
import { LogBox } from 'react-native';

LogBox.ignoreLogs(['new NativeEventEmitter']);

const { JumioMobileSDK } = NativeModules;

var DATACENTER = 'DATACENTER'

// Jumio SDK
const startJumio = (authorizationToken) => {
    JumioMobileSDK.initialize(authorizationToken, DATACENTER);

    // Setup iOS customizations
//    JumioMobileSDK.setupCustomizations(
//        {
//            background: "#AC3D9A",
//              primaryColor: "#FF5722",
//              loadingCircleIcon: "#F2F233",
//              loadingCirclePlain: "#57ffc7",
//              loadingCircleGradientStart: "#EC407A",
//              loadingCircleGradientEnd: "#bc2e41",
//              loadingErrorCircleGradientStart: "#AC3D9A",
//              loadingErrorCircleGradientEnd: "#C31322",
//              primaryButtonBackground: {"light": "#D900ff00", "dark": "#9Edd9E"}
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

    const [buttonText, setButtonText] = useState('Click');

    function handleClick() {
        setButtonText({DATACENTER});
    }

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
            <View style={{marginTop: 10}}>
                <Button
                    style={styles.datacenterButton}
                    title="US"
                    onPress={() => {
                        DATACENTER="US";
                        handleClick({DATACENTER})
                        }
                    }
                />
            </View>
            <View style={{marginTop: 10}}>
                <Button
                    style={styles.datacenterButton}
                    title="EU"
                    onPress={() => {
                        DATACENTER="EU";
                        handleClick({DATACENTER})
                        }
                    }
                />
            </View>
            <View style={{marginTop:10}}>
                <Button
                    style={styles.datacenterButton}
                    title="SG"
                    onPress={() => {
                        DATACENTER="SG";
                        handleClick({DATACENTER})
                        }
                    }
                />
            </View>
            <View style={styles.datacenter}>
                <Text>{DATACENTER}</Text>
            </View>
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
    datacenterButton: {
        marginVertical: 5,
        justifyContent: 'center',
    },
    datacenter: {
        width: 240,
        height: 40,
        marginBottom: 20,
        marginTop: 20,
        borderWidth: 1,
        color: '#808080',
        justifyContent: 'center'
    },
});

AppRegistry.registerComponent('DemoApp', () => DemoApp);
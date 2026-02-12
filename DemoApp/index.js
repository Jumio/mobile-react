/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, {Component, useState, useEffect} from 'react';
import {
    AppRegistry,
    Button,
    Platform,
    StyleSheet,
    View,
    NativeModules,
    NativeEventEmitter,
    TextInput,
    TouchableOpacity,
    Text,
    ScrollView
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

const initModelPreloading = () => {
    JumioMobileSDK.setPreloaderFinishedBlock(() => {
        console.log('All models are preloaded. You may start the SDK now!');
    });
    JumioMobileSDK.preloadIfNeeded()
};

initModelPreloading();

export default class DemoApp extends Component {
    render() {
        return (
            <View style={styles.container}>
                <AuthTokenInput/>
            </View>
        );
    }
}

const AppButton = ({ onPress, title, style, textStyle}) => (
  <TouchableOpacity onPress={onPress} style={[styles.appButton, style]}>
    <Text style={[styles.appButtonText, textStyle]}>{title}</Text>
  </TouchableOpacity>
);

const AuthTokenInput = () => {
    const [authorizationToken, setAuthorizationToken] = useState("");
    const [ignored, forceUpdate] = useState(0);

    const handleDatacenterChange = (newValue) => {
        DATACENTER = newValue;
        forceUpdate(n => n + 1);
    }

    useEffect(() => {
        const emitterJumio = new NativeEventEmitter(JumioMobileSDK);

        const resultSubscription = emitterJumio.addListener(
            'EventResult',
            (EventResult) => console.warn("EventResult: " + JSON.stringify(EventResult))
        );

        const errorSubscription = emitterJumio.addListener(
            'EventError',
            (EventError) => console.warn("EventError: " + JSON.stringify(EventError))
        );

        return () => {
            resultSubscription.remove();
            errorSubscription.remove();
        };
    }, []);

    return (
        <ScrollView
            style={styles.container}
            contentContainerStyle={styles.scrollContent}
            keyboardShouldPersistTaps="handled"
        >
            <View style={styles.inputContainer}>
                <TextInput
                  style={styles.input}
                  placeholder="Authorization token"
                  placeholderTextColor="#666"
                  returnKeyType="done"
                  onChangeText={setAuthorizationToken}
                  value={authorizationToken}
                />

                {authorizationToken.length > 0 && (
                  <TouchableOpacity
                    onPress={() => setAuthorizationToken('')}
                    style={styles.clearButtonCircle}
                    hitSlop={{top: 10, bottom: 10, left: 10, right: 10}}
                  >
                    <Text style={styles.clearTextWhite}>✕</Text>
                  </TouchableOpacity>
                )}
            </View>
            <AppButton
                title="Start"
                onPress={() => startJumio(authorizationToken)}
                style={styles.startButton}
                textStyle={styles.startButtonText}
            />
            <AppButton
                title="US"
                onPress={() => handleDatacenterChange("US")}
            />
            <AppButton
                title="EU"
                onPress={() => handleDatacenterChange("EU")}
            />
            <AppButton
                title="SG"
                onPress={() => handleDatacenterChange("SG")}
            />
            <View style={styles.datacenter}>
                <Text style={styles.datacenterText}>{DATACENTER}</Text>
            </View>
        </ScrollView>
    );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#F5F5F5',
    },
    scrollContent: {
        flexGrow: 1,
        alignItems: 'center',
        justifyContent: 'center',
        paddingVertical: 30,
    },
    inputContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        width: '90%',
        height: 50,
        marginBottom: 20,
        borderWidth: 1,
        borderColor: '#CCC',
        borderRadius: 8,
        backgroundColor: '#FFF',
        paddingHorizontal: 10,
    },
    input: {
        flex: 1,
        height: '100%',
        color: 'black',
        fontSize: 16,
    },
    appButton: {
        width: '60%',
        height: 50,
        backgroundColor: '#007AFF',
        borderRadius: 8,
        justifyContent: 'center',
        alignItems: 'center',
        marginBottom: 10,
        elevation: 3,
    },
    appButtonText: {
        fontSize: 16,
        color: '#FFF',
        fontWeight: 'bold',
    },
    startButton: {
        backgroundColor: '#FFF',
        borderRadius: 8,
        borderColor: '#CCC',
        marginBottom: 20
    },
    startButtonText: {
        color: '#000',
    },
    datacenter: {
        width: '60%',
        height: 50,
        borderWidth: 1,
        borderColor: '#CCC',
        borderRadius: 8,
        backgroundColor: '#FFF',
        paddingHorizontal: 10,
        marginTop: 20,
        justifyContent: 'center',
        alignItems: 'center',
    },
    datacenterText: {
        fontSize: 16,
        color: 'black',
    },
    clearButtonCircle: {
        backgroundColor: '#E0E0E0',
        width: 20,
        height: 20,
        borderRadius: 10,
        justifyContent: 'center',
        alignItems: 'center',
        marginLeft: 8,
    },
    clearTextWhite: {
        color: 'white',
        fontSize: 12,
        fontWeight: 'bold',
        marginTop: -1,
    }
});

AppRegistry.registerComponent('DemoApp', () => DemoApp);
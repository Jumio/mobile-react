# DemoApp for React Native

## Usage

Adjust your credentials in **index.ios.js** and **index.android.js** and run the following commands

```
npm install
```

### iOS

```
cd ios
pod install
cd ..
react-native run-ios
```

### Android

```
react-native run-android
```

If you get the error: ```GC overhead limit exceeded``` add the following line to the android section of your build.gradle (app):
```javascript
dexOptions {
    javaMaxHeapSize "4g"
}
```

If you get the error: ```Unable to crunch file``` on windows add the following line to your build.gradle (project):
```javascript
allprojects {
    buildDir = "C:/tmp/${rootProject.name}/${project.name}"
}
```

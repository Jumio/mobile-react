# DemoApp for React Native

## Usage

Adjust your credentials in **index.js**, open a bash and run the following commands

### Both
Required to retrieve all dependencies that are required by this demo app:
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
npm run android-windows
// or
react-native run-android
```

If you get the error: ```Unable to crunch file``` on windows add the following line to your build.gradle (project):
```javascript
allprojects {
    buildDir = "C:/tmp/${rootProject.name}/${project.name}"
}
```

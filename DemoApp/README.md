# DemoApp for React Native

## Usage

Adjust your credentials in **index.js** file, open a bash and run the following commands:

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

Jumio SDK dependencies added in version 3.8.0 make it necessary to add the following pre-install hook to the Podfile:
```
dynamic_frameworks = ['Socket.IO-Client-Swift', 'Starscream', 'iProov']

pre_install do |installer|
  installer.pod_targets.each do |pod|
    if !dynamic_frameworks.include?(pod.name)
      puts "Overriding the static_framework? method for #{pod.name}"
      def pod.static_framework?;
        true
      end
      def pod.build_type;
        Pod::BuildType.static_library
      end
    end
  end
end
```
This was added because iProov dependencies __SocketIO__ and __Starscream__ need to be build as dynamic frameworks while React Native are supported only as static libraries. This pre-install hook ensures that the pods added as `dynamic_frameworks` are built as dynamic frameworks, while the other pods are built as static libraries.

One additional post-install hook needs to be added to the Podfile so that the dependencies are build for distribution:
```
post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      end
    end
end
```

### Android
```
npm run android-windows
// or
react-native run-android
```

If you get the error: `Unable to crunch file` on windows add the following line to your `build.gradle` (project):
```javascript
allprojects {
    buildDir = "C:/tmp/${rootProject.name}/${project.name}"
}
```

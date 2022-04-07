package com.jumio.react

import android.view.View
import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ReactShadowNode
import com.facebook.react.uimanager.ViewManager

class JumioPackage() : ReactPackage {
    override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<View, ReactShadowNode<*>>> =
        emptyList()

    override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> =
        listOf(JumioModule(reactContext))
}
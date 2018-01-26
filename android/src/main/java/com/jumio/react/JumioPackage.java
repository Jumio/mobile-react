/*
 * Copyright 2017 Jumio Corporation
 * All rights reserved
 */

package com.jumio.react;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.*;
import com.facebook.react.uimanager.ViewManager;

import java.util.*;

public class JumioPackage implements ReactPackage {
    
    @Override
    public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
        return Collections.emptyList();
    }
    
    @Override
    public List<NativeModule> createNativeModules(ReactApplicationContext reactContext) {
        List<NativeModule> modules = new ArrayList<>();
//        modules.add(new JumioModule(reactContext));
        modules.add(new JumioModuleNetverify(reactContext));
        modules.add(new JumioModuleBamCheckout(reactContext));
        modules.add(new JumioModuleDocumentVerification(reactContext));
        return modules;
    }
}


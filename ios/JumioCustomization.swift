import Jumio

extension JumioMobileSDK {
    func customizeSDKColors(customizations: [String: Any?]) -> Jumio.Theme {
        var customTheme = Jumio.Theme()
        // IProov
        if let iProovAnimationForeground = customizations["iProovAnimationForeground"] as? [String: String?], let light = iProovAnimationForeground["light"] as? String, let dark = iProovAnimationForeground["dark"] as? String {
            customTheme.iProov.animationForeground = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let iProovAnimationForeground = customizations["iProovAnimationForeground"] as? String {
            customTheme.iProov.animationForeground = Jumio.Theme.Value(UIColor(hexString: iProovAnimationForeground))
        }
        
        if let iProovAnimationBackground = customizations["iProovAnimationBackground"] as? [String: String?], let light = iProovAnimationBackground["light"] as? String, let dark = iProovAnimationBackground["dark"] as? String {
            customTheme.iProov.animationBackground = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let iProovAnimationBackground = customizations["iProovAnimationBackground"] as? String {
            customTheme.iProov.animationBackground = Jumio.Theme.Value(UIColor(hexString: iProovAnimationBackground))
        }
        
        if let iProovFilterForegroundColor = customizations["iProovFilterForegroundColor"] as? [String: String?], let light = iProovFilterForegroundColor["light"] as? String, let dark = iProovFilterForegroundColor["dark"] as? String {
            customTheme.iProov.filterForegroundColor = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let iProovFilterForegroundColor = customizations["iProovFilterForegroundColor"] as? String {
            customTheme.iProov.filterForegroundColor = Jumio.Theme.Value(UIColor(hexString: iProovFilterForegroundColor))
        }
        
        if let iProovFilterBackgroundColor = customizations["iProovFilterBackgroundColor"] as? [String: String?], let light = iProovFilterBackgroundColor["light"] as? String, let dark = iProovFilterBackgroundColor["dark"] as? String {
            customTheme.iProov.filterBackgroundColor = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let iProovFilterBackgroundColor = customizations["iProovFilterBackgroundColor"] as? String {
            customTheme.iProov.filterBackgroundColor = Jumio.Theme.Value(UIColor(hexString: iProovFilterBackgroundColor))
        }

        if let iProovTitleTextColor = customizations["iProovTitleTextColor"] as? [String: String?], let light = iProovTitleTextColor["light"] as? String, let dark = iProovTitleTextColor["dark"] as? String {
            customTheme.iProov.titleTextColor = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let iProovTitleTextColor = customizations["iProovTitleTextColor"] as? String {
            customTheme.iProov.titleTextColor = Jumio.Theme.Value(UIColor(hexString: iProovTitleTextColor))
        }
        
        if let iProovCloseButtonTintColor = customizations["iProovCloseButtonTintColor"] as? [String: String?], let light = iProovCloseButtonTintColor["light"] as? String, let dark = iProovCloseButtonTintColor["dark"] as? String {
            customTheme.iProov.closeButtonTintColor = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let iProovCloseButtonTintColor = customizations["iProovCloseButtonTintColor"] as? String {
            customTheme.iProov.closeButtonTintColor = Jumio.Theme.Value(UIColor(hexString: iProovCloseButtonTintColor))
        }
        
        if let iProovSurroundColor = customizations["iProovSurroundColor"] as? [String: String?], let light = iProovSurroundColor["light"] as? String, let dark = iProovSurroundColor["dark"] as? String {
            customTheme.iProov.surroundColor = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let iProovSurroundColor = customizations["iProovSurroundColor"] as? String {
            customTheme.iProov.surroundColor = Jumio.Theme.Value(UIColor(hexString: iProovSurroundColor))
        }

        if let iProovPromptTextColor = customizations["iProovPromptTextColor"] as? [String: String?], let light = iProovPromptTextColor["light"] as? String, let dark = iProovPromptTextColor["dark"] as? String {
            customTheme.iProov.promptTextColor = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let iProovPromptTextColor = customizations["iProovPromptTextColor"] as? String {
            customTheme.iProov.promptTextColor = Jumio.Theme.Value(UIColor(hexString: iProovPromptTextColor))
        }
        
        if let iProovPromptBackgroundColor = customizations["iProovPromptBackgroundColor"] as? [String: String?], let light = iProovPromptBackgroundColor["light"] as? String, let dark = iProovPromptBackgroundColor["dark"] as? String {
            customTheme.iProov.promptBackgroundColor = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let iProovPromptBackgroundColor = customizations["iProovPromptBackgroundColor"] as? String {
            customTheme.iProov.promptBackgroundColor = Jumio.Theme.Value(UIColor(hexString: iProovPromptBackgroundColor))
        }
        
        if let genuinePresenceAssuranceReadyOvalStrokeColor = customizations["genuinePresenceAssuranceReadyOvalStrokeColor"] as? [String: String?], let light = genuinePresenceAssuranceReadyOvalStrokeColor["light"] as? String, let dark = genuinePresenceAssuranceReadyOvalStrokeColor["dark"] as? String {
            customTheme.iProov.genuinePresenceAssuranceReadyOvalStrokeColor = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let genuinePresenceAssuranceReadyOvalStrokeColor = customizations["genuinePresenceAssuranceReadyOvalStrokeColor"] as? String {
            customTheme.iProov.genuinePresenceAssuranceReadyOvalStrokeColor = Jumio.Theme.Value(UIColor(hexString: genuinePresenceAssuranceReadyOvalStrokeColor))
        }
        
        if let genuinePresenceAssuranceNotReadyOvalStrokeColor = customizations["genuinePresenceAssuranceNotReadyOvalStrokeColor"] as? [String: String?], let light = genuinePresenceAssuranceNotReadyOvalStrokeColor["light"] as? String, let dark = genuinePresenceAssuranceNotReadyOvalStrokeColor["dark"] as? String {
            customTheme.iProov.genuinePresenceAssuranceNotReadyOvalStrokeColor = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let genuinePresenceAssuranceNotReadyOvalStrokeColor = customizations["genuinePresenceAssuranceNotReadyOvalStrokeColor"] as? String {
            customTheme.iProov.genuinePresenceAssuranceNotReadyOvalStrokeColor = Jumio.Theme.Value(UIColor(hexString: genuinePresenceAssuranceNotReadyOvalStrokeColor))
        }
        
        if let livenessAssuranceOvalStrokeColor = customizations["livenessAssuranceOvalStrokeColor"] as? [String: String?], let light = livenessAssuranceOvalStrokeColor["light"] as? String, let dark = livenessAssuranceOvalStrokeColor["dark"] as? String {
            customTheme.iProov.livenessAssuranceOvalStrokeColor = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let livenessAssuranceOvalStrokeColor = customizations["livenessAssuranceOvalStrokeColor"] as? String {
            customTheme.iProov.livenessAssuranceOvalStrokeColor = Jumio.Theme.Value(UIColor(hexString: livenessAssuranceOvalStrokeColor))
        }
        
        if let livenessAssuranceCompletedOvalStrokeColor = customizations["livenessAssuranceCompletedOvalStrokeColor"] as? [String: String?], let light = livenessAssuranceCompletedOvalStrokeColor["light"] as? String, let dark = livenessAssuranceCompletedOvalStrokeColor["dark"] as? String {
            customTheme.iProov.livenessAssuranceCompletedOvalStrokeColor = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let livenessAssuranceCompletedOvalStrokeColor = customizations["livenessAssuranceCompletedOvalStrokeColor"] as? String {
            customTheme.iProov.livenessAssuranceCompletedOvalStrokeColor = Jumio.Theme.Value(UIColor(hexString: livenessAssuranceCompletedOvalStrokeColor))
        }

        // Primary & Secondry Buttons
        if let primaryButtonBackground = customizations["primaryButtonBackground"] as? [String: String?], let light = primaryButtonBackground["light"] as? String, let dark = primaryButtonBackground["dark"] as? String {
            customTheme.primaryButton.background = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let primaryButtonBackground = customizations["primaryButtonBackground"] as? String {
            customTheme.primaryButton.background = Jumio.Theme.Value(UIColor(hexString: primaryButtonBackground))
        }

        if let primaryButtonBackgroundPressed = customizations["primaryButtonBackgroundPressed"] as? [String: String?], let light = primaryButtonBackgroundPressed["light"] as? String, let dark = primaryButtonBackgroundPressed["dark"] as? String {
            customTheme.primaryButton.backgroundPressed = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let primaryButtonBackgroundPressed = customizations["primaryButtonBackgroundPressed"] as? String {
            customTheme.primaryButton.backgroundPressed = Jumio.Theme.Value(UIColor(hexString: primaryButtonBackgroundPressed))
        }

        if let primaryButtonBackgroundDisabled = customizations["primaryButtonBackgroundDisabled"] as? [String: String?], let light = primaryButtonBackgroundDisabled["light"] as? String, let dark = primaryButtonBackgroundDisabled["dark"] as? String {
            customTheme.primaryButton.backgroundDisabled = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let primaryButtonBackgroundDisabled = customizations["primaryButtonBackgroundDisabled"] as? String {
            customTheme.primaryButton.backgroundDisabled = Jumio.Theme.Value(UIColor(hexString: primaryButtonBackgroundDisabled))
        }

        if let primaryButtonText = customizations["primaryButtonText"] as? [String: String?], let light = primaryButtonText["light"] as? String, let dark = primaryButtonText["dark"] as? String {
            customTheme.primaryButton.text = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let primaryButtonText = customizations["primaryButtonText"] as? String {
            customTheme.primaryButton.text = Jumio.Theme.Value(UIColor(hexString: primaryButtonText))
        }

        if let secondaryButtonBackground = customizations["secondaryButtonBackground"] as? [String: String?], let light = secondaryButtonBackground["light"] as? String, let dark = secondaryButtonBackground["dark"] as? String {
            customTheme.secondaryButton.background = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let secondaryButtonBackground = customizations["secondaryButtonBackground"] as? String {
            customTheme.secondaryButton.background = Jumio.Theme.Value(UIColor(hexString: secondaryButtonBackground))
        }

        if let secondaryButtonBackgroundPressed = customizations["secondaryButtonBackgroundPressed"] as? [String: String?], let light = secondaryButtonBackgroundPressed["light"] as? String, let dark = secondaryButtonBackgroundPressed["dark"] as? String {
            customTheme.secondaryButton.backgroundPressed = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let secondaryButtonBackgroundPressed = customizations["secondaryButtonBackgroundPressed"] as? String {
            customTheme.secondaryButton.backgroundPressed = Jumio.Theme.Value(UIColor(hexString: secondaryButtonBackgroundPressed))
        }

        if let secondaryButtonBackgroundDisabled = customizations["secondaryButtonBackgroundDisabled"] as? [String: String?], let light = secondaryButtonBackgroundDisabled["light"] as? String, let dark = secondaryButtonBackgroundDisabled["dark"] as? String {
            customTheme.secondaryButton.backgroundDisabled = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let secondaryButtonBackgroundDisabled = customizations["secondaryButtonBackgroundDisabled"] as? String {
            customTheme.secondaryButton.backgroundDisabled = Jumio.Theme.Value(UIColor(hexString: secondaryButtonBackgroundDisabled))
        }

        if let secondaryButtonText = customizations["secondaryButtonText"] as? [String: String?], let light = secondaryButtonText["light"] as? String, let dark = secondaryButtonText["dark"] as? String {
            customTheme.secondaryButton.text = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let secondaryButtonText = customizations["secondaryButtonText"] as? String {
            customTheme.secondaryButton.text = Jumio.Theme.Value(UIColor(hexString: secondaryButtonText))
        }

        // Bubble, Circle and Selection Icon
        if let bubbleBackground = customizations["bubbleBackground"] as? [String: String?], let light = bubbleBackground["light"] as? String, let dark = bubbleBackground["dark"] as? String {
            customTheme.bubble.background = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let bubbleBackground = customizations["bubbleBackground"] as? String {
            customTheme.bubble.background = Jumio.Theme.Value(UIColor(hexString: bubbleBackground))
        }

        if let bubbleForeground = customizations["bubbleForeground"] as? [String: String?], let light = bubbleForeground["light"] as? String, let dark = bubbleForeground["dark"] as? String {
            customTheme.bubble.foreground = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let bubbleForeground = customizations["bubbleForeground"] as? String {
            customTheme.bubble.foreground = Jumio.Theme.Value(UIColor(hexString: bubbleForeground))
        }

        if let bubbleBackgroundSelected = customizations["bubbleBackgroundSelected"] as? [String: String?], let light = bubbleBackgroundSelected["light"] as? String, let dark = bubbleBackgroundSelected["dark"] as? String {
            customTheme.bubble.backgroundSelected = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let bubbleBackgroundSelected = customizations["bubbleBackgroundSelected"] as? String {
            customTheme.bubble.backgroundSelected = Jumio.Theme.Value(UIColor(hexString: bubbleBackgroundSelected))
        }

        if let bubbleCircleItemForeground = customizations["bubbleCircleItemForeground"] as? [String: String?], let light = bubbleCircleItemForeground["light"] as? String, let dark = bubbleCircleItemForeground["dark"] as? String {
            customTheme.bubble.circleItemForeground = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let bubbleCircleItemForeground = customizations["bubbleCircleItemForeground"] as? String {
            customTheme.bubble.circleItemForeground = Jumio.Theme.Value(UIColor(hexString: bubbleCircleItemForeground))
        }

        if let bubbleCircleItemBackground = customizations["bubbleCircleItemBackground"] as? [String: String?], let light = bubbleCircleItemBackground["light"] as? String, let dark = bubbleCircleItemBackground["dark"] as? String {
            customTheme.bubble.circleItemBackground = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let bubbleCircleItemBackground = customizations["bubbleCircleItemBackground"] as? String {
            customTheme.bubble.circleItemBackground = Jumio.Theme.Value(UIColor(hexString: bubbleCircleItemBackground))
        }

        if let bubbleSelectionIconForeground = customizations["bubbleSelectionIconForeground"] as? [String: String?], let light = bubbleSelectionIconForeground["light"] as? String, let dark = bubbleSelectionIconForeground["dark"] as? String {
            customTheme.bubble.selectionIconForeground = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let bubbleSelectionIconForeground = customizations["bubbleSelectionIconForeground"] as? String {
            customTheme.bubble.selectionIconForeground = Jumio.Theme.Value(UIColor(hexString: bubbleSelectionIconForeground))
        }

        // Loading, Error
        if let loadingCirclePlain = customizations["loadingCirclePlain"] as? [String: String?], let light = loadingCirclePlain["light"] as? String, let dark = loadingCirclePlain["dark"] as? String {
            customTheme.loading.circlePlain = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let loadingCirclePlain = customizations["loadingCirclePlain"] as? String {
            customTheme.loading.circlePlain = Jumio.Theme.Value(UIColor(hexString: loadingCirclePlain))
        }

        if let loadingCircleGradientStart = customizations["loadingCircleGradientStart"] as? [String: String?], let light = loadingCircleGradientStart["light"] as? String, let dark = loadingCircleGradientStart["dark"] as? String {
            customTheme.loading.loadingCircleGradientStart = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let loadingCircleGradientStart = customizations["loadingCircleGradientStart"] as? String {
            customTheme.loading.loadingCircleGradientStart = Jumio.Theme.Value(UIColor(hexString: loadingCircleGradientStart))
        }

        if let loadingCircleGradientEnd = customizations["loadingCircleGradientEnd"] as? [String: String?], let light = loadingCircleGradientEnd["light"] as? String, let dark = loadingCircleGradientEnd["dark"] as? String {
            customTheme.loading.loadingCircleGradientEnd = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let loadingCircleGradientEnd = customizations["loadingCircleGradientEnd"] as? String {
            customTheme.loading.loadingCircleGradientEnd = Jumio.Theme.Value(UIColor(hexString: loadingCircleGradientEnd))
        }

        if let loadingErrorCircleGradientStart = customizations["loadingErrorCircleGradientStart"] as? [String: String?], let light = loadingErrorCircleGradientStart["light"] as? String, let dark = loadingErrorCircleGradientStart["dark"] as? String {
            customTheme.loading.errorCircleGradientStart = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let loadingErrorCircleGradientStart = customizations["loadingErrorCircleGradientStart"] as? String {
            customTheme.loading.errorCircleGradientStart = Jumio.Theme.Value(UIColor(hexString: loadingErrorCircleGradientStart))
        }

        if let loadingErrorCircleGradientEnd = customizations["loadingErrorCircleGradientEnd"] as? [String: String?], let light = loadingErrorCircleGradientEnd["light"] as? String, let dark = loadingErrorCircleGradientEnd["dark"] as? String {
            customTheme.loading.errorCircleGradientEnd = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let loadingErrorCircleGradientEnd = customizations["loadingErrorCircleGradientEnd"] as? String {
            customTheme.loading.errorCircleGradientEnd = Jumio.Theme.Value(UIColor(hexString: loadingErrorCircleGradientEnd))
        }

        if let loadingCircleIcon = customizations["loadingCircleIcon"] as? [String: String?], let light = loadingCircleIcon["light"] as? String, let dark = loadingCircleIcon["dark"] as? String {
            customTheme.loading.circleIcon = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let loadingCircleIcon = customizations["loadingCircleIcon"] as? String {
            customTheme.loading.circleIcon = Jumio.Theme.Value(UIColor(hexString: loadingCircleIcon))
        }

        // Scan Overlay
        if let scanOverlay = customizations["scanOverlay"] as? [String: String?], let light = scanOverlay["light"] as? String, let dark = scanOverlay["dark"] as? String {
            customTheme.scanOverlay.scanOverlay = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let scanOverlay = customizations["scanOverlay"] as? String {
            customTheme.scanOverlay.scanOverlay = Jumio.Theme.Value(UIColor(hexString: scanOverlay))
        }

        if let scanOverlayFill = customizations["scanOverlayFill"] as? [String: String?], let light = scanOverlayFill["light"] as? String, let dark = scanOverlayFill["dark"] as? String {
            customTheme.scanOverlay.fill = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let scanOverlayFill = customizations["scanOverlayFill"] as? String {
            customTheme.scanOverlay.fill = Jumio.Theme.Value(UIColor(hexString: scanOverlayFill))
        }

        if let scanOverlayTransparent = customizations["scanOverlayTransparent"] as? [String: String?], let light = scanOverlayTransparent["light"] as? String, let dark = scanOverlayTransparent["dark"] as? String {
            customTheme.scanOverlay.scanOverlayTransparent = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let scanOverlayTransparent = customizations["scanOverlayTransparent"] as? String {
            customTheme.scanOverlay.scanOverlayTransparent = Jumio.Theme.Value(UIColor(hexString: scanOverlayTransparent))
        }

        if let scanOverlayBackground = customizations["scanOverlayBackground"] as? [String: String?], let light = scanOverlayBackground["light"] as? String, let dark = scanOverlayBackground["dark"] as? String {
            customTheme.scanOverlay.scanBackground = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let scanOverlayBackground = customizations["scanOverlayBackground"] as? String {
            customTheme.scanOverlay.scanBackground = Jumio.Theme.Value(UIColor(hexString: scanOverlayBackground))
        }

        // NFC
        if let nfcPassportCover = customizations["nfcPassportCover"] as? [String: String?], let light = nfcPassportCover["light"] as? String, let dark = nfcPassportCover["dark"] as? String {
            customTheme.nfc.passportCover = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let nfcPassportCover = customizations["nfcPassportCover"] as? String {
            customTheme.nfc.passportCover = Jumio.Theme.Value(UIColor(hexString: nfcPassportCover))
        }

        if let nfcPassportPageDark = customizations["nfcPassportPageDark"] as? [String: String?], let light = nfcPassportPageDark["light"] as? String, let dark = nfcPassportPageDark["dark"] as? String {
            customTheme.nfc.passportPageDark = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let nfcPassportPageDark = customizations["nfcPassportPageDark"] as? String {
            customTheme.nfc.passportPageDark = Jumio.Theme.Value(UIColor(hexString: nfcPassportPageDark))
        }

        if let nfcPassportPageLight = customizations["nfcPassportPageLight"] as? [String: String?], let light = nfcPassportPageLight["light"] as? String, let dark = nfcPassportPageLight["dark"] as? String {
            customTheme.nfc.passportPageLight = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let nfcPassportPageLight = customizations["nfcPassportPageLight"] as? String {
            customTheme.nfc.passportPageLight = Jumio.Theme.Value(UIColor(hexString: nfcPassportPageLight))
        }

        if let nfcPassportForeground = customizations["nfcPassportForeground"] as? [String: String?], let light = nfcPassportForeground["light"] as? String, let dark = nfcPassportForeground["dark"] as? String {
            customTheme.nfc.passportForeground = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let nfcPassportForeground = customizations["nfcPassportForeground"] as? String {
            customTheme.nfc.passportForeground = Jumio.Theme.Value(UIColor(hexString: nfcPassportForeground))
        }

        if let nfcPhoneCover = customizations["nfcPhoneCover"] as? [String: String?], let light = nfcPhoneCover["light"] as? String, let dark = nfcPhoneCover["dark"] as? String {
            customTheme.nfc.phoneCover = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let nfcPhoneCover = customizations["nfcPhoneCover"] as? String {
            customTheme.nfc.phoneCover = Jumio.Theme.Value(UIColor(hexString: nfcPhoneCover))
        }

        // ScanView
        if let scanViewBubbleForeground = customizations["scanViewBubbleForeground"] as? [String: String?], let light = scanViewBubbleForeground["light"] as? String, let dark = scanViewBubbleForeground["dark"] as? String {
            customTheme.scanView.bubbleForeground = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let scanViewBubbleForeground = customizations["scanViewBubbleForeground"] as? String {
            customTheme.scanView.bubbleForeground = Jumio.Theme.Value(UIColor(hexString: scanViewBubbleForeground))
        }

        if let scanViewBubbleBackground = customizations["scanViewBubbleBackground"] as? [String: String?], let light = scanViewBubbleBackground["light"] as? String, let dark = scanViewBubbleBackground["dark"] as? String {
            customTheme.scanView.bubbleBackground = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let scanViewBubbleBackground = customizations["scanViewBubbleBackground"] as? String {
            customTheme.scanView.bubbleBackground = Jumio.Theme.Value(UIColor(hexString: scanViewBubbleBackground))
        }

        if let scanViewForeground = customizations["scanViewForeground"] as? [String: String?], let light = scanViewForeground["light"] as? String, let dark = scanViewForeground["dark"] as? String {
            customTheme.scanView.foreground = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let scanViewForeground = customizations["scanViewForeground"] as? String {
            customTheme.scanView.foreground = Jumio.Theme.Value(UIColor(hexString: scanViewForeground))
        }

        if let scanViewAnimationBackground = customizations["scanViewAnimationBackground"] as? [String: String?], let light = scanViewAnimationBackground["light"] as? String, let dark = scanViewAnimationBackground["dark"] as? String {
            customTheme.scanView.animationBackground = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let scanViewAnimationBackground = customizations["scanViewAnimationBackground"] as? String {
            customTheme.scanView.animationBackground = Jumio.Theme.Value(UIColor(hexString: scanViewAnimationBackground))
        }

        if let scanViewAnimationShutter = customizations["scanViewAnimationShutter"] as? [String: String?], let light = scanViewAnimationShutter["light"] as? String, let dark = scanViewAnimationShutter["dark"] as? String {
            customTheme.scanView.shutter = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let scanViewAnimationShutter = customizations["scanViewAnimationShutter"] as? String {
            customTheme.scanView.shutter = Jumio.Theme.Value(UIColor(hexString: scanViewAnimationShutter))
        }

        // Search Bubble
        if let searchBubbleBackground = customizations["searchBubbleBackground"] as? [String: String?], let light = searchBubbleBackground["light"] as? String, let dark = searchBubbleBackground["dark"] as? String {
            customTheme.searchBubble.background = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let searchBubbleBackground = customizations["searchBubbleBackground"] as? String {
            customTheme.searchBubble.background = Jumio.Theme.Value(UIColor(hexString: searchBubbleBackground))
        }

        if let searchBubbleForeground = customizations["searchBubbleForeground"] as? [String: String?], let light = searchBubbleForeground["light"] as? String, let dark = searchBubbleForeground["dark"] as? String {
            customTheme.searchBubble.foreground = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let searchBubbleForeground = customizations["searchBubbleForeground"] as? String {
            customTheme.searchBubble.foreground = Jumio.Theme.Value(UIColor(hexString: searchBubbleForeground))
        }

        if let searchBubbleListItemSelected = customizations["searchBubbleListItemSelected"] as? [String: String?], let light = searchBubbleListItemSelected["light"] as? String, let dark = searchBubbleListItemSelected["dark"] as? String {
            customTheme.searchBubble.listItemSelected = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let searchBubbleListItemSelected = customizations["searchBubbleListItemSelected"] as? String {
            customTheme.searchBubble.listItemSelected = Jumio.Theme.Value(UIColor(hexString: searchBubbleListItemSelected))
        }
        
        // Confirmation
        if let confirmationImageBackground = customizations["confirmationImageBackground"] as? [String: String?], let light = confirmationImageBackground["light"] as? String, let dark = confirmationImageBackground["dark"] as? String {
            customTheme.confirmation.imageBackground = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let confirmationImageBackground = customizations["confirmationImageBackground"] as? String {
            customTheme.confirmation.imageBackground = Jumio.Theme.Value(UIColor(hexString: confirmationImageBackground))
        }
        
        if let confirmationImageBackgroundBorder = customizations["confirmationImageBackgroundBorder"] as? [String: String?], let light = confirmationImageBackgroundBorder["light"] as? String, let dark = confirmationImageBackgroundBorder["dark"] as? String {
            customTheme.confirmation.imageBackgroundBorder = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let confirmationImageBackgroundBorder = customizations["confirmationImageBackgroundBorder"] as? String {
            customTheme.confirmation.imageBackgroundBorder = Jumio.Theme.Value(UIColor(hexString: confirmationImageBackgroundBorder))
        }
        
        if let confirmationIndicatorActive = customizations["confirmationIndicatorActive"] as? [String: String?], let light = confirmationIndicatorActive["light"] as? String, let dark = confirmationIndicatorActive["dark"] as? String {
            customTheme.confirmation.indicatorActive = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let confirmationIndicatorActive = customizations["confirmationIndicatorActive"] as? String {
            customTheme.confirmation.indicatorActive = Jumio.Theme.Value(UIColor(hexString: confirmationIndicatorActive))
        }
        
        if let confirmationIndicatorDefault = customizations["confirmationIndicatorDefault"] as? [String: String?], let light = confirmationIndicatorDefault["light"] as? String, let dark = confirmationIndicatorDefault["dark"] as? String {
            customTheme.confirmation.indicatorDefault = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let confirmationIndicatorDefault = customizations["confirmationIndicatorDefault"] as? String {
            customTheme.confirmation.indicatorDefault = Jumio.Theme.Value(UIColor(hexString: confirmationIndicatorDefault))
        }

        // Global
        if let background = customizations["background"] as? [String: String?], let light = background["light"] as? String, let dark = background["dark"] as? String {
            customTheme.background = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let background = customizations["background"] as? String {
            customTheme.background = Jumio.Theme.Value(UIColor(hexString: background))
        }

        if let navigationIconColor = customizations["navigationIconColor"] as? [String: String?], let light = navigationIconColor["light"] as? String, let dark = navigationIconColor["dark"] as? String {
            customTheme.navigationIconColor = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let navigationIconColor = customizations["navigationIconColor"] as? String {
            customTheme.navigationIconColor = Jumio.Theme.Value(UIColor(hexString: navigationIconColor))
        }

        if let textForegroundColor = customizations["textForegroundColor"] as? [String: String?], let light = textForegroundColor["light"] as? String, let dark = textForegroundColor["dark"] as? String {
            customTheme.textForegroundColor = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let textForegroundColor = customizations["textForegroundColor"] as? String {
            customTheme.textForegroundColor = Jumio.Theme.Value(UIColor(hexString: textForegroundColor))
        }

        if let primaryColor = customizations["primaryColor"] as? [String: String?], let light = primaryColor["light"] as? String, let dark = primaryColor["dark"] as? String {
            customTheme.primaryColor = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let primaryColor = customizations["primaryColor"] as? String {
            customTheme.primaryColor = Jumio.Theme.Value(UIColor(hexString: primaryColor))
        }

        return customTheme
    }
}

import Jumio

extension JumioMobileSDK {
    func customizeSDKColors(customizations: [String: Any?]) -> Jumio.Theme {
        var customTheme = Jumio.Theme()
        
        // Face
        if let facePrimary = customizations["facePrimary"] as? [String: String?], let light = facePrimary["light"] as? String, let dark = facePrimary["dark"] as? String {
            customTheme.face.primary = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let facePrimary = customizations["facePrimary"] as? String {
            customTheme.face.primary = Jumio.Theme.Value(UIColor(hexString: facePrimary))
        }
        
        if let faceSecondary = customizations["faceSecondary"] as? [String: String?], let light = faceSecondary["light"] as? String, let dark = faceSecondary["dark"] as? String {
            customTheme.face.secondary = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let faceSecondary = customizations["faceSecondary"] as? String {
            customTheme.face.secondary = Jumio.Theme.Value(UIColor(hexString: faceSecondary))
        }
        
        if let faceOutline = customizations["faceOutline"] as? [String: String?], let light = faceOutline["light"] as? String, let dark = faceOutline["dark"] as? String {
            customTheme.face.outline = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let faceOutline = customizations["faceOutline"] as? String {
            customTheme.face.outline = Jumio.Theme.Value(UIColor(hexString: faceOutline))
        }

        // ScanHelp
        if let faceAnimationForeground = customizations["faceAnimationForeground"] as? [String: String?], let light = faceAnimationForeground["light"] as? String, let dark = faceAnimationForeground["dark"] as? String {
            customTheme.scanHelp.faceAnimationForeground = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let faceAnimationForeground = customizations["faceAnimationForeground"] as? String {
            customTheme.scanHelp.faceAnimationForeground = Jumio.Theme.Value(UIColor(hexString: faceAnimationForeground))
        }
    
        // IProov
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

        if let primaryButtonForeground = customizations["primaryButtonForeground"] as? [String: String?], let light = primaryButtonForeground["light"] as? String, let dark = primaryButtonForeground["dark"] as? String {
            customTheme.primaryButton.foreground = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let primaryButtonForeground = customizations["primaryButtonForeground"] as? String {
            customTheme.primaryButton.foreground = Jumio.Theme.Value(UIColor(hexString: primaryButtonForeground))
        }
        
        if let primaryButtonForegroundPressed = customizations["primaryButtonForegroundPressed"] as? [String: String?], let light = primaryButtonForegroundPressed["light"] as? String, let dark = primaryButtonForegroundPressed["dark"] as? String {
            customTheme.primaryButton.foregroundPressed = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let primaryButtonForegroundPressed = customizations["primaryButtonForegroundPressed"] as? String {
            customTheme.primaryButton.foregroundPressed = Jumio.Theme.Value(UIColor(hexString: primaryButtonForegroundPressed))
        }
        
        if let primaryButtonForegroundDisabled = customizations["primaryButtonForegroundDisabled"] as? [String: String?], let light = primaryButtonForegroundDisabled["light"] as? String, let dark = primaryButtonForegroundDisabled["dark"] as? String {
            customTheme.primaryButton.foregroundDisabled = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let primaryButtonForegroundDisabled = customizations["primaryButtonForegroundDisabled"] as? String {
            customTheme.primaryButton.foregroundDisabled = Jumio.Theme.Value(UIColor(hexString: primaryButtonForegroundDisabled))
        }
        
        if let primaryButtonOutline = customizations["primaryButtonOutline"] as? [String: String?], let light = primaryButtonOutline["light"] as? String, let dark = primaryButtonOutline["dark"] as? String {
            customTheme.primaryButton.outline = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let primaryButtonOutline = customizations["primaryButtonOutline"] as? String {
            customTheme.primaryButton.outline = Jumio.Theme.Value(UIColor(hexString: primaryButtonOutline))
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

        if let secondaryButtonForeground = customizations["secondaryButtonForeground"] as? [String: String?], let light = secondaryButtonForeground["light"] as? String, let dark = secondaryButtonForeground["dark"] as? String {
            customTheme.secondaryButton.foreground = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let secondaryButtonForeground = customizations["secondaryButtonForeground"] as? String {
            customTheme.secondaryButton.foreground = Jumio.Theme.Value(UIColor(hexString: secondaryButtonForeground))
        }
        
        if let secondaryButtonForegroundPressed = customizations["secondaryButtonForegroundPressed"] as? [String: String?], let light = secondaryButtonForegroundPressed["light"] as? String, let dark = secondaryButtonForegroundPressed["dark"] as? String {
            customTheme.secondaryButton.foregroundPressed = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let secondaryButtonForegroundPressed = customizations["secondaryButtonForegroundPressed"] as? String {
            customTheme.secondaryButton.foregroundPressed = Jumio.Theme.Value(UIColor(hexString: secondaryButtonForegroundPressed))
        }
        
        if let secondaryButtonForegroundDisabled = customizations["secondaryButtonForegroundDisabled"] as? [String: String?], let light = secondaryButtonForegroundDisabled["light"] as? String, let dark = secondaryButtonForegroundDisabled["dark"] as? String {
            customTheme.secondaryButton.foregroundDisabled = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let secondaryButtonForegroundDisabled = customizations["secondaryButtonForegroundDisabled"] as? String {
            customTheme.secondaryButton.foregroundDisabled = Jumio.Theme.Value(UIColor(hexString: secondaryButtonForegroundDisabled))
        }
        
        if let secondaryButtonOutline = customizations["secondaryButtonOutline"] as? [String: String?], let light = secondaryButtonOutline["light"] as? String, let dark = secondaryButtonOutline["dark"] as? String {
            customTheme.secondaryButton.outline = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let secondaryButtonOutline = customizations["secondaryButtonOutline"] as? String {
            customTheme.secondaryButton.outline = Jumio.Theme.Value(UIColor(hexString: secondaryButtonOutline))
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

        if let bubbleOutline = customizations["bubbleOutline"] as? [String: String?], let light = bubbleOutline["light"] as? String, let dark = bubbleOutline["dark"] as? String {
            customTheme.bubble.outline = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let bubbleOutline = customizations["bubbleOutline"] as? String {
            customTheme.bubble.outline = Jumio.Theme.Value(UIColor(hexString: bubbleOutline))
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

        if let scanOverlayBackground = customizations["scanOverlayBackground"] as? [String: String?], let light = scanOverlayBackground["light"] as? String, let dark = scanOverlayBackground["dark"] as? String {
            customTheme.scanOverlay.scanBackground = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let scanOverlayBackground = customizations["scanOverlayBackground"] as? String {
            customTheme.scanOverlay.scanBackground = Jumio.Theme.Value(UIColor(hexString: scanOverlayBackground))
        }

        if let scanOverlayLivenessStroke = customizations["scanOverlayLivenessStroke"] as? [String: String?], let light = scanOverlayLivenessStroke["light"] as? String, let dark = scanOverlayLivenessStroke["dark"] as? String {
            customTheme.scanOverlay.livenessStroke = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let scanOverlayLivenessStroke = customizations["scanOverlayLivenessStroke"] as? String {
            customTheme.scanOverlay.livenessStroke = Jumio.Theme.Value(UIColor(hexString: scanOverlayLivenessStroke))
        }

        if let scanOverlayLivenessStrokeAnimation = customizations["scanOverlayLivenessStrokeAnimation"] as? [String: String?], let light = scanOverlayLivenessStrokeAnimation["light"] as? String, let dark = scanOverlayLivenessStrokeAnimation["dark"] as? String {
            customTheme.scanOverlay.livenessStrokeAnimation = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let scanOverlayLivenessStrokeAnimation = customizations["scanOverlayLivenessStrokeAnimation"] as? String {
            customTheme.scanOverlay.livenessStrokeAnimation = Jumio.Theme.Value(UIColor(hexString: scanOverlayLivenessStrokeAnimation))
        }

        if let scanOverlayLivenessStrokeAnimationCompleted = customizations["scanOverlayLivenessStrokeAnimationCompleted"] as? [String: String?], let light = scanOverlayLivenessStrokeAnimationCompleted["light"] as? String, let dark = scanOverlayLivenessStrokeAnimationCompleted["dark"] as? String {
            customTheme.scanOverlay.livenessStrokeAnimationCompleted = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let scanOverlayLivenessStrokeAnimationCompleted = customizations["scanOverlayLivenessStrokeAnimationCompleted"] as? String {
            customTheme.scanOverlay.livenessStrokeAnimationCompleted = Jumio.Theme.Value(UIColor(hexString: scanOverlayLivenessStrokeAnimationCompleted))
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

        if let nfcPhoneScreen = customizations["nfcPhoneScreen"] as? [String: String?], let light = nfcPhoneScreen["light"] as? String, let dark = nfcPhoneScreen["dark"] as? String {
            customTheme.nfc.phoneScreen = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let nfcPhoneScreen = customizations["nfcPhoneScreen"] as? String {
            customTheme.nfc.phoneScreen = Jumio.Theme.Value(UIColor(hexString: nfcPhoneScreen))
        }

        if let nfcChipPrimary = customizations["nfcChipPrimary"] as? [String: String?], let light = nfcChipPrimary["light"] as? String, let dark = nfcChipPrimary["dark"] as? String {
            customTheme.nfc.chipPrimary = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let nfcChipPrimary = customizations["nfcChipPrimary"] as? String {
            customTheme.nfc.chipPrimary = Jumio.Theme.Value(UIColor(hexString: nfcChipPrimary))
        }

        if let nfcChipSecondary = customizations["nfcChipSecondary"] as? [String: String?], let light = nfcChipSecondary["light"] as? String, let dark = nfcChipSecondary["dark"] as? String {
            customTheme.nfc.chipSecondary = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let nfcChipSecondary = customizations["nfcChipSecondary"] as? String {
            customTheme.nfc.chipSecondary = Jumio.Theme.Value(UIColor(hexString: nfcChipSecondary))
        }
        
        if let nfcChipGlow = customizations["nfcChipGlow"] as? [String: String?], let light = nfcChipGlow["light"] as? String, let dark = nfcChipGlow["dark"] as? String {
            customTheme.nfc.chipGlow = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let nfcChipGlow = customizations["nfcChipGlow"] as? String {
            customTheme.nfc.chipGlow = Jumio.Theme.Value(UIColor(hexString: nfcChipGlow))
        }

        if let nfcPulse = customizations["nfcPulse"] as? [String: String?], let light = nfcPulse["light"] as? String, let dark = nfcPulse["dark"] as? String {
            customTheme.nfc.pulse = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let nfcPulse = customizations["nfcPulse"] as? String {
            customTheme.nfc.pulse = Jumio.Theme.Value(UIColor(hexString: nfcPulse))
        }

        // ScanView
        if let scanViewTooltipForeground = customizations["scanViewTooltipForeground"] as? [String: String?], let light = scanViewTooltipForeground["light"] as? String, let dark = scanViewTooltipForeground["dark"] as? String {
            customTheme.scanView.tooltipForeground = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let scanViewTooltipForeground = customizations["scanViewTooltipForeground"] as? String {
            customTheme.scanView.tooltipForeground = Jumio.Theme.Value(UIColor(hexString: scanViewTooltipForeground))
        }

        if let scanViewTooltipBackground = customizations["scanViewTooltipBackground"] as? [String: String?], let light = scanViewTooltipBackground["light"] as? String, let dark = scanViewTooltipBackground["dark"] as? String {
            customTheme.scanView.tooltipBackground = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let scanViewTooltipBackground = customizations["scanViewTooltipBackground"] as? String {
            customTheme.scanView.tooltipBackground = Jumio.Theme.Value(UIColor(hexString: scanViewTooltipBackground))
        }

        if let scanViewForeground = customizations["scanViewForeground"] as? [String: String?], let light = scanViewForeground["light"] as? String, let dark = scanViewForeground["dark"] as? String {
            customTheme.scanView.foreground = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let scanViewForeground = customizations["scanViewForeground"] as? String {
            customTheme.scanView.foreground = Jumio.Theme.Value(UIColor(hexString: scanViewForeground))
        }

        if let scanViewDocumentShutter = customizations["scanViewDocumentShutter"] as? [String: String?], let light = scanViewDocumentShutter["light"] as? String, let dark = scanViewDocumentShutter["dark"] as? String {
            customTheme.scanView.documentShutter = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let scanViewDocumentShutter = customizations["scanViewDocumentShutter"] as? String {
            customTheme.scanView.documentShutter = Jumio.Theme.Value(UIColor(hexString: scanViewDocumentShutter))
        }
        
        if let scanViewFaceShutter = customizations["scanViewFaceShutter"] as? [String: String?], let light = scanViewFaceShutter["light"] as? String, let dark = scanViewFaceShutter["dark"] as? String {
            customTheme.scanView.faceShutter = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let scanViewFaceShutter = customizations["scanViewFaceShutter"] as? String {
            customTheme.scanView.faceShutter = Jumio.Theme.Value(UIColor(hexString: scanViewFaceShutter))
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
        
        if let searchBubbleOutline = customizations["searchBubbleOutline"] as? [String: String?], let light = searchBubbleOutline["light"] as? String, let dark = searchBubbleOutline["dark"] as? String {
            customTheme.searchBubble.outline = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let searchBubbleOutline = customizations["searchBubbleOutline"] as? String {
            customTheme.searchBubble.outline = Jumio.Theme.Value(UIColor(hexString: searchBubbleOutline))
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
        
        if let confirmationImageBorder = customizations["confirmationImageBorder"] as? [String: String?], let light = confirmationImageBorder["light"] as? String, let dark = confirmationImageBorder["dark"] as? String {
            customTheme.confirmation.imageBorder = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let confirmationImageBorder = customizations["confirmationImageBorder"] as? String {
            customTheme.confirmation.imageBorder = Jumio.Theme.Value(UIColor(hexString: confirmationImageBorder))
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
        
        if let selectionIconForeground = customizations["selectionIconForeground"] as? [String: String?], let light = selectionIconForeground["light"] as? String, let dark = selectionIconForeground["dark"] as? String {
            customTheme.selectionIconForeground = Jumio.Theme.Value(light: UIColor(hexString: light), dark: UIColor(hexString: dark))
        } else if let selectionIconForeground = customizations["selectionIconForeground"] as? String {
            customTheme.selectionIconForeground = Jumio.Theme.Value(UIColor(hexString: selectionIconForeground))
        }

        return customTheme
    }
}

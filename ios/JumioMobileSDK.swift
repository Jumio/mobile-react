//
//  JumioMobileSDK.swift
//  JumioReactMobileSdk
//
//  Copyright © 2021 Jumio Corporation All rights reserved.
//

import Jumio
import UIKit

@objc(JumioMobileSDK)
class JumioMobileSDK: RCTEventEmitter {
    fileprivate var jumio: Jumio.SDK?
    fileprivate var jumioVC: Jumio.ViewController?
    fileprivate var customizations: [String: Any?]?
    fileprivate var preloaderFinishedBlock: RCTResponseSenderBlock?

    override func supportedEvents() -> [String]! {
        return ["EventError", "EventResult"]
    }

    override static func requiresMainQueueSetup() -> Bool {
        return true
    }

    @objc func initialize(_ token: String, dataCenter: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
        let validDataCenter = getJumioDataCenter(dataCenter)

        if validDataCenter == nil {
            reject("ERROR", "Invalid Datacenter value.", nil)
            return
        }

        if token.isEmpty {
            reject("ERROR", "Missing required parameters one-time session authorization token.", nil)
            return
        }

        jumio = Jumio.SDK()
        jumio?.defaultUIDelegate = self
        jumio?.token = token
        jumio?.dataCenter = validDataCenter
        jumio?.setResourcesBundle(Bundle.main)

        resolve("Initialized")
    }

    @objc func setupCustomizations(_ customizations: NSDictionary?) {
        if let customizations = customizations as? [String: Any?] {
            self.customizations = customizations
        }
    }

    @objc func start() {
        DispatchQueue.main.sync { [weak self] in
            guard let weakself = self, let jumio = jumio else { return }

            jumio.startDefaultUI()

            // Check if customization argument is added
            if let customizations = weakself.customizations {
                let customTheme = customizeSDKColors(customizations: customizations)
                jumio.customize(theme: customTheme)
            }

            weakself.jumioVC = try? jumio.viewController()

            guard let jumioVC = weakself.jumioVC else { return }

            jumioVC.modalPresentationStyle = .fullScreen

            guard let rootViewController = UIApplication.shared.windows.first?.rootViewController
            else { return }

            rootViewController.present(jumioVC, animated: true)
        }
    }

    @objc func isRooted(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
        resolve(Jumio.SDK.isJailbroken)
    }
    
    @objc func setPreloaderFinishedBlock(_ completion: @escaping RCTResponseSenderBlock) {
        Jumio.Preloader.shared.delegate = self
        preloaderFinishedBlock = completion
    }

    @objc func preloadIfNeeded() {
        Jumio.Preloader.shared.preloadIfNeeded()
    }

    @objc func checkCachedResult() {
    }

    private func getJumioDataCenter(_ dataCenter: String) -> Jumio.DataCenter? {
        switch dataCenter.lowercased() {
        case "eu":
            return .EU
        case "sg":
            return .SG
        case "us":
            return .US
        default:
            return nil
        }
    }

    private func getIDResult(idResult: Jumio.IDResult) -> [String: Any] {
        let result: [String: Any?] = [
            "selectedCountry": idResult.country,
            "selectedDocumentType": idResult.idType,
            "selectedDocumentSubType":idResult.idSubType,
            "idNumber": idResult.documentNumber,
            "personalNumber": idResult.personalNumber,
            "issuingDate": idResult.issuingDate,
            "expiryDate": idResult.expiryDate,
            "issuingCountry": idResult.issuingCountry,
            "firstName": idResult.firstName,
            "lastName": idResult.lastName,
            "gender": idResult.gender,
            "nationality": idResult.nationality,
            "dateOfBirth": idResult.dateOfBirth,
            "addressLine": idResult.address,
            "city": idResult.city,
            "subdivision": idResult.subdivision,
            "postCode": idResult.postalCode,
            "placeOfBirth": idResult.placeOfBirth,
            "mrzLine1": idResult.mrzLine1,
            "mrzLine2": idResult.mrzLine2,
            "mrzLine3": idResult.mrzLine3,
        ]

        return result.compactMapValues { $0 }
    }

    private func getFaceResult(faceResult: Jumio.FaceResult) -> [String: Any] {
        let result: [String: Any?] = [
            "passed": (faceResult.passed ?? false) ? "true" : "false",
        ]

        return result.compactMapValues { $0 }
    }
}

extension JumioMobileSDK: Jumio.DefaultUIDelegate {
    func jumio(sdk: Jumio.SDK, finished result: Jumio.Result) {
        jumioVC?.dismiss(animated: true) { [weak self] in
            guard let weakself = self else { return }

            weakself.jumioVC = nil
            weakself.jumio = nil
            weakself.customizations = nil

            weakself.handleResult(jumioResult: result)
        }
    }

    private func handleResult(jumioResult: Jumio.Result) {
        let accountId = jumioResult.accountId
        let authenticationResult = jumioResult.isSuccess
        let credentialInfos = jumioResult.credentialInfos
        let workflowId = jumioResult.workflowExecutionId

        if authenticationResult == true {
            var body: [String: Any?] = [
                "accountId": accountId,
                "workflowId": workflowId,
            ]
            var credentialArray = [[String: Any?]]()

            credentialInfos.forEach { credentialInfo in
                var eventResultMap: [String: Any?] = [
                    "credentialId": credentialInfo.id,
                    "credentialCategory": "\(credentialInfo.category)",
                ]

                switch credentialInfo.category {
                case .id:
                    if let idResult = jumioResult.getIDResult(of: credentialInfo) {
                        eventResultMap = eventResultMap.merging(getIDResult(idResult: idResult), uniquingKeysWith: { first, _ in first })
                    }
                case .face:
                    if let faceResult = jumioResult.getFaceResult(of: credentialInfo) {
                        eventResultMap = eventResultMap.merging(getFaceResult(faceResult: faceResult), uniquingKeysWith: { first, _ in first })
                    }
                default:
                    break
                }

                credentialArray.append(eventResultMap)
            }
            body["credentials"] = credentialArray

            sendEvent(withName: "EventResult", body: body)
        } else {
            guard let error = jumioResult.error else { return }
            let errorMessage = error.message
            let errorCode = error.code

            let body: [String: Any?] = [
                "errorCode": errorCode,
                "errorMessage": errorMessage,
            ]

            sendEvent(withName: "EventError", body: body)
        }
    }
}

extension JumioMobileSDK: Jumio.Preloader.Delegate {
    func jumio(finished: Jumio.Preloader) {
        preloaderFinishedBlock?([NSNull()])
    }
}

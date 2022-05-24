//
//  AppDelegate.swift
//  SecureKeychainCrash
//
//  Created by jefferson.setiawan on 20/05/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        var sacError: Unmanaged<CFError>?
        let sacObject = SecAccessControlCreateWithFlags(
            kCFAllocatorDefault,
            kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            .privateKeyUsage,
            &sacError
        )

        guard let sacObject = sacObject else {
            if let error = sacError?.takeUnretainedValue() {
                fatalError("errorCreatingSecAccessControl \(error.localizedDescription)")
            }
            fatalError("errorCreatingSecAccessControl \(sacError?.takeUnretainedValue().localizedDescription ?? "Unknown Error")")
            return true
        }
        let keyTag: String = "com.jefferson.seKey"
        let attributes: [String: Any] = [
            kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeySizeInBits as String: 256,
            kSecPrivateKeyAttrs as String: [
                kSecAttrAccessControl: sacObject,
                kSecAttrIsPermanent: true,
                kSecAttrApplicationTag: keyTag.data(using: .utf8)!
            ]
        ]

        var createKeyError: Unmanaged<CFError>?

        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &createKeyError) else {
            // failed to generate asymKey, so turn flag off
            fatalError("generateFailed \(createKeyError?.takeUnretainedValue().localizedDescription ?? "Unknown Error")")
        }
        print("privateKey created! \(privateKey)")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


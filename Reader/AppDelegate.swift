//
//  AppDelegate.swift
//  Reader
//
//  Created by Igor Kislyuk on 12/05/2018.
//  Copyright © 2018 Igor Kislyuk. All rights reserved.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var session: WCSession?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        setupWatchConnectivity()

        debugPrint("Application started")

        return true
    }

    func setupWatchConnectivity() {
        // 1
        if WCSession.isSupported() {
            // 2
            let session = WCSession.default
            // 3
            session.delegate = self
            // 4
            session.activate()

            self.session = session
        }
    }

}

extension AppDelegate: WCSessionDelegate {

    func sessionDidBecomeInactive(_ session: WCSession) {
    }

    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {

        if let error = error {
            print("WC Session activation failed with error: " +
                "\(error.localizedDescription)")
            return
        }

//        print("WC Session activated with state: " + activationState)
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        debugPrint(#function)

        print(message)
    }
}

import WatchKit
import WatchConnectivity

final class ExtensionDelegate: NSObject, WKExtensionDelegate {

    var session: WCSession?

    func applicationDidFinishLaunching() {
        setupWatchConnectivity()

        FileService.copyFileIfNeeded(name: .harryPotterFileName, fileExtension: .txtExtension)
        FileService.copyFileIfNeeded(name: .littleWomanFileName, fileExtension: .txtExtension)
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompletedWithSnapshot(false)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }

    func setupWatchConnectivity() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()

            if session.isReachable {
                let message = ["foo":"bar"]
                session.sendMessage(message, replyHandler: nil, errorHandler: { (error) -> Void in
                    print("send failed with error \(error)")
                })
            }

            self.session = session
        }
    }

}

extension ExtensionDelegate: WCSessionDelegate {

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {

        if let error = error {
            print("WC Session activation failed with error: " + "\(error.localizedDescription)")
            return
        }

        print("WC Session activated with state: " + "\(activationState)")
    }

    func session(_ session: WCSession,
                 didReceiveMessageData messageData: Data,
                 replyHandler: @escaping (Data) -> Swift.Void) {

        debugPrint(#function)

        if let string = String(data: messageData, encoding: .utf8) {
            StorageService.shared.strings = [string]
            // to main queue

        }
    }

    func reloadRootController() {
        DispatchQueue.main.async {
            WKInterfaceController.reloadRootPageControllers(withNames: ["RootController"], contexts: nil, orientation: .horizontal, pageIndex: 0)
        }
    }

//    func sessionReachabilityDidChange(_ session: WCSession) {
//        debugPrint(#function)
//    }
//
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//        debugPrint(#function)
//    }
//
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Swift.Void) {
//        debugPrint(#function)
//    }
//
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        debugPrint(#function)
        // convert to string
    }
//
//    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
//        debugPrint(#function)
//    }
//
//    func session(_ session: WCSession, didFinish userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {
//        debugPrint(#function)
//    }
//
//    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
//        debugPrint(#function)
//    }
//
//    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
//        debugPrint(#function)
//    }
//
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        debugPrint(#function)
    }
}

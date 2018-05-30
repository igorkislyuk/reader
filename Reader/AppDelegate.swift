import UIKit
import WatchConnectivity

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var session: WCSession?

    private(set) lazy var appWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        return window
    }()

    static var shared: AppDelegate {
        let delegate = UIApplication.shared.delegate
        guard let appDelegate = delegate as? AppDelegate else {
            fatalError("Cannot cast \(type(of: delegate)) to AppDelegate")
        }
        return appDelegate
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        debugPrint(#function)

        setupWatchConnectivity()

        if let launchOptions = launchOptions, let url = launchOptions[UIApplicationLaunchOptionsKey.url] as? URL {
            saveFile(url: url)
        } else {
            debugPrint("No url to save file.")
        }

        NavigationService.makeFilesRootController()

        return true
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {

        saveFile(url: url)

        return true
    }
}

private extension AppDelegate {
    func saveFile(url: URL) {
        NavigationService.presentTextFieldAlert { text in
            var newUrl = FileService.documentsDirectoryURL

            let fileName = text?.nilIfEmpty ?? FileService.nextDefaultFileName()

            newUrl.appendPathComponent(fileName)
            newUrl.appendPathExtension("txt")

            do {
                try FileService.manager.copyItem(at: url, to: newUrl)
            }
            catch {
                debugPrint(error)
            }
        }
    }

    func setupWatchConnectivity() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
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
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        debugPrint(#function)

        print(message)
    }
}

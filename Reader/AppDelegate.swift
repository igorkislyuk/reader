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
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        debugPrint(#function)

        setupWatchConnectivity()

        if let launchOptions = launchOptions, let url = launchOptions[UIApplication.LaunchOptionsKey.url] as? URL {
            saveFile(url: url)
        } else {
            debugPrint("No url to save file.")
        }

        NavigationService.makeFilesRootController()

        return true
    }


    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

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











public extension UIView {

    /**
     Place and fix view to parent view's center
     - parameter size: desired view size, by default size is equal parent's size
     */
    func setToCenter(withSize size: CGSize? = nil) {
        guard let parent = superview else {
            return
        }

        translatesAutoresizingMaskIntoConstraints = false

        guard let size = size else {
            scaleToFill()
            return
        }

        let constraints = [
            centerXAnchor.constraint(equalTo: parent.centerXAnchor),
            centerYAnchor.constraint(equalTo: parent.centerYAnchor),
            heightAnchor.constraint(equalToConstant: size.height),
            widthAnchor.constraint(equalToConstant: size.width)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    /**
     Place and fix view to parent view's center with insets
     - parameter insets: desired view insets, by default is zero
     - parameter edges: edges to which no constraints are needed
     */
    func pinToSuperview(with insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), excluding edges: UIRectEdge = []) {
        guard let superview = superview else {
            return
        }

        let topActive = !edges.contains(.top)
        let leadingActive = !edges.contains(.left)
        let bottomActive = !edges.contains(.bottom)
        let trailingActive = !edges.contains(.right)

        translatesAutoresizingMaskIntoConstraints = false

        if #available(iOS 11, tvOS 11, *) {
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: insets.top)
                .isActive = topActive
            leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: insets.left)
                .isActive = leadingActive
            bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom)
                .isActive = bottomActive
            trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: -insets.right)
                .isActive = trailingActive
        } else {
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top).isActive = topActive
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left).isActive = leadingActive
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom).isActive = bottomActive
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right).isActive = trailingActive
        }
    }

    private func scaleToFill() {
        guard let superview = superview else {
            return
        }

        let constraints: [NSLayoutConstraint]
        if #available(iOS 11, tvOS 11, *) {
            constraints = [
                topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor),
                bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor),
                leftAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leftAnchor),
                rightAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.rightAnchor)
            ]
        } else {
            constraints = [
                topAnchor.constraint(equalTo: superview.topAnchor),
                bottomAnchor.constraint(equalTo: superview.bottomAnchor),
                leftAnchor.constraint(equalTo: superview.leftAnchor),
                rightAnchor.constraint(equalTo: superview.rightAnchor)
            ]
        }

        NSLayoutConstraint.activate(constraints)
    }

}

extension String {

    /**
     Nil if empty representation
     - returns: nil if string empty, self otherwise
     */
    var nilIfEmpty: String? {
        return isEmpty ? nil : self
    }

}

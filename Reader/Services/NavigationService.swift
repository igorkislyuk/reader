import UIKit

typealias StringBlock = (String?) -> Void

struct NavigationService {

    static let appWindow = AppDelegate.shared.appWindow

    static var presentationViewController: UIViewController? {
        return appWindow.rootViewController?.topVisibleViewController is UIAlertController
            ? nil : appWindow.rootViewController?.topVisibleViewController
    }

    static func makeFilesRootController() {
        appWindow.changeRootController(controller: UINavigationController(rootViewController: createFilesViewController()), animated: false)
    }

    static func presentTextFieldAlert(closure: StringBlock? = nil) {
        let alertController = UIAlertController(title: "Enter file name",
                                                message: "",
                                                preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "File name"
        }

        let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
            guard let alertController = alertController, let textField = alertController.textFields?.first else { return }
            closure?(textField.text)
        }

        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        NavigationService.presentationViewController?.present(alertController, animated: true, completion: nil)
    }

}


extension UIViewController {

    /// Return top visible controller even if we have inner UI(Navigation/TabBar)Controller's inside
    var topVisibleViewController: UIViewController {
        switch self {
        case let navController as UINavigationController:
            return navController.visibleViewController?.topVisibleViewController ?? navController
        case let tabController as UITabBarController:
            return tabController.selectedViewController?.topVisibleViewController ?? tabController
        default:
            return self.presentedViewController?.topVisibleViewController ?? self
        }
    }

}


extension UIWindow {

    /// default scale
    static let snapshotScale: CGFloat = 1.5
    /// default root controller animation duration
    static let snapshotAnimationDuration = 0.5

    /// Method changes root controller in window.
    ///
    /// - Parameter controller: New root controller.
    /// - Parameter animated: Indicates whether to use animation or not.
    func changeRootController(controller: UIViewController, animated: Bool = true) {
        if animated {
            animateRootViewControllerChanging(controller: controller)
        }

        let previousRoot = rootViewController
        previousRoot?.dismiss(animated: false) {
            previousRoot?.view.removeFromSuperview()
        }

        rootViewController = controller
        makeKeyAndVisible()
    }

    /**
     method animates changing root controller
     - parameter controller: new root controller
     */
    private func animateRootViewControllerChanging(controller: UIViewController) {
        if let snapshot = snapshotView(afterScreenUpdates: true) {
            controller.view.addSubview(snapshot)
            UIView.animate(withDuration: UIWindow.snapshotAnimationDuration, animations: {
                snapshot.layer.opacity = 0.0
                snapshot.layer.transform = CATransform3DMakeScale(UIWindow.snapshotScale,
                                                                  UIWindow.snapshotScale,
                                                                  UIWindow.snapshotScale)
            }, completion: { _ in
                snapshot.removeFromSuperview()
            })
        }
    }

}

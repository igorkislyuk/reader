import UIKit

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

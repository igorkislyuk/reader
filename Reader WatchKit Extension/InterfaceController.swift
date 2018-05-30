import WatchKit
import Foundation

final class InterfaceController: WKInterfaceController {

    @IBOutlet private weak var table: WKInterfaceTable!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()


        table.setNumberOfRows(StorageService.shared.strings.count, withRowType: "TextRowController")

        StorageService.shared.strings.enumerated().forEach { (index, string) in
            if let controller = table.rowController(at: index) as? TextRowController {
                controller.textLabel?.setText(string)
            }
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func action() {
        guard let ext = (WKExtension.shared().delegate as? ExtensionDelegate) else {
            return
        }

        guard let session = ext.session else { return  }

        if session.isReachable {
            let message = ["foo":"bar"]
            session.sendMessage(message, replyHandler: nil, errorHandler: { (error) -> Void in
                print("send failed with error \(error)")
            })
        }
    }

}

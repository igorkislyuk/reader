import UIKit
import WatchConnectivity

class ViewController: UIViewController {

    @IBAction func action(_ sender: Any) {
        guard let ext = (UIApplication.shared.delegate as? AppDelegate) else {
            return
        }

        guard let session = ext.session else { return  }

       sendFile(session: session)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let session = (UIApplication.shared.delegate as? AppDelegate)?.session else {
            debugPrint("No session")
            return
        }

        sendFile(session: session)
    }

    func sendFile(session: WCSession) {
        let manager = FileManager()

        guard let path = Bundle.main.path(forResource: "HP", ofType: ".txt"), let data = manager.contents(atPath: path) else {
            debugPrint("No data")
            return
        }

        guard session.isWatchAppInstalled, session.isReachable, session.isPaired else {
            debugPrint("Something went wrong")
            return
        }

        session.sendMessageData(data, replyHandler: { (data) in
            debugPrint("reply handler")
        }, errorHandler: { (error) in
            debugPrint(error.localizedDescription)
        })
    }
}

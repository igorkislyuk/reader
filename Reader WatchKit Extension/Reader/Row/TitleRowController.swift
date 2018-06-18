import WatchKit

final class TitleRowController: NSObject {
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
}

extension TitleRowController: ReuseIdentifiable {
    static let reuseIdentifier = "TitleRowController"
}

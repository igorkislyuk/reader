import WatchKit

final class FilesInterfaceController: WKInterfaceController {
    @IBOutlet private weak var table: WKInterfaceTable!

    private var files: [String] = []

    override func willActivate() {
        super.willActivate()

        reloadFiles()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

    func reloadFiles() {
        files = FileService.allFiles()

        guard !files.isEmpty else {
            table.setNumberOfRows(1, withRowType: TitleRowController.reuseIdentifier)
            (table.rowController(at: 0) as? TitleRowController)?.titleLabel?.setText(String.noFilesTryAgain)

            return
        }

        table.setNumberOfRows(files.count, withRowType: TitleRowController.reuseIdentifier)

        files.enumerated().forEach { index, string in
            if let controller = table.rowController(at: index) as? TitleRowController {
                controller.titleLabel?.setText(string)
            }
        }
    }
}

extension FilesInterfaceController: ReuseIdentifiable {
    static let reuseIdentifier = "FilesInterfaceController"
}

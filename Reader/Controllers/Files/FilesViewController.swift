import UIKit
import WatchConnectivity
import SnapKit
import LeadKit
import TableKit

final class FilesViewController: BaseViewController<FilesViewModel> {

    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        self.view.addSubview(tableView)
        tableView.refreshControl = UIRefreshControl(frame: .zero)
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .primaryActionTriggered)
        return tableView
    }()

    private lazy var tableDirector = TableDirector(tableView: tableView)

    override func updateViewConstraints() {

        tableView.snp.remakeConstraints { (make) in
            make.center.width.height.equalToSuperview()
        }

        super.updateViewConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initialLoadView()

        FileService.copyIfNeeded(file: "HP", fileExtension: "txt")

//        reconfigureTable()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        reconfigureTable()
    }

    @objc private func action() {
        trySendFile()
    }

    @objc private func refresh() {
        reconfigureTable()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}

private extension FilesViewController {
    func reconfigureTable() {
        let rows: [Row] = FileService.allFiles()
            .map { fileName in
                return TableRow<FileCell>(item: FileCellViewModel(fileName: fileName))
                }

        let section = TableSection(onlyRows: rows)
        tableDirector.replace(withSection: section)
    }
}

private extension FilesViewController {
    func trySendFile() {
        guard let session = AppDelegate.shared.session else {
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

extension FilesViewController: ConfigurableController {
    func configureBarButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Action",
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(action))
    }

    func configureAppearance() {
        navigationController?.navigationBar.prefersLargeTitles = true

        view.backgroundColor = .white
    }

    func addViews() {}

    func bindViews() {}

    func localize() {
        title = "Files"
    }
}

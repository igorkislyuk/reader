import UIKit
import WatchConnectivity

final class FilesViewController: BaseViewController<FilesViewModel>, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView(frame: .zero, style: .plain)

    private var files = FileService.allFiles()

    override func viewDidLoad() {
        super.viewDidLoad()

        initialLoadView()

        FileService.copyFileIfNeeded(name: .harryPotterFileName, fileExtension: .txtExtension)
        FileService.copyFileIfNeeded(name: .littleWomanFileName, fileExtension: .txtExtension)
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

    // MARK: - UITableViewDelegate, UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FileCell.reuseIdentifier) as! FileCell

        cell.configure(with: FileCellViewModel.init(fileName: files[indexPath.row]))

        return cell
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: UIContextualAction.Style.destructive, title: "Delete") { (action, view, closure) in
            closure(FileService.deleteFile(with: self.files[indexPath.row]))
        }

        let configuration = UISwipeActionsConfiguration.init(actions: [deleteAction])

        return configuration
    }
}

private extension FilesViewController {
    func reconfigureTable() {
        files = FileService.allFiles()
        tableView.reloadData()
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

        tableView.refreshControl = UIRefreshControl(frame: .zero)
        tableView.register(FileCell.self, forCellReuseIdentifier: FileCell.reuseIdentifier)
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .primaryActionTriggered)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }

    func addViews() {
        view.addSubview(tableView)
        tableView.pinToSuperview()
    }

    func bindViews() {}

    func localize() {
        title = "Files"
    }
}

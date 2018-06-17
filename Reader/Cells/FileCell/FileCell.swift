import UIKit

final class FileCell: UITableViewCell, InitializableView {

    private let fileLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        initializeView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        defer { super.updateConstraints() }

        fileLabel.pinToSuperview()
    }
}

extension FileCell: ReuseIdentifiable {
    static var reuseIdentifier: String {
        return "FileCell"
    }
}

extension FileCell {
    func addViews() {
        contentView.addSubview(fileLabel)
    }

    func configureAppearance() {
        fileLabel.font = UIFont.systemFont(ofSize: 25)
        fileLabel.textColor = UIColor.black
    }
}

extension FileCell {
    func configure(with vm: FileCellViewModel) {
        fileLabel.text = vm.fileName
    }
}

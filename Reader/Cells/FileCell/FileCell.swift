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

        fileLabel.pinToSuperview(with: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
    }
}

extension FileCell: ReuseIdentifiable {
    static let reuseIdentifier = "FileCell"
}

extension FileCell {
    func addViews() {
        contentView.addSubview(fileLabel)
    }

    func configureAppearance() {
        fileLabel.font = .systemFont(ofSize: 24)
        fileLabel.textColor = .black
        fileLabel.numberOfLines = 0
    }
}

extension FileCell {
    func configure(with vm: FileCellViewModel) {
        fileLabel.text = vm.fileName

        setNeedsLayout()
    }
}

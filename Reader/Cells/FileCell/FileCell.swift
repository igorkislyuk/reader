import UIKit
import TableKit
import SnapKit
import LeadKit

final class FileCell: UITableViewCell, InitializableView {

    private let fileLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        initializeView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        defer { super.updateConstraints() }

        fileLabel.snp.remakeConstraints { (make) in
            make.leadingMargin.trailingMargin.centerY.centerX.equalToSuperview()
        }
    }
}

extension FileCell {
    func addViews() {

        contentView.addSubview(fileLabel)

        setNeedsUpdateConstraints()
    }

    func configureAppearance() {
        fileLabel.font = UIFont.systemFont(ofSize: 14)
        fileLabel.textColor = UIColor.black
    }
}

extension FileCell: ConfigurableCell {
    func configure(with vm: FileCellViewModel) {
        fileLabel.text = vm.fileName
    }
}

import UIKit

protocol InitializableView {
    func initializeView()
    func addViews()
    func bindViews()
    func configureAppearance()
    func localize()
}

extension InitializableView {
    func initializeView() {
        addViews()
        configureAppearance()
        localize()
        bindViews()
    }

    func addViews() {}
    func configureAppearance() {}
    func localize() {}
    func bindViews() {}
}



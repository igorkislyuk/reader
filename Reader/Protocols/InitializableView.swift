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



protocol ConfigurableController: InitializableView {

    associatedtype ViewModelT

    var viewModel: ViewModelT { get }

    func configureBarButtons()

    func initialLoadView()

}

extension ConfigurableController where Self: UIViewController {

    func configureBarButtons() {
        // nothing
    }

    func initialLoadView() {
        addViews()
        configureAppearance()
        configureBarButtons()
        localize()
        bindViews()
    }

}

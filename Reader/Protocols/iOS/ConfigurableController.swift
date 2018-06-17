import UIKit

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

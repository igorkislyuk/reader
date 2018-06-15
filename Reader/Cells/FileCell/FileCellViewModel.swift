import Foundation

struct FileCellViewModel {
    let fileName: String
}

protocol ConfigurableView {
    associatedtype ViewModelType
    func configure(with _: ViewModelType)
}

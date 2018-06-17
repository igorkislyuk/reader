import UIKit

extension UIView {

    func pinToSuperview(with insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                        excluding edges: UIRectEdge = []) {

        guard let superview = superview else {
            return
        }

        let topActive = !edges.contains(.top)
        let leadingActive = !edges.contains(.left)
        let bottomActive = !edges.contains(.bottom)
        let trailingActive = !edges.contains(.right)

        translatesAutoresizingMaskIntoConstraints = false

        topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: insets.top)
            .isActive = topActive
        leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: insets.left)
            .isActive = leadingActive
        bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom)
            .isActive = bottomActive
        trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: -insets.right)
            .isActive = trailingActive
    }

}

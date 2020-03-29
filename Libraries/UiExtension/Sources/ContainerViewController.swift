import UIKit

public protocol ContainerViewProtocol: UIViewController {
    var view: UIView! { get set }
    func unload()
    func loadViewController(_ viewController: UIViewController)
}

extension ContainerViewProtocol {
    public func unload() {
        children.forEach { vc in
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
    }

    public func loadViewController(_ viewController: UIViewController) {
        unload()
        doLoadViewController(viewController)
    }

    private func doLoadViewController(_ viewController: UIViewController) {
        addChild(viewController)

        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewController.view)
        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        viewController.didMove(toParent: self)
    }
}

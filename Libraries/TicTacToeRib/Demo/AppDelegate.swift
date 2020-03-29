import TicTacToeRib
import UIKit

@UIApplicationMain
class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let nav = UINavigationController()
        let viewController = TicTacToeViewController(player1Name: "P1", player2Name: "P2")

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()

        nav.present(viewController, animated: true)

        DispatchQueue.main.async {
            viewController.setCell(atRow: 0, col: 0, withPlayerType: .player1)
            viewController.setCell(atRow: 0, col: 1, withPlayerType: .player2)
            viewController.setCell(atRow: 0, col: 2, withPlayerType: .player1)
            viewController.setCell(atRow: 1, col: 1, withPlayerType: .player2)
            viewController.setCell(atRow: 2, col: 2, withPlayerType: .player2)
        }

        return true
    }
}

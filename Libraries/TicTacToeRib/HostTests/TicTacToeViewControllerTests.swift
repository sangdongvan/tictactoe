import SnapshotTesting
import TicTacToeRib
import XCTest

class TicTacToeViewControllerTests: XCTestCase {

    var vc: TicTacToeViewController!

    override func setUp() {
        super.setUp()
        vc = TicTacToeViewController(player1Name: "P1", player2Name: "P2")
    }

    func testSelectCell() {
        /// it supposes to trigger rendering on View Controller with assertion as .hierarchy
        /// before run testing snapshot as .image.
        assertSnapshot(matching: vc, as: .hierarchy)

        vc.setCell(atRow: 0, col: 0, withPlayerType: .player1)
        vc.setCell(atRow: 0, col: 2, withPlayerType: .player2)
        assertSnapshot(matching: vc, as: .image)
    }

    func testAnounceWinner() {
        vc.announce(winner: .player1) {}

        XCTAssertNotNil(vc.alert)
        assertSnapshot(matching: vc.alert!.view, as: .image)
    }
}

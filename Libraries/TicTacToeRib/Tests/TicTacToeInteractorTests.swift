import Models
import RxSwift
import TicTacToeRib
import XCTest

class TicTacToeInteractorTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    func test_Player1_WinRow() {
        let scoreStream = ScoreStreamImpl()

        let presenterMock = TicTacToePresentableMock()

        let interactor = TicTacToeInteractor(
            presenter: presenterMock,
            mutableScoreStream: scoreStream)

        var actualWinner: PlayerType?
        presenterMock.announceHandler = { (winner: PlayerType?, handler: @escaping () -> Void) in
            actualWinner = winner
        }

        interactor.didBecomeActive()
        interactor.placeCurrentPlayerMark(atRow: 0, col: 0)
        interactor.placeCurrentPlayerMark(atRow: 1, col: 0)
        interactor.placeCurrentPlayerMark(atRow: 0, col: 1)
        interactor.placeCurrentPlayerMark(atRow: 1, col: 1)
        interactor.placeCurrentPlayerMark(atRow: 0, col: 2)

        XCTAssertEqual(5, presenterMock.setCellCallCount)
        XCTAssertEqual(1, presenterMock.announceCallCount)
        XCTAssertEqual(PlayerType.player1, actualWinner)
    }
}

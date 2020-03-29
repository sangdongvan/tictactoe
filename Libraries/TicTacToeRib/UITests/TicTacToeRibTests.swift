import XCTest

class TicTacToeRibTests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }

    override func tearDown() {
        app.terminate()
        super.tearDown()
    }

    func testInitialiseGame() {
        let collectionViewsQuery = XCUIApplication().collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: 0).children(
            matching: .other
        ).element.tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 1).children(
            matching: .other
        ).element.tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 5).children(
            matching: .other
        ).element.tap()
    }
}

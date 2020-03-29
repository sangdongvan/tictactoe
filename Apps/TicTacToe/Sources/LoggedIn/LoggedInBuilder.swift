//
//  Copyright (c) 2017. Uber Technologies
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Models
import NeedleFoundation
import RIBs
import RIBsExtension
import TicTacToeRib

protocol LoggedInDependency: NeedleFoundation.Dependency {
    var loggedInViewController: LoggedInViewControllable { get }
}

final class LoggedInComponent: NeedleFoundation.Component<LoggedInDependency> {

    var loggedInViewController: LoggedInViewControllable {
        return dependency.loggedInViewController
    }

    fileprivate func games(player1Name: String, player2Name: String) -> [Game] {
        return shared {
            return [
                RandomWinAdapter {
                    self.randomWinComponent(player1Name: player1Name, player2Name: player2Name)
                },
                TicTacToeAdapter {
                    self.ticTacToeComponent(player1Name: player1Name, player2Name: player2Name)
                },
            ]
        }
    }

    var mutableScoreStream: MutableScoreStream {
        return shared { ScoreStreamImpl() }
    }

    var scoreStream: ScoreStream {
        return mutableScoreStream
    }

    func offGameComponent(player1Name: String, player2Name: String) -> OffGameComponent {
        return OffGameComponent(
            parent: self,
            player1Name: player1Name,
            player2Name: player2Name)
    }

    func randomWinComponent(player1Name: String, player2Name: String) -> RandomWinComponent {
        return RandomWinComponent(
            parent: self,
            player1Name: player1Name,
            player2Name: player2Name)
    }

    func ticTacToeComponent(player1Name: String, player2Name: String) -> TicTacToeComponent {
        return TicTacToeComponent(
            parent: self,
            player1Name: player1Name,
            player2Name: player2Name)
    }
}

// MARK: - Builder

protocol LoggedInBuildable: Buildable {
    func build(withListener listener: LoggedInListener, player1Name: String, player2Name: String)
        -> (router: LoggedInRouting, actionableItem: LoggedInActionableItem)
}

final class LoggedInBuilder: NeedleBuilder<LoggedInComponent>, LoggedInBuildable {

    func build(withListener listener: LoggedInListener, player1Name: String, player2Name: String)
        -> (router: LoggedInRouting, actionableItem: LoggedInActionableItem)
    {
        let component = componentBuilder()

        let interactor = LoggedInInteractor(
            games: component.games(player1Name: player1Name, player2Name: player2Name))
        interactor.listener = listener

        let offGameBuilder = OffGameBuilder {
            component.offGameComponent(player1Name: player1Name, player2Name: player2Name)
        }
        let router = LoggedInRouter(
            interactor: interactor,
            viewController: component.loggedInViewController,
            offGameBuilder: offGameBuilder)
        return (router, interactor)
    }
}

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

public protocol OffGameDependency: NeedleFoundation.Dependency {
    var scoreStream: ScoreStream { get }
}

public final class OffGameComponent: NeedleFoundation.Component<OffGameDependency>,
    BasicScoreBoardDependency
{

    public var scoreStream: ScoreStream {
        return dependency.scoreStream
    }

    let player1Name: String
    let player2Name: String

    public init(parent: Scope, player1Name: String, player2Name: String) {
        self.player1Name = player1Name
        self.player2Name = player2Name
        super.init(parent: parent)
    }

    func basicScoreBoardComponent(player1Name: String, player2Name: String)
        -> BasicScoreBoardComponent
    {
        return BasicScoreBoardComponent(
            parent: self, player1Name: player1Name, player2Name: player2Name)
    }
}

// MARK: - Builder

protocol OffGameBuildable: Buildable {
    func build(withListener listener: OffGameListener, games: [Game]) -> OffGameRouting
}

final class OffGameBuilder: NeedleBuilder<OffGameComponent>, OffGameBuildable {

    func build(withListener listener: OffGameListener, games: [Game]) -> OffGameRouting {
        let component = componentBuilder()
        let viewController = OffGameViewController(games: games)
        let interactor = OffGameInteractor(presenter: viewController)
        interactor.listener = listener

        let scoreBoardBuilder = BasicScoreBoardBuilder {
            component.basicScoreBoardComponent(
                player1Name: component.player1Name, player2Name: component.player2Name)
        }
        let router = OffGameRouter(
            interactor: interactor,
            viewController: viewController,
            scoreBoardBuilder: scoreBoardBuilder)
        return router
    }
}

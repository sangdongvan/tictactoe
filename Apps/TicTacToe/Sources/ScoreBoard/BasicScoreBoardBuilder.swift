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

public protocol BasicScoreBoardDependency: NeedleFoundation.Dependency {
    var scoreStream: ScoreStream { get }
}

public final class BasicScoreBoardComponent: NeedleFoundation.Component<BasicScoreBoardDependency> {

    let player1Name: String
    let player2Name: String

    public init(parent: Scope, player1Name: String, player2Name: String) {
        self.player1Name = player1Name
        self.player2Name = player2Name
        super.init(parent: parent)
    }

    fileprivate var scoreStream: ScoreStream {
        return dependency.scoreStream
    }
}

// MARK: - Builder

protocol BasicScoreBoardBuildable: Buildable {
    func build(withListener listener: BasicScoreBoardListener) -> BasicScoreBoardRouting
}

public final class BasicScoreBoardBuilder: NeedleBuilder<BasicScoreBoardComponent>,
    BasicScoreBoardBuildable
{

    public func build(withListener listener: BasicScoreBoardListener) -> BasicScoreBoardRouting {
        let component = componentBuilder()
        let viewController = BasicScoreBoardViewController(
            player1Name: component.player1Name,
            player2Name: component.player2Name)
        let interactor = BasicScoreBoardInteractor(
            presenter: viewController,
            scoreStream: component.scoreStream)
        interactor.listener = listener
        return BasicScoreBoardRouter(interactor: interactor, viewController: viewController)
    }
}

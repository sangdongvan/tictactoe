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

import NeedleFoundation
import RIBs
import RIBsExtension

final class RootComponent: NeedleFoundation.BootstrapComponent {

    var rootViewController: RootViewController {
        return shared {
            RootViewController()
        }
    }

    var loggedInViewController: LoggedInViewControllable {
        return rootViewController
    }

    var loggedOutComponent: LoggedOutComponent {
        return LoggedOutComponent(parent: self)
    }

    var loggedInComponent: LoggedInComponent {
        return LoggedInComponent(parent: self)
    }
}

// MARK: - Builder

protocol RootBuildable: Buildable {
    func build() -> (launchRouter: LaunchRouting, urlHandler: UrlHandler)
}

final class RootBuilder: NeedleBuilder<RootComponent>, RootBuildable {

    func build() -> (launchRouter: LaunchRouting, urlHandler: UrlHandler) {
        let component: RootComponent = componentBuilder()

        let interactor = RootInteractor(presenter: component.rootViewController)

        let loggedOutBuilder = LoggedOutBuilder {
            component.loggedOutComponent
        }

        let loggedInBuilder = LoggedInBuilder {
            component.loggedInComponent
        }

        let router = RootRouter(
            interactor: interactor,
            viewController: component.rootViewController,
            loggedOutBuilder: loggedOutBuilder,
            loggedInBuilder: loggedInBuilder)

        return (router, interactor)
    }
}

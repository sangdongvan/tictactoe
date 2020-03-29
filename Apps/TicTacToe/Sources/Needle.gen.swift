

import Models
import NeedleFoundation
import RIBs
import RIBsExtension
import TicTacToeRib

// MARK: - Registration

public func registerProviderFactories() {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->LoggedInComponent->OffGameComponent") { component in
        return OffGameDependency19a483c7a4199f31827fProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->LoggedInComponent->RandomWinComponent") { component in
        return RandomWinDependencydf572f38235b3dd4a3ffProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->LoggedOutComponent") { component in
        return LoggedOutDependencyacada53ea78d270efa2fProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->LoggedInComponent->OffGameComponent->BasicScoreBoardComponent") { component in
        return BasicScoreBoardDependencyf7a6523db2b81246d441Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->LoggedInComponent") { component in
        return LoggedInDependency637c07bfce1b5ccf0a6eProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent") { component in
        return EmptyDependencyProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->LoggedInComponent->TicTacToeComponent") { component in
        return TicTacToeDependency116f7b2429d569089340Provider(component: component)
    }
    
}

// MARK: - Providers

/// ^->RootComponent->LoggedInComponent->OffGameComponent
private class OffGameDependency19a483c7a4199f31827fProvider: OffGameDependency {
    var scoreStream: ScoreStream {
        return loggedInComponent.scoreStream
    }
    private let loggedInComponent: LoggedInComponent
    init(component: NeedleFoundation.Scope) {
        loggedInComponent = component.parent as! LoggedInComponent
    }
}
/// ^->RootComponent->LoggedInComponent->RandomWinComponent
private class RandomWinDependencydf572f38235b3dd4a3ffProvider: RandomWinDependency {
    var mutableScoreStream: MutableScoreStream {
        return loggedInComponent.mutableScoreStream
    }
    private let loggedInComponent: LoggedInComponent
    init(component: NeedleFoundation.Scope) {
        loggedInComponent = component.parent as! LoggedInComponent
    }
}
/// ^->RootComponent->LoggedOutComponent
private class LoggedOutDependencyacada53ea78d270efa2fProvider: LoggedOutDependency {


    init(component: NeedleFoundation.Scope) {

    }
}
/// ^->RootComponent->LoggedInComponent->OffGameComponent->BasicScoreBoardComponent
private class BasicScoreBoardDependencyf7a6523db2b81246d441Provider: BasicScoreBoardDependency {
    var scoreStream: ScoreStream {
        return offGameComponent.scoreStream
    }
    private let offGameComponent: OffGameComponent
    init(component: NeedleFoundation.Scope) {
        offGameComponent = component.parent as! OffGameComponent
    }
}
/// ^->RootComponent->LoggedInComponent
private class LoggedInDependency637c07bfce1b5ccf0a6eProvider: LoggedInDependency {
    var loggedInViewController: LoggedInViewControllable {
        return rootComponent.loggedInViewController
    }
    private let rootComponent: RootComponent
    init(component: NeedleFoundation.Scope) {
        rootComponent = component.parent as! RootComponent
    }
}
/// ^->RootComponent->LoggedInComponent->TicTacToeComponent
private class TicTacToeDependency116f7b2429d569089340Provider: TicTacToeDependency {
    var mutableScoreStream: MutableScoreStream {
        return loggedInComponent.mutableScoreStream
    }
    private let loggedInComponent: LoggedInComponent
    init(component: NeedleFoundation.Scope) {
        loggedInComponent = component.parent as! LoggedInComponent
    }
}

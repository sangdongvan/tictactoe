import RIBs

// MARK: - RIBsTreeViewer

#if DEBUG
    import RIBsTreeViewerClient

    @available(iOS 13.0, *)
    var RIBsTreeViewerHolder: RIBsTreeViewer? = nil

    extension AppDelegate {
        func startRIBsTreeViewer(launchRouter: Routing) {
            if #available(iOS 13.0, *) {
                RIBsTreeViewerHolder = RIBsTreeViewerImpl.init(
                    router: launchRouter,
                    options: [.webSocketURL("ws://0.0.0.0:8080"), .monitoringIntervalMillis(1000)]
                )
                RIBsTreeViewerHolder?.start()
            } else {
                print("RIBsTreeViewer is not supported OS version.")
            }
        }
    }
#endif

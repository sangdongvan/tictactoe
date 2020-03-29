# Set the platform globally
platform :ios, '10.0'

# Only download the files, don't create Xcode projects
install! 'cocoapods', integrate_targets: false

target 'Superide' do
  pod 'PromiseKit/CorePromise', '6.1.1'
  pod 'PromiseKit/CoreLocation', '6.1.1'

  # uber/needle got issue with Carthage installation, need to revise later.
  pod 'NeedleFoundation', '0.12.0'
end

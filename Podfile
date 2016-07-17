# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'PokeFinder' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'Alamofire', '~> 3.4'
  pod 'SwiftyJSON'



  # Pods for PokeFinder

  target 'PokeFinderTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PokeFinderUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end

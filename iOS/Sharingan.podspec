Pod::Spec.new do |s|
  s.name         = "Sharingan"
  s.version      = "0.1.3"
  s.summary      = "A UI record and play framework for iOS"

  s.homepage     = "https://github.com/shaotianchi/Sharingan"

  s.license      = "MIT"

  s.author       = { "EscapedDog" => "escapeddog@gmail.com" }

  s.platform     = :ios, 8.0

  s.source       = { :git => "https://github.com/shaotianchi/Sharingan.git", :tag => "#{s.version}" }

  s.requires_arc = true

  s.default_subspec = 'Recorder'

  s.subspec 'Model' do |ss|
    ss.source_files = "iOS/SharinganModel/**/*.{h,swift}"
  end

  s.subspec 'Recorder' do |ss| 
    ss.source_files = "iOS/SharinganRecorder/**/*.{h,swift}"
  end 
end

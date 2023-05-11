Pod::Spec.new do |spec|

  spec.name         = "EDCarousel"
  spec.version      = "0.0.1"
  spec.summary      = "A library for overlapping style carousel collection view flow layout"
  spec.description  = "A custom library for overlapping style carousel collection view flow layout"
  spec.homepage     = "https://github.com/emrdgrmnci/EDCarousel"
  spec.license      = "MIT"
  spec.author             = { "Emre" => "degirmenci.a.emre@gmail.com" }
  spec.platform     = :ios, "15.0"
  spec.source       = { :git =>  "https://github.com/emrdgrmnci/EDCarousel.git", :tag => spec.version.to_s }
  spec.source_files  = "EDCarousel/**/*.{swift}"
  spec.swift_versions = "5.0"
end

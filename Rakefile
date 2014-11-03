desc 'Build AdHoc ipa'
task :build do
  plist = 'tixing/Resources/Other-Sources/tixing-Info.plist'
  version = `/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" #{plist}`.strip
  build = `/usr/libexec/PlistBuddy -c "Print CFBundleVersion" #{plist}`.strip
  dest = "~/Desktop/tixing-#{version}/#{build}"

  sh "ipa build --configuration AdHoc --destination #{dest}" do  |ok, res|
    if ok
      sh "ipa info #{dest}/tixing.ipa"
      sh "open #{dest}"
    end
  end
end


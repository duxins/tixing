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

namespace :sound do
  def convert(mp3, caf)
    puts "Converting #{mp3} -> #{caf}"
    system(%Q{afconvert -f caff -d LEI16 -c 1 '#{mp3}' '#{caf}'})
  end

  desc 'Convert .mp3 to .caf'
  task :convert do
    directory = input 'Directory', '~/Desktop/sound'
    directory = File.expand_path(directory, __FILE__)

    Dir.chdir(directory) do 
      Dir.glob("*.mp3").each do |mp3|
        caf = mp3.gsub(/\.mp3/, '.caf')
        convert(mp3, caf)     
      end
      system('open .')
    end
  end
end

def input prompt, default
  print "#{prompt}: [#{default}] "
  value = $stdin.readline.chop
  value = default if value.empty?
  value
end

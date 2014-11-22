require 'json'
load 'config.rb' if File.exists?('config.rb')

def version_number
  `/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" tixing/Resources/Other-Sources/tixing-Info.plist`.chomp
end

def build_number
  build = `/usr/libexec/PlistBuddy -c "Print CFBundleVersion" tixing/Resources/Other-Sources/tixing-Info.plist`.chomp
end

desc 'Build AdHoc ipa'
task :build do
  system("ipa build --configuration AdHoc") or raise '** BUILD FAILED **'
end

namespace :distribute do
  desc 'Upload .ipa file to fir.im'
  task fir: :build do
    token = $fir_token
    short = 'tixing'
    bundle_id = 'com.duxinx.tixing'
    app_url = "http://fir.im/#{short}/info"
    ipa_path = './tixing.ipa'

    info_url = "http://fir.im/api/v2/app/info/#{bundle_id}?token=#{token}"
    output = `curl -s #{info_url}`
    json = JSON.parse(output)

    raise '** INVALID TOKEN **' unless json['short'] == short

    app_id = json['id']
    upload_url = json['bundle']['pkg']['url']
    pkg_key = json['bundle']['pkg']['key']
    pkg_token = json['bundle']['pkg']['token']

    puts "Uploading #{ipa_path} (#{version_number}.#{build_number}) ... "
    output = `curl --progress-bar -F file=@#{ipa_path} -F key='#{pkg_key}' -F token='#{pkg_token}' #{upload_url}`
    json = JSON.parse(output)

    output = `curl -s -X PUT -H 'Content-Length: 0' -L 'http://fir.im/api/v2/app/#{app_id}?token=#{token}&version=#{build_number}&versionShort=#{version_number}'`
    json = JSON.parse(output)
    `open -e #{app_url}`
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

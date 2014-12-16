require 'json'
require 'yaml'


def version_number
  `/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" tixing/Resources/Other-Sources/tixing-Info.plist`.chomp
end

def build_number
  `/usr/libexec/PlistBuddy -c "Print CFBundleVersion" tixing/Resources/Other-Sources/tixing-Info.plist`.chomp
end

task :default => :test do
end

desc 'Run unit tests'
task :test do
  cmd = "xctool -workspace tixing.xcworkspace -scheme 'tixing' clean test -sdk iphonesimulator"
  system(cmd)
end

desc 'Build AdHoc ipa'
task :build do
  system("bundle exec ipa build --configuration AdHoc -s tixing") or raise '** BUILD FAILED **'
end

namespace :fir do
  #FIXME: 使用企业证书重签名后，keychain 读写失败
  task resign: :build  do
    system("bundle exec fir publish ./tixing.ipa -r") or raise '** RESIGN FAILED **'
  end

  desc 'Upload .ipa file to fir.im'
  task upload: :build do
    config_file = File.expand_path('~/.fir/default.yaml')
    config = YAML.load_file(config_file) if File.exists?(config_file)
    #system("bundle exec fir publish ./tixing.ipa") or raise '** UPLOAD FAILED **'
    raise 'Fir token not found' if config['token'].nil?
    token = config['token']
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

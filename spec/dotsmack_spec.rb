require 'dotsmack'

describe Dotsmack, '#fnmatch?' do
  it 'is more intuitive than File.fnmatch?' do
    expect(File.fnmatch?('embiggened/', 'examples/twitch/test/embiggened/')).to eq(false)
    expect(Dotsmack::fnmatch?('embiggened/', 'examples/twitch/test/embiggened/')).to eq(true)

    expect(File.fnmatch?('embiggened/', 'examples/twitch/test/embiggened/beginning-programming-with-java-for-dummies.txt')).to eq(false)
    expect(Dotsmack::fnmatch?('embiggened/', 'examples/twitch/test/embiggened/beginning-programming-with-java-for-dummies.txt')).to eq(true)

    expect(File.fnmatch?('.twitchignore', 'examples/twitch/test/bigconfigs/.twitchignore')).to eq(false)
    expect(Dotsmack::fnmatch?('.twitchignore', 'examples/twitch/test/bigconfigs/.twitchignore')).to eq(true)

    expect(File.fnmatch?('*.{bat,ps1}', 'hello.bat')).to eq(false)
    expect(Dotsmack::fnmatch?('*.{bat,ps1}', 'hello.bat')).to eq(true)

    expect(File.fnmatch?('target', 'target/')).to eq(false)
    expect(Dotsmack::fnmatch?('target', 'target/')).to eq(true)
  end
end

require 'dotsmack'

describe Dotsmack, '#fnmatch?' do
  it 'is more intuitive than File.fnmatch?' do
    expect(File.fnmatch?('embiggened/', 'examples/twitch/test/embiggened/')).to eq(false)
    expect(Dotsmack::fnmatch?('embiggened/', 'examples/twitch/test/embiggened/')).to eq(true)

    expect(File.fnmatch?('embiggened/', 'examples/twitch/test/embiggened/beginning-programming-with-java-for-dummies.txt')).to eq(false)
    expect(Dotsmack::fnmatch?('embiggened/', 'examples/twitch/test/embiggened/beginning-programming-with-java-for-dummies.txt')).to eq(true)
  end
end

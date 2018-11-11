Given(/^the program has finished$/) do
    @cucumber_twitch = `examples/twitch/bin/twitch examples/twitch/test/`
    @cucumber_twitch_stdin = `examples/twitch/bin/twitch < examples/twitch/test/a-tale-of-two-cities.txt`
end

Then(/^the output is correct for each test$/) do
    cucumber_twitch = @cucumber_twitch.split("\n")
    expect(cucumber_twitch.length).to eq(1)
    expect(cucumber_twitch[0]).to match(%r(^examples/twitch/test/a-tale-of-two-cities.txt\: .+$))

    cucumber_twitch_stdin = @cucumber_twitch_stdin.split("\n")
    expect(cucumber_twitch_stdin.length).to eq(1)
    expect(cucumber_twitch_stdin[0]).to match(%r(^-\: .+$))
end

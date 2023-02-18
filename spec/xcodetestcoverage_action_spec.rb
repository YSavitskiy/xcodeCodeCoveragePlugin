describe Fastlane::Actions::XcodetestcoverageAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The xcodetestcoverage plugin is working!")

      Fastlane::Actions::XcodetestcoverageAction.run(nil)
    end
  end
end

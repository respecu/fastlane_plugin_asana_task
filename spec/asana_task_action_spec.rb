describe Fastlane::Actions::AsanaTaskAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The asana_task plugin is working!")

      Fastlane::Actions::AsanaTaskAction.run(nil)
    end
  end
end

require 'rails_helper'

RSpec.describe MovieExporterJob, type: :job do
  it 'runs job' do
    expect_any_instance_of(MovieExporter).to receive(:call).with(1)
    subject.perform(1)
  end
end

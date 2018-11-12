class MovieExporterJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    MovieExporter.new.call(user_id)
  end
end

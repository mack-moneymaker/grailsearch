class CheckSavedSearchesJob < ApplicationJob
  queue_as :default

  def perform
    SavedSearch.due_for_check.find_each do |saved_search|
      CheckSingleSearchJob.perform_later(saved_search.id)
    end
  end
end

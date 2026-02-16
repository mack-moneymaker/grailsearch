class AlertMailer < ApplicationMailer
  def new_results(saved_search, new_results)
    @saved_search = saved_search
    @new_results = new_results
    @user = saved_search.user

    mail(
      to: @user.email,
      subject: "🔥 #{new_results.size} new #{new_results.size == 1 ? 'listing' : 'listings'} for \"#{saved_search.query}\""
    )
  end
end

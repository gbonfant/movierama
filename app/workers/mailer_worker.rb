class MailerWorker
  include Sidekiq::Worker

  def perform(movie_id, kind)
    movie = Movie[movie_id]

    MovieNotificationMailer.like_or_dislike_email(movie, kind).deliver
  end
end

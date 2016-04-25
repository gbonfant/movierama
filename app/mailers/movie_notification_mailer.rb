class MovieNotificationMailer < ApplicationMailer
  def like_or_dislike_email(movie, kind)
    @kind = kind
    @movie = movie

    subject = I18n.t("mailer.#{kind.to_s}.subject")

    mail(to: @movie.user.email, subject: subject)
  end
end

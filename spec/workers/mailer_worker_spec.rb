require 'rails_helper'
require 'sidekiq/testing'

Sidekiq::Testing.fake!

RSpec.describe MailerWorker do
  let(:movie) do
    author = User.create(uid:  'null|12345', name: 'Bob', email: 'bob@email.com')

    Movie.create(
      title:        'Empire strikes back',
      description:  'Who\'s scruffy-looking?',
      date:         '1980-05-21',
      user:         author
    )
  end

  it 'queues a mailer delivery' do
    MailerWorker.perform_async('foo', 'bar')

    expect(MailerWorker.jobs.size).to eq(1)
  end

  it 'sends an email notification on execution' do
    MailerWorker.perform_async(movie.id, :like)
    MailerWorker.drain

    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end
end

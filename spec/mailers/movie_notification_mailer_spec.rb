require 'rails_helper'

RSpec.describe MovieNotificationMailer do
  before do
    @author = User.create(uid:  'null|12345', name: 'Bob', email: 'bob@email.com')
    @movie = Movie.create(
      title:        'Empire strikes back',
      description:  'Who\'s scruffy-looking?',
      date:         '1980-05-21',
      created_at:   Time.parse('2014-10-01 10:30 UTC').to_i,
      user:         @author,
      liker_count:  50,
      hater_count:  2
    )
  end

  describe 'like_or_dislike_email' do
    let(:mailer) { described_class.like_or_dislike_email(@movie, :like) }

    it 'assigns a recipient' do
      expect(mailer.to).to eq([@author.email])
    end

    it 'assigns a noreply sender' do
      expect(mailer.from).to eq(['noreply@movierama.dev'])
    end

    context 'when a user likes a movie' do
      let(:positive_mailer) { described_class.like_or_dislike_email(@movie, :like) }

      it 'assigns a subject line' do
        expect(positive_mailer.subject).to eq('Someone likes your movie!')
      end

      it 'renders the message body' do
        expect(positive_mailer.body.decoded).to match(
          'Hey Bob, someone has liked your movie: Empire strikes back'
        )
      end
    end

    context 'when a user hates a movie' do
      let(:negative_mailer) { described_class.like_or_dislike_email(@movie, :hate) }

      it 'assigns a subject line' do
        expect(negative_mailer.subject).to eq('Someone hates your movie')
      end

      it 'renders the message body' do
        expect(negative_mailer.body.decoded).to match(
          'Hello Bob, unfortunately someone has hated your movie: Empire strikes back'
        )
      end
    end
  end
end

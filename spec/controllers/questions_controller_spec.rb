require 'rails_helper'

RSpec.describe QuestionsController do
  include Capybara::DSL

  describe '#publish_question' do
    it 'fires pusher' do
      user2 = create(:user)
      event2 = user2.events.create(title: 'My Event')
      question1 = event2.questions.create(content: 'Do you like fish?')
      choice_one = question1.choices.create(content: 'Yes')
      choice_two = question1.choices.create(content: 'No')
      sign_in_as(user2)

      visit event_path(event2)
      click_on 'Publish'

      p = QuestionsController.new

      # allow(p).to receive(:build_json).with(any_args).and_return()

      # question.choices.create(content: "no")


      # create(:choice, question: question)
      # create(:choice, content: 'No', question: question)

      # p = QuestionsController.new
      # # expect(p).to receive(:publish_question)
      # expect(p.publish_question).to eq "Hello"
    end
  end

  describe '#build_json' do
    it 'returns an acceptable json object for pusher' do
      user =      create(:user)
      event =     user.events.create(title: 'test')
      question =  event.questions.create(content: 'test question')
      choice =    question.choices.create(content: 'test choice')
      choice2 =   question.choices.create(content: 'best choice')
      
      sign_in_as(user)

      p = QuestionsController.new

      expect(JSON.parse(p.build_json event, question)).to eq( {"event"=>{"id"=>event.id, "title"=>"test"}, "question"=>{"id"=>question.id, "content"=>"test question"}, "choices"=>[{"content"=>"test choice", "id"=>choice.id}, {"content"=>"best choice", "id"=>choice2.id}]} )
    end
  end

  private

  def sign_in_as(user)
    visit root_path
    click_link 'Sign in'
    fill_in :user_email, with: user.email
    fill_in :user_password, with: user.password
    click_button 'Log in'
  end
end
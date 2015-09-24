require 'rails_helper'

feature 'Events Features' do

  context 'when signed in' do

    before :each do
      user = create(:user)
      sign_in_as(user)
    end

    context 'when creating events' do

      before(:each){ click_on 'Create Event' }

      it 'events can be created' do
        fill_in 'event_title', with: 'event 1'
        click_on 'Add Event'
        expect(page).to have_content 'event 1'
        expect(page).to have_link("voting page", href: "/events/#{Event.last.id}/vote")
      end

      it "events cannot be created with a blank title field" do
        click_on 'Add Event'
        expect(page).to have_content "1 error prohibited this event from being saved:"
      end
    end

    context "after creating an event" do

      before(:each){ create_event("event 1") }


      context "when on events index page" do

        before(:each){ visit events_path }

        it "user's events are displayed" do
          expect(page).to have_content "event 1"
        end

        it 'each event is clickable to the event show page' do
          click_on 'event 1'
          expect(current_path).to eq "/events/#{Event.last.id}"
        end
      end

      context 'when on event show page' do

        before(:each) do
          click_on 'Add Question'
          fill_in 'question_content', with: 'test question'
          click_on 'Add'
          visit events_path("#{Event.last.id}")
          click_on 'event 1'
        end

        it 'has a publish question button' do
          expect(page).to have_selector(:link_or_button, 'Publish')
        end

        it 'publishes question' do
          click_on 'Publish'
          expect(page).to have_content 'test question is currently live'
        end
      end
    end
  end

  context 'when not signed in' do

    it 'events cannot be created' do
      visit root_path
      click_on 'Create Event'
      expect(page).to have_content 'You need to sign in or sign up before continuing'
      expect(current_path).not_to be new_event_path
    end

    it "can navigate to an event's voting page" do
      user = create :user
      event = create :event, title: "My Event", user: user
      visit vote_event_path(event)
      expect(page).to have_content "My Event"
    end
  end

  private

  def create_event(title)
    click_on 'Create Event'
    fill_in 'event_title', with: title
    click_on 'Add Event'
  end
end

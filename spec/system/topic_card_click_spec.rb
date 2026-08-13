# frozen_string_literal: true

RSpec.describe "Clicking a topic card" do
  fab!(:theme) { upload_theme_component }
  fab!(:topic) { Fabricate(:post).topic }

  let(:discovery) { PageObjects::Pages::Discovery.new }
  let(:topic_page) { PageObjects::Pages::Topic.new }

  def mark_page
    page.execute_script("window.__topicCardsSpecMarker = true")
  end

  def page_was_not_reloaded?
    page.evaluate_script("window.__topicCardsSpecMarker") == true
  end

  before do
    topic.update!(excerpt: "A card excerpt that is big enough to click on")

    visit "/latest"
    expect(page).to have_css(".topic-cards-list .topic-card__excerpt-text", text: topic.excerpt)
    mark_page
  end

  it "navigates client-side when clicking the topic title" do
    discovery.topic_list.visit_topic(topic)

    expect(topic_page).to have_topic_title(topic.title)
    expect(page_was_not_reloaded?).to eq(true)
  end

  it "navigates client-side when clicking the card body" do
    find(".topic-card[data-topic-id='#{topic.id}'] .topic-card__excerpt-text").click

    expect(topic_page).to have_topic_title(topic.title)
    expect(page_was_not_reloaded?).to eq(true)
  end
end

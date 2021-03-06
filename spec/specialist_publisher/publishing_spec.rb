feature "Publishing with Specialist Publisher", specialist_publisher: true do
  include SpecialistPublisherHelpers

  let(:title) { title_with_timestamp }

  scenario "Publishing an AAIB Report" do
    given_there_is_a_draft_aaib_report
    when_i_publish_it
    then_i_can_view_it_on_gov_uk
  end

  def given_there_is_a_draft_aaib_report
    visit(Plek.find("specialist-publisher") + "/aaib-reports/new")

    fill_in_aaib_report_form(title: title)

    click_button("Save as draft")
    expect_created_alert(title)
  end

  def when_i_publish_it
    page.accept_confirm do
      click_button("Publish")
    end
    expect_published_alert(title)
  end

  def then_i_can_view_it_on_gov_uk
    url = find_link("View on website")[:href]
    reload_url_until_status_code(url, 200)

    click_link("View on website")
    expect_rendering_application("government-frontend")
    expect(page).to have_content(title)
  end
end

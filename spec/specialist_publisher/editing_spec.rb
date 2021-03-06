feature "Editing with Specialist Publisher", specialist_publisher: true do
  include SpecialistPublisherHelpers

  let(:old_title) { title_with_timestamp }
  let(:new_title) { title_with_timestamp }

  scenario "Editing an Asylum Support Decision" do
    given_there_is_an_asylum_support_decision
    when_i_edit_it
    then_i_can_see_the_edits_on_draft_gov_uk
  end

  def given_there_is_an_asylum_support_decision
    visit_specialist_publisher("/asylum-support-decisions/new")

    fill_in_asylum_support_decision_form(title: old_title)

    click_button("Save as draft")
    expect_created_alert(old_title)
  end

  def when_i_edit_it
    visit(Plek.find("specialist-publisher") + "/asylum-support-decisions")
    click_link(old_title)
    click_link("Edit document")

    fill_in("Title", with: new_title)
    click_button("Save as draft")

    expect_updated_alert(new_title)
  end

  def then_i_can_see_the_edits_on_draft_gov_uk
    url = find_link("Preview draft")[:href]
    reload_url_until_status_code(url, 200)

    click_link("Preview draft")
    expect_rendering_application("draft-government-frontend")
    expect(page).to have_content(new_title)
  end
end

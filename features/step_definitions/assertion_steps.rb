# Assertion steps copied from SHF project. Edited so these only include
#  - steps that Rubymine has a problem with
#  - steps that don't require lots of the SHF domain objects

Then "I should{negate} see {capture_string}" do |negate, content|
  begin
    expect(page).send (negate ? :not_to : :to), have_content(/#{content}/i)
  rescue RSpec::Expectations::ExpectationNotMetError
    expect(page).send (negate ? :not_to : :to), have_content(content)
  end
end


Then(/^I should see:$/) do |table|
  table.hashes.each do |hash|
    expect(page).to have_content hash[:content]
  end
end


Then "I should see raw HTML {capture_string}" do |html|
  expect(page.body).to match html
end


Then "I should{negate} see {capture_string} image" do |negate, alt_text|
  expect(page).send (negate ? :not_to : :to),  have_xpath("//img[contains(@alt,'#{alt_text}')]")
end


Then "I should{negate} see button {capture_string}" do |negate, button|
  expect(page).send (negate ? :not_to : :to),  have_button(button)
end


Then "I should{negate} see {capture_string} link" do |negate, link_label|
  expect(page).send (negate ? :not_to : :to),  have_link(link_label)
end


Then(/^I should( not)? see the (?:checkbox|radio button) with id "([^"]*)" unchecked$/) do |negate, checkbox_id|
  expect(page).send (negate ? :not_to : :to),  have_unchecked_field(checkbox_id)
end


Then "I should{negate} see {capture_string} in the row for {capture_string}" do |negate, text, row_identifier|
  row = find(:xpath, "//tr[td//text()[contains(.,'#{row_identifier}')]]")
  expect(row).send (negate ? :not_to : :to), have_content(text)
end


Then(/^I should see "([^"]*)" applications$/) do |number|
  expect(page).to have_selector('tr.applicant', count: number)
end


Then(/^I should see "([^"]*)" companies/) do |number|
  expect(page).to have_selector('tr.company', count: number)
end


Then(/^I should see "([^"]*)" business categories/) do |number|
  expect(page).to have_selector('tr.business_category', count: number)
end

Then(/^I should see "([^"]*)" address(?:es)?/) do |number|
  expect(page).to have_selector('tr.address', count: number)
end

Then(/^I should see "([^"]*)" event(?:s)?/) do |number|
  expect(page).to have_selector('tr.event', count: number)
end


Then "the field {capture_string} should{negate} have a required field indicator" do |label_text, negate|
  expect(page).send ( negate ? :not_to : :to), have_xpath("//label[@class='required'][text()='#{label_text}']")
end


Then(/^I should see (\d+) (.*?) rows$/) do |n, css_class_name|
  n = n.to_i
  expect(page).to have_selector(".#{css_class_name}", count: n)
  expect(page).not_to have_selector(".#{css_class_name}", count: n+1)
end


Then "I should see error {capture_string} {capture_string}" do |model_attribute, error|
  expect(page).to have_content("#{model_attribute} #{error}")
end


Then "I should see status line with status {capture_string} and date {capture_string}" do |status, date_string|
  expect(page).to have_content("#{status} - #{date_string}")
end


Then "I should{negate} see status line with status {capture_string}" do |negate, status|
  expect(page).send (negate ? :not_to : :to), have_content("#{status} - ")
end


Then "I should see {digits} {capture_string}" do |n, content |
  n = n.to_i
  expect(page).to have_text("#{content}", count: n)
  expect(page).not_to have_text("#{content}", count: n+1)
end

Then "{capture_string} should{negate} be visible" do |string, negate|
  expect(has_text?(:visible, "#{string}")).to be negate == nil
end


# Tests that an input has a given value
Then "the {capture_string} field should be set to {capture_string}" do |field, text_value|
  expect(find_field(field).value).to eq(text_value)
end


Then(/^I should see link "([^"]*)" with target = "([^"]*)"$/) do |link_identifier, target_value|
  expect(find_link(link_identifier)[:target]).to eq(target_value)
end


Then "I should see flash text {capture_string}" do | text |
  expect(page).to have_selector('#flashes', text: text )
end


Then "I should{negate} see {capture_string} in the row for user {capture_string}" do | negate, expected_text, user_email |
  td = page.find(:css, 'td', text: user_email) # find the td with text = user_email
  tr = td.find(:xpath, './parent::tr') # get the parent tr of the td
  expect(tr.text).send (negate ? :not_to : :to), match(Regexp.new(expected_text))
end


Then "I should{negate} see {capture_string} for class {capture_string} in the row for user {capture_string}" do |negate, expected_text, css_class, user_email |
  td = page.find(:css, 'td', text: user_email) # find the td with text = user_email
  tr = td.find(:xpath, './parent::tr') # get the parent tr of the td
  expect(tr).send (negate ? :not_to : :to), have_css(".#{css_class}", text: expected_text)
end


Then(/^I should( not)? see xpath "([^"]*)"$/) do | negate, xp |
  expect(page).send (negate ? :not_to : :to),  have_xpath(xp)
end


Then(/^I should( not)? see "([^"]*)" before "([^"]*)"$/) do |not_see, toSearch, last|
  assert_text toSearch
  regex = /#{Regexp.quote("#{toSearch}")}.+#{Regexp.quote("#{last}")}/m

  if not_see
    assert_no_text :visible, regex
  else
    assert_text :visible, regex
  end
end




# Checks that a certain option is selected for a text field (from https://github.com/makandra/spreewald)
Then "{capture_string} should{negate} have {capture_string} selected" do | select_list, negate, expected_string |

  try_again = true

  begin
    field = find_field(select_list)

    field_value = case field.tag_name
                    when 'select'
                      options = field.all('option')
                      selected_option = options.detect(&:selected?) || options.first
                      if selected_option && selected_option.text.present?
                        selected_option.text.strip
                      else
                        ''
                      end
                    else
                      field.value
                  end
  rescue Selenium::WebDriver::Error::StaleElementReferenceError
    if try_again
      try_again = false
      retry
    end
    raise
  end

  # https://www.seleniumhq.org/exceptions/stale_element_reference.jsp

  expect(field_value).send( (negate ? :not_to : :to),  eq(expected_string) )

end



# Checks that a certain option does or does not exist in a select list
Then "{capture_string} should{negate} have {capture_string} as an option" do | select_list, negate, expected_string |

  field = find_field(select_list)

  select_options= case field.tag_name
                  when 'select'
                    options = field.all('option')
                end
  expect(select_options.map(&:text)).send( (negate ? :not_to : :to),  include( expected_string) )

end


And(/^the url "([^"]*)" should( not)? be a valid route$/) do |url, negate |

  if negate
    expect{ visit url }.to  raise_error(ActionController::RoutingError, "No route matches [GET] \"/#{url}\"")
  else
    visit url
  end

end


And(/^the page should( not)? be blank$/) do | negate |
  expect(page.body).send( (negate ? :not_to : :to), be_empty )
end

Then(/^I should get a downloaded image with the filename "([^\"]*)"$/) do |filename|
  expect(page.driver.response_headers['Content-Disposition'])
    .to include("attachment; filename=\"#{filename}\"")
  expect(page.driver.response_headers['Content-Type'])
    .to eq 'image/jpg'
end

When "I cannot select {capture_string} in select list {capture_string}" do |option, list|
  expect(find_field(list).text.match(option)).to be_nil
end

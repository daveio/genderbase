require "test_helper"

class PageHeroPartialTest < ActionView::TestCase
  test "renders eyebrow, title and lead with the requested tone" do
    render partial: "shared/page_hero",
           locals: { eyebrow: "About", title: "About Genderbase", lead: "Lead copy.", tone: "accent" }

    assert_select "section.page-hero.page-hero-accent"
    assert_select "p.type-eyebrow.text-accent", text: "About"
    assert_select "h1", text: "About Genderbase"
    assert_select "p", text: "Lead copy."
  end

  test "defaults to the primary tone" do
    render partial: "shared/page_hero", locals: { eyebrow: "Team", title: "Our Team", lead: "Lead." }

    assert_select "section.page-hero.page-hero-primary"
    assert_select "p.type-eyebrow.text-primary", text: "Team"
  end

  test "rejects an unknown tone instead of rendering unstyled markup" do
    error = assert_raises(ActionView::Template::Error, ArgumentError) do
      render partial: "shared/page_hero", locals: { eyebrow: "X", title: "X", lead: "X", tone: "danger" }
    end

    assert_match(/page_hero tone must be one of primary, secondary, accent, got "danger"/, error.message)
  end

  test "sets the document title from the page title when none is set" do
    render partial: "shared/page_hero", locals: { eyebrow: "About", title: "About Genderbase", lead: "Lead." }

    assert_equal "About Genderbase · Genderbase", view.content_for(:title).to_s
  end

  test "leaves an existing document title alone" do
    view.content_for(:title, "Custom title")
    render partial: "shared/page_hero", locals: { eyebrow: "About", title: "About Genderbase", lead: "Lead." }

    assert_equal "Custom title", view.content_for(:title).to_s
  end
end

require File.join(File.dirname(__FILE__), '..', 'test_helper')

class ApplicationHelperTest < ActionView::TestCase
  def setup
    ActionController::Routing::Routes.draw do |map|
      map.people 'people', :controller => 'people', :action => 'index'
    end
  end
  
  test "non-active header menu item" do
    item_text = '<li class="people"><a href="/people">People</a></li>'
    assert_equal item_text, header_menu_item(:people)
    assert_equal item_text, header_menu_item("people")
    assert_equal item_text, header_menu_item(:people, false)
    assert_equal item_text, header_menu_item("people", false)
  end
  
  test "active header_menu_item" do
    item_text = '<li class="people"><a href="/people" class="active">People</a></li>'
    assert_equal item_text, header_menu_item(:people, true)
    assert_equal item_text, header_menu_item("people", true)
  end
end

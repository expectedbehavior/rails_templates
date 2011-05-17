require File.join(File.dirname(__FILE__), '..', 'test_helper')

class StringPathTest < ActiveSupport::TestCase
  test "down_under" do
    assert_equal "foo", "foo".down_under
    assert_equal "foo_bar", "foo Bar ".down_under
    assert_equal "foo", " foo \t\n".down_under
    assert_equal "foo", "Foo".down_under
    assert_equal "f_oo", "fOo".down_under
    assert_equal "class_name", "ClassName".down_under
  end
  
  test "filename_sanitize" do
    assert_equal "test.txt", "C:\\Windows\\FUUU\\test.txt".filename_sanitize
    assert_equal "test.txt", "C:\\Windows\\FUUU &\\test.txt".filename_sanitize
    assert_equal "te_t.txt", "C:\\Windows\\FUUU\\te&t.txt".filename_sanitize
    assert_equal "te_t.txt", "C:\\Windows\\FUUU\\te_t.txt".filename_sanitize
    assert_equal "te-t.txt", "C:\\Windows\\FUUU\\te-t.txt".filename_sanitize
    assert_equal "te_t.txt", "C:\\Windows\\FUUU\\te t.txt".filename_sanitize
    
    assert_equal "test.txt", "/usr/lib/src/test.txt".filename_sanitize
    assert_equal "test.txt", "/usr/lib/src &/test.txt".filename_sanitize
    assert_equal "te_t.txt", "/usr/lib/src/te&t.txt".filename_sanitize
    assert_equal "te_t.txt", "/usr/lib/src/te_t.txt".filename_sanitize
    assert_equal "te-t.txt", "/usr/lib/src/te-t.txt".filename_sanitize
    assert_equal "te_t.txt", "/usr/lib/src/te t.txt".filename_sanitize
  end
end

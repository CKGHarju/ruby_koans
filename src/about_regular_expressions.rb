require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutRegularExpressions < Neo::Koan
  def test_a_pattern_is_a_regular_expression
    assert_equal __(Regexp), %r{pattern}.class
  end

  def test_a_regexp_can_search_a_string_for_matching_content
    assert_equal __('match'), 'some matching content'[%r{match}]
  end

  def test_a_failed_match_returns_nil
    assert_equal __(nil), 'some matching content'[%r{missing}]
  end

  # ------------------------------------------------------------------

  def test_question_mark_means_optional
    assert_equal __('ab'), 'abbcccddddeeeee'[%r{ab?}]
    assert_equal __('a'), 'abbcccddddeeeee'[%r{az?}]
  end

  def test_plus_means_one_or_more
    assert_equal __('bccc'), 'abbcccddddeeeee'[%r{bc+}]
  end

  def test_asterisk_means_zero_or_more
    assert_equal __('abb'), 'abbcccddddeeeee'[%r{ab*}]
    assert_equal __('a'), 'abbcccddddeeeee'[%r{az*}]
    assert_equal __(''), 'abbcccddddeeeee'[%r{z*}]

    # THINK ABOUT IT:
    #
    # When would * fail to match?
  end

  # THINK ABOUT IT:
  #
  # We say that the repetition operators above are "greedy."
  #
  # Why?

  # ------------------------------------------------------------------

  def test_the_left_most_match_wins
    assert_equal __('a'), 'abbccc az'[%r{az*}]
  end

  # ------------------------------------------------------------------

  def test_character_classes_give_options_for_a_character
    animals = %w[cat bat rat zat]
    assert_equal __(%w[cat bat rat]), animals.select { |a| a[%r{[cbr]at}] }
  end

  def test_slash_d_is_a_shortcut_for_a_digit_character_class
    assert_equal __('42'), 'the number is 42'[%r{[0123456789]+}]
    assert_equal __('42'), 'the number is 42'[%r{\d+}]
  end

  def test_character_classes_can_include_ranges
    assert_equal __('42'), 'the number is 42'[%r{[0-9]+}]
  end

  def test_slash_s_is_a_shortcut_for_a_whitespace_character_class
    assert_equal __(" \t\n"), "space: \t\n"[%r{\s+}]
  end

  def test_slash_w_is_a_shortcut_for_a_word_character_class
    # NOTE:  This is more like how a programmer might define a word.
    assert_equal __('variable_1'), 'variable_1 = 42'[%r{[a-zA-Z0-9_]+}]
    assert_equal __('variable_1'), 'variable_1 = 42'[%r{\w+}]
  end

  def test_period_is_a_shortcut_for_any_non_newline_character
    assert_equal __('abc'), "abc\n123"[%r{a.+}]
  end

  def test_a_character_class_can_be_negated
    assert_equal __('the number is '), 'the number is 42'[%r{[^0-9]+}]
  end

  def test_shortcut_character_classes_are_negated_with_capitals
    assert_equal __('the number is '), 'the number is 42'[%r{\D+}]
    assert_equal __('space:'), "space: \t\n"[%r{\S+}]
    # ... a programmer would most likely do
    assert_equal __(' = '), 'variable_1 = 42'[%r{[^a-zA-Z0-9_]+}]
    assert_equal __(' = '), 'variable_1 = 42'[%r{\W+}]
  end

  # ------------------------------------------------------------------

  def test_slash_a_anchors_to_the_start_of_the_string
    assert_equal __('start'), 'start end'[%r{\Astart}]
    assert_equal __(nil), 'start end'[%r{\Aend}]
  end

  def test_slash_z_anchors_to_the_end_of_the_string
    assert_equal __('end'), 'start end'[%r{end\z}]
    assert_equal __(nil), 'start end'[%r{start\z}]
  end

  def test_caret_anchors_to_the_start_of_lines
    assert_equal __('2'), "num 42\n2 lines"[%r{^\d+}]
  end

  def test_dollar_sign_anchors_to_the_end_of_lines
    assert_equal __('42'), "2 lines\nnum 42"[%r{\d+$}]
  end

  def test_slash_b_anchors_to_a_word_boundary
    assert_equal __('vines'), 'bovine vines'[%r{\bvine.}]
  end

  # ------------------------------------------------------------------

  def test_parentheses_group_contents
    assert_equal __('hahaha'), 'ahahaha'[%r{(ha)+}]
  end

  # ------------------------------------------------------------------

  def test_parentheses_also_capture_matched_content_by_number
    assert_equal __('Gray'), 'Gray, James'[%r{(\w+), (\w+)}, 1]
    assert_equal __('James'), 'Gray, James'[%r{(\w+), (\w+)}, 2]
  end

  def test_variables_can_also_be_used_to_access_captures
    assert_equal __('Gray, James'), 'Name:  Gray, James'[%r{(\w+), (\w+)}]
    assert_equal __('Gray'), Regexp.last_match(1)
    assert_equal __('James'), Regexp.last_match(2)
  end

  # ------------------------------------------------------------------

  def test_a_vertical_pipe_means_or
    grays = %r{(James|Dana|Summer) Gray}
    assert_equal __('James Gray'), 'James Gray'[grays]
    assert_equal __('Summer'), 'Summer Gray'[grays, 1]
    assert_equal __(nil), 'Jim Gray'[grays, 1]
  end

  # THINK ABOUT IT:
  #
  # Explain the difference between a character class ([...]) and alternation (|).

  # ------------------------------------------------------------------

  def test_scan_is_like_find_all
    assert_equal __(%w[one two three]), 'one two-three'.scan(%r{\w+})
  end

  def test_sub_is_like_find_and_replace
    assert_equal __('one t-three'), 'one two-three'.sub(%r{(t\w*)}) { Regexp.last_match(1)[0, 1] }
  end

  def test_gsub_is_like_find_and_replace_all
    assert_equal __('one t-t'), 'one two-three'.gsub(%r{(t\w*)}) { Regexp.last_match(1)[0, 1] }
  end
end

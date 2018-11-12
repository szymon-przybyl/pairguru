class TitleBracketsValidator < ActiveModel::Validator
  BRACKETS = {
    '(' => ')',
    '{' => '}',
    '[' => ']'
  }.freeze

  def validate(record)
    return unless record.title

    opened_brackets = []
    last_opened_bracket_index = nil

    record.title.each_char.with_index do |char, i|
      if opening_bracket?(char)
        opened_brackets << char
        last_opened_bracket_index = i
      elsif closing_bracket?(char)
        opened_bracket = opened_brackets.pop
        matching_closing_bracket = BRACKETS[opened_bracket]
        if char != matching_closing_bracket || last_opened_bracket_index == i - 1
          return add_error(record)
        end
      end
    end

    add_error(record) if opened_brackets.any?
  end

  def opening_bracket?(char)
    BRACKETS.keys.include?(char)
  end

  def closing_bracket?(char)
    BRACKETS.values.include?(char)
  end

  def add_error(record)
    record.errors.add(:title, 'Invalid brackets')
  end
end
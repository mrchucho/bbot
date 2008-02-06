class Post < ActiveRecord::Base
  before_save :convert_body

private
include ActionView::Helpers::TextHelper
  def convert_body
    self.body = textilize(self.body_raw)
  end
end

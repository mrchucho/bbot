module ModerationsHelper
  def summarize_comment(comment)
    h(comment[0..79])
  end
end

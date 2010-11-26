class RCodeFixFilter < Nanoc3::Filter
  include Nanoc3::Helpers::HTMLEscape

  identifier :r_code_fix

  def run(content, params={})
    content.gsub('<-','&lt;-')
  end
end

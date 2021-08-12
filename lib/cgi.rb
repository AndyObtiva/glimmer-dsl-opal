class CGI
  class << self
    def escapeHTML(text)
      text.
        gsub('&', '&amp;').
        gsub('<', '&lt;').
        gsub('>', '&gt;').
        gsub("'", '&#39;').
        gsub('"', '&quot;')
    end
  end
end

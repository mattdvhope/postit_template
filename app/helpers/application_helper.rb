module ApplicationHelper

  def fix_url(str)
    str.starts_with?('http://') ? str : "http://#{str}"
  end

  def clean_url(url)
    url.gsub!(/([(ht|f)tp]*:\/\/)*(\w*\.)*(\w+\.\w{2,5})/, '\2' + '\3')
  end

  def display_datetime(datetime)
    datetime.strftime("%m/%d/%Y %l:%M%P %Z")
  end

end


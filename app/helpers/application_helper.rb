module ApplicationHelper

  def fix_url(str)
    str.starts_with?('http://') ? str : "http://#{str}"
  end

  def clean_url(url)
    url.gsub!(/([(ht|f)tp]*:\/\/)*(\w*\.)*(\w+\.\w{2,5})/, '\2' + '\3')
  end

  def display_datetime(datetime)
    if logged_in? && !current_user.time_zone.blank?
      datetime = datetime.in_time_zone(current_user.time_zone) # this enables the resetting of the datetime zone for that current user; the timezones of the other users are thus converted to the user's time_zone
    end

    datetime.strftime("%m/%d/%Y %l:%M%P %Z")
  end

end


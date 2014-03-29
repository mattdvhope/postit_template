module ApplicationHelper

  def fix_url(str)
    str.starts_with?('http://') ? str : "http://#{str}"
  end

  def clean_url(url)
    url.gsub!(/([(ht|f)tp]*:\/\/)*(\w*\.)*(\w+\.\w{2,5})/, '\2' + '\3')
  end

  def display_datetime(datetime)
    if logged_in? && !current_user.time_zone.blank? # .blank? is a rails method that tests to see whether a string is nil or empty.
      datetime = datetime.in_time_zone(current_user.time_zone) # this enables the resetting of the datetime zone for that current user; the timezones of the other users are thus converted to the user's time_zone
    end                 #.in_time_zone("Arizona") is a method that rails provides so that when a TZ string is its argument, it will display a datetime in that arguement's time zone.

    datetime.strftime("%m/%d/%Y %l:%M%P %Z")
  end

end


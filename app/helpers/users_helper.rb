module UsersHelper
  def error_message_for_email(user)
    error_hash = user.errors.messages
    error_hash = error_hash.slice(:email) if error_hash[:email] && error_hash[:email].find {|m| /already has a user associated with it/ =~ m}
    error_hash.inject([]) do |result_message, (field, msgs)|
      msgs.each do |msg|
        result_message << "#{field.to_s.humanize} #{msg}".html_safe
      end
      result_message
    end
  end
end

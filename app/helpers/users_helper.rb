module UsersHelper
  # TODO: Vijay: Since this is a validation, this should be at the model - probably in an 'after_validation' hook - this is not validation, it's just modifying the error messages for displaying in the view
  def error_message_for_email(user)
    error_hash = user.errors.messages
    error_hash = error_hash.slice(:email) if error_hash[:email] && error_hash[:email].find {|m| /has already been used to register an account/ =~ m}
    error_hash.inject([]) do |result_message, (field, msgs)|
      msgs.each do |msg|
        result_message << "#{field.to_s.humanize} #{msg}".html_safe
      end
      result_message
    end
  end
end

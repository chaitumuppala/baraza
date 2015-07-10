class TypeChangeNotifier < ApplicationMailer
  def type_change_mail(email, name, type)
    @name = name
    @type = type
    mail(to: email)
  end
end

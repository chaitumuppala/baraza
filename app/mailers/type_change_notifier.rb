class TypeChangeNotifier < ApplicationMailer
  def change_type_to_editor_mail(email, name, type)
    change_type_mail(email, name, type)
  end

  def change_type_to_administrator_mail(email, name, type)
    change_type_mail(email, name, type)
  end

  def change_type_to_registered_user_mail(email, name, type)
    change_type_mail(email, name, type)
  end

  private
  def change_type_mail(email, name, type)
    @name = name
    @type = type
    mail(to: email)
  end
end

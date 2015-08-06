class TypeChangeNotifier < ApplicationMailer
  def change_type_to_editor_mail(email, name, type)
    change_type_mail(email, name, type, "You have been assigned as an editor on the Pan-African Baraza")
  end

  def change_type_to_administrator_mail(email, name, type)
    change_type_mail(email, name, type, "You have been assigned as an admin on the Pan-African Baraza")
  end

  def change_type_to_registered_user_mail(email, name, type)
    change_type_mail(email, name, type, "You have been assigned back to a registered user on the Pan-African Baraza")
  end

  private
  def change_type_mail(email, name, type, subject)
    @name = name
    @type = type
    mail(to: email, subject: subject)
  end
end

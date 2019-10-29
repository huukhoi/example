class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: I18n.t(".account_acti")
  end

  def password_reset user
    @user = user

    mail to: user.email, subject: I18n.t("password_reset")
  end
end

SanitizeEmail::Config.configure do |config|
  config[:sanitized_to] = 'ayslanmarcelino@gmail.com'
  config[:activation_proc] = Proc.new { !Rails.env.test? && ENV['SANITIZE_EMAIL_ENABLED'] == 'true' }
  config[:use_actual_email_prepended_to_subject] = true
  config[:use_actual_environment_prepended_to_subject] = true
  config[:use_actual_email_as_sanitized_user_name] = true
end

unless Rails.env.production?
  ENV["SECRET_PASS"] = "secret"
end

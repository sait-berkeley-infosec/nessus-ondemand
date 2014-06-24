Rails.application.config.middleware.use OmniAuth::Builder do
  provider :cas, url: 'https://auth.berkeley.edu/cas/'
end

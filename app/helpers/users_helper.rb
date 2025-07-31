module UsersHelper
  # Returns the Gravatar for the given user.
  def gravatar_for user
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def get_gender_options
    User.genders.keys.map do |gender|
      [t("users.helpers.#{gender.downcase}"), gender]
    end
  end
end

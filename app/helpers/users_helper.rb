module UsersHelper
  DEFAULT_IMAGE_SIZE = 50
  # Returns the Gravatar for the given user.
  def gravatar_for user, options = {size: DEFAULT_IMAGE_SIZE}
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def get_gender_options
    User.genders.keys.map do |gender|
      [t("users.helpers.#{gender.downcase}"), gender]
    end
  end

  def can_delete_user? user
    current_user.admin? && !current_user?(user)
  end
end

class User
  include ActiveAttr::Model

  attribute :id, :type => Integer
  attribute :name, :type => String
  attribute :calnet, :type => Integer
  attribute :email, :type => String
  attribute :admin, :type => Boolean, :default => false

  @@all_users = []

  def initialize(attributes={})
    super
    @@all_users<< self
    self.id = @@all_users.length
  end

  def admin?
    return admin
  end

  def self.find_by_calnet(uid)
    Rails.logger.info "Trying to find User UID #{uid}..."
    @@all_users.each do |user|
      Rails.logger.debug "Does #{user.calnet} == #{uid}?"
      if user.calnet == uid
        return user
      end
    end
    return nil
  end

  def self.find(id)
    @@all_users[id.to_i]
  end

  def self.all
    @@all_users
  end
end

f = YAML::load_file(File.join(Rails.root, 'config/users.yml'))
f["Users"]["Standard"].each do |name, values|
  User.new(name: name, calnet: values["calnet"], email: values["email"])
end
f["Users"]["Admin"].each do |name, values|
  User.new(name: name, calnet: values["calnet"], email: values["email"], admin: true)
end

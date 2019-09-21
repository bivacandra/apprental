class Car < ApplicationRecord
  mount_uploader :image, ImageUploader
  
  def self.search(search1, search2, search3, search4)
    where("name LIKE ? and transmission LIKE ? and model LIKE ? and manufactor LIKE ?", "%#{search1}%", "%#{search2}%", "%#{search3}", "%#{search4}")
  end
end

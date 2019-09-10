class Car < ApplicationRecord

  def self.search(search1, search2)
    where("name LIKE ? and transmission LIKE ?", "%#{search1}%", "%#{search2}%")

  end
end

class Order < ApplicationRecord
  enum guarantee: {'KTP dan Motor' => 0, 'KTM dan Motor' => 1}
end

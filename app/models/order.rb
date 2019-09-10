class Order < ApplicationRecord
  enum guarantee: {"KTP dan Motor" => 0, "KTM dan Motor" => 1}
  enum pay_type: { BANK: 0, COUNTER: 1 }
end

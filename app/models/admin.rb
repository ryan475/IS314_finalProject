class Admin < ApplicationRecord
       devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
     
       def admin?
              role == 'admin'
       end

       def super_admin?
              role == 'super_admin'
       end
end     
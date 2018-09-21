class Account < ApplicationRecord
    
    #Validations
    before_validation :downcase_subdomain
    SUBDOMAIN_REGEX = /\A[\w]+\Z/
    validates :subdomain,presence:true,uniqueness: { case_sensitive: false},
              format: { with: SUBDOMAIN_REGEX, message: 'contains invalid characters'},
              exclusion: { in:['www'],message: 'restricted'}
    
    #Association
    belongs_to :owner,class_name:"User"
    
    accepts_nested_attributes_for :owner
    
    private 
    def downcase_subdomain
       self.subdomain = subdomain.try(:downcase) 
    end
end

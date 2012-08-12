class Package < ActiveRecord::Base
  attr_accessible :name, :description,  :base_price , :number_of_crew, :is_crew_specific_pricing
  has_many :projects
  has_many :deliverable_subcriptions
  has_many :deliverables, :through => :deliverable_subcriptions 
  
  has_many :package_assignments 
  has_many :users, :through => :package_assignments 
  
  belongs_to :office 
  
  validates_numericality_of :number_of_crew, :base_price 
  validates_presence_of :name #, :is_crew_specific_pricing
  
  
  
  def has_employee_assignment?( employee)
    self.package_assignments.where(:user_id => employee.id ).count != 0 
  end
  
  
  
  
  def assign_crew_to_package( crew , employee )
    if not PackageAssignment.appropriate_user_for_package_assignment?(employee, self)
      return nil
    end
    
    if PackageAssignment.where(:user_id => crew.id, :package_id => self.id).count !=0 
      return nil
    end
    
    
    PackageAssignment.create(:user_id => crew.id, :package_id => self.id )
  end
  
  def remove_crew_from_package( crew, employee )
    if not PackageAssignment.appropriate_user_for_package_assignment?(employee, self)
      return nil
    end
    
    PackageAssignment.where(:user_id => crew.id, :package_id => self.id).each do |package_assignment|
      package_assignment.destroy 
    end
  end
  
  def package_assignment_for( employee ) 
    self.package_assignments.where(:user_id => employee.id).first
  end
  
  def edit_crew_specific_pricing(crew, employee, price_string )
    if not PackageAssignment.appropriate_user_for_package_assignment?(employee, self)
      return nil
    end
    
    if not PackageAssignment.valid_price_string?(price_string) # can be parsed + bigger or equal than 0 
      return nil 
    end
    
    price = PackageAssignment.parse_price(price_string )
    package_assignment = package_assignment_for( crew ) 
    
    if package_assignment.nil?
      return nil
    end
    
    package_assignment.price = price 
    package_assignment.save
    return package_assignment
  end
  
end

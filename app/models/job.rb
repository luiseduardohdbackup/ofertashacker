class Job < ActiveRecord::Base
  
  belongs_to :company
  has_and_belongs_to_many :required_skills
  
  accepts_nested_attributes_for :required_skills
  
  validates_presence_of :company_id, :title, :description, :state
  validates_presence_of :full_time, :if=> :not_part_time_present
	
	metropoli_for :state, :as => :sate_name
	
  def not_part_time_present
    !part_time
  end
  
  def required_skill_ids_string=(string_ids)
    unless string_ids.blank?
      self.required_skill_ids = string_ids.split(',')
    else
      self.required_skill_ids = []
    end
  end
  
  def required_skill_ids_string
    id_collection = required_skills.collect{|rs| rs.id }
    id_collection.inject(""){|result,id| result += (id.to_s + (id == id_collection.last ?  '' : ','))}
  end
  def self.search(search)
    if search
      find(:all, :conditions => ['title LIKE ?', "%#{search}%"])
    else
      find(:all)
    end
  end
end

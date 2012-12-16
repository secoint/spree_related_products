Product.class_eval do
  has_many :relations, :as => :relatable
  has_many :related_tos, :as => :related_to, :class_name => "Relation"

  def self.relation_types
    RelationType.find_all_by_applies_to(self.to_s, :order => :name)
  end

  def method_missing(method, *args)
    relation_type =  self.class.relation_types.detect { |rt| rt.name.downcase.gsub(" ", "_").pluralize == method.to_s.downcase }
    
    # Fix for Ruby 1.9
    raise NoMethodError if method == :to_ary
    
    if relation_type.nil?
      super
    else
      if !relation_type.both_directions?
        relations.find_all_by_relation_type_id(relation_type.id).map(&:related_to).select do |product|    
          product.active?
        end      
      else
        arr =  self.relations.where(:relation_type_id => relation_type.id).map(&:related_to)
        arr += self.related_tos.where(:relation_type_id => relation_type.id).map(&:relatable)
        arr.uniq.select do |product|
          product.active?
        end
      end
    end

  end
end

# frozen_string_literal: true

class ImportModelBuilder
  attr_reader :model_symbol
  def initialize(model_symbol)
    @model_symbol = model_symbol
    @model_class = Object.const_get model_symbol
    @relationship_connected = false
  end

  def new_instance(params)
    @instance = @model_class.find_import params
    @instance = @model_class.new if @instance.nil?
  end

  def current
    @instance
  end

  def save(errors)
    if model_relation?
      @instance.from_node.save
      @instance.to_node.save
    end
    success = @instance.save
    errors.merge! @instance.errors unless success
    success
  end

  def model_node?
    module_included? Neo4j::ActiveNode
  end

  def model_relation?
    module_included? Neo4j::ActiveRel
  end

  def import(params)
    new_instance params if @instance.nil?
    @instance.import params
  end

  def create_associations(factory)
    @model_class.association_targets.each do |target|
      next unless factory.created? target

      target_builder = factory.builder target
      create_relationship_association target_builder, factory
    end
  end

  def create_relationship(from_builder, to_builder)
    raise "IS NOT a relationship builder #{model_symbol}" if model_node?
    return if relation_nodes_set?

    @instance.from_node = from_builder.current
    @instance.to_node = to_builder.current
    @relationship_connected = true
  end

  private

  def relation_nodes_set?
    model_node? || @relationship_connected
  end

  def create_relationship_association(target_builder, factory)
    target_symbol = target_builder.model_symbol
    association = @model_class.association_with_target target_symbol
    relationship = association.relationship_class
    if factory.created? relationship
      relationship_builder = factory.builder relationship
      create_association association, relationship_builder, target_builder
    else
      @instance.send("#{association.name}=", target_builder.current)
    end
  end

  def create_association(association, relation_builder, to_builder)
    if association.direction == :out
      relation_builder.create_relationship self, to_builder
    else
      relation_builder.create_relationship to_builder, self
    end
  end

  def module_included?(some_module)
    @model_class.included_modules.include? some_module
  end
end

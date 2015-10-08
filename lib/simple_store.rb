class SimpleStore

  require 'yaml'

  attr_accessor :attrs, :store_name
  def initialize store_name = 'count_store.yml'
    @store_name = store_name
    File.open(store_name,'a+') do |store|
      @attrs = YAML.load_file(store) || {}
    end
  end

  def increment key, val
    attrs[key] ||= 0
    attrs[key] += val
    persist!
  end

  def save key, val
    attrs[key] = val
    persist!
  end

  def clear
    File.delete store_name
  end

  private

  def persist!
    File.open(store_name, 'w') do |file|
      file.write attrs.to_yaml
    end
  end

end

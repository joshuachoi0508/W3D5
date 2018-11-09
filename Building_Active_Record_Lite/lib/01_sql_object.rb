require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    # ...
    unless @columns
      datas = DBConnection.execute2(<<-SQL)
        SELECT
          *
        FROM
          #{table_name}
      SQL

      @columns = datas.first.map { |column| column.to_sym }
    else
      @columns
    end
  end

  def self.finalize!
    # names.each do |name|
    #   define_method(name) do
    #     instance_variable_get("@#{name}")
    #   end
    #
    #   define_method("#{name}=") do |value|
    #     instance_variable_set("@#{name}", value)
    #   end
    # end

    columns.each do |column_name|
      define_method(column_name) do
        instance_variable_get("@#{column_name}")
      end

      define_method("#{column_name}=") do |value|
        instance_variable_set("@#{column_name}", value)
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || self.name.tableize
    # ...
  end

  def self.all
  end

  def self.parse_all(results)
    # ...
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    # ...
    # @attributes = {}
  end

  def attributes
    # ...
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end

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
        #instance_variable_get("@#{column_name}")
        self.attributes[column_name]
      end

      define_method("#{column_name}=") do |value|
        #instance_variable_set("@#{column_name}", value)
        self.attributes[column_name] = value
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
    results = DBConnection.execute(<<-SQL)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
    SQL

    parse_all(results)
  end

  def self.parse_all(results)
    # ...
    results.map { |result| self.new(result) }
  end

  def self.find(id)
    # ...
    results = DBConnection.execute(<<-SQL, id)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
      WHERE
        id = ?
    SQL

    parse_all(results)[0]
  end

  def initialize(params = {})
    # ...
    # @attributes = {}
    params.each do |name, value|
      name = name.to_sym
      if self.class.columns.include?(name)
        self.send("#{name}=", value)
      else
        raise "unknown attribute '#{name}'"
      end
    end
  end

  def attributes
    # ...
    @attributes ||= {}
  end

  def attribute_values
    # ...
    self.attributes.values
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

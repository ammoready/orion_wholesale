module Orion
  class Inventory < Base

    INVENTORY_FILENAME = 'exportXML_cq_barcodeFFL.csv'.freeze
    FULL_INVENTORY_FILENAME = 'exportXML_cq_barcodeFFL_all.csv'.freeze

    def initialize(options = {})
      requires!(options, :username, :password)
      @options = options
    end

    def self.all(options = {})
      requires!(options, :username, :password)
      new(options).all
    end

    def self.quantity(options = {})
      requires!(options, :username, :password)
      new(options).quantity
    end

    def all
      items    = []
      tempfile = get_file(INVENTORY_FILENAME)

      CSV.foreach(tempfile, { headers: :first_row }).each do |row|
        item = {
          item_identifier: row['id'],
          quantity:        row['qty'].to_i,
          price:           row['cost'],
        }

        items << item
      end

      tempfile.unlink

      items
    end

    def quantity
      items    = []
      tempfile = get_file(FULL_INVENTORY_FILENAME)

      CSV.foreach(tempfile, { headers: :first_row }).each do |row|
        item = {
          item_identifier: row['id'],
          quantity:        row['qty'].to_i,
        }

        items << item
      end

      tempfile.unlink

      items
    end

  end
end

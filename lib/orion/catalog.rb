module Orion
  class Catalog < Base
  
    CATALOG_DIR             = '/ammoready'
    CATALOG_FILENAME_PREFIX = 'orion_inv_arweb'
    
    def initialize(options = {})
      requires!(options, :username, :password)
      @options = options
    end

    def self.all(options = {})
      requires!(options, :username, :password)
      new(options).all
    end

    def all
      tempfile = get_most_recent_file(CATALOG_FILENAME_PREFIX, CATALOG_DIR)
      items = []

      File.open(tempfile).each_with_index do |row, i|
        row = row.split("\t")
        
        if i==0
          @headers = row
          next
        end

        if row[@headers.index('Category1')].strip == 'Guns'
          # Guns
          case row[@headers.index('Category2')].strip
          when 'Long Guns'
            @category    = row[@headers.index('Category3')].strip
            @subcategory = row[@headers.index("Category4\n")].strip
          when 'Handguns'
            @category    = row[@headers.index('Category2')].strip
            @subcategory = row[@headers.index("Category3")].strip
          end
        else
          # Everything else
          @category    = row[@headers.index('Category1')].strip
          @subcategory = row[@headers.index('Category2')].strip
        end

        item = {
          mfg_number:   row[@headers.index('Item ID')].strip,
          upc:          row[@headers.index('Bar Code')].strip,
          name:         row[@headers.index('Description')].strip,
          quantity:     row[@headers.index('Qty available')].to_i,
          price:        row[@headers.index('Price')].strip,
          brand:        row[@headers.index('Brand')].strip,
          category:     @category,
          subcategory:  @subcategory,
        }

        items << item
      end

      tempfile.close
      tempfile.unlink

      items
    end

  end
end

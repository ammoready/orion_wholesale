module Orion
  class Catalog < Base
  
    CATALOG_DIR             = '/ammoready'
    CATALOG_FILENAME_PREFIX = 'orion_inv_web'

    PERMITTED_FEATURES = [
      'Action',
      'Barrel_Length',
      'Blade_Edge',
      'Blade_Finish',
      'Blade_Length',
      'Blade_Style',
      'Box_Qty',
      'Bullet_Type',
      'Caliber',
      'Caliber_Gauge',
      'Capacity',
      'Carry_Type',
      'Color',
      'Cutting_Edge',
      'Diameter',
      'Edge',
      'Finish',
      'Gauge',
      'Grain',
      'Grit',
      'Gun_Manufacturer',
      'Gun_Model',
      'L_x_W',
      'Magnifactaion',
      'Material',
      'Model',
      'OAL',
      'Reticle',
      'Shell_Length',
      'Shot',
      'Tube_Diameter',
      'Type'
    ]

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

        item = {
          mfg_number: row[@headers.index('Item ID')].strip,
          upc:        row[@headers.index('Bar Code')].strip,
          name:       row[@headers.index('Description')].strip,
          quantity:   row[@headers.index('Qty available')].to_i,
          price:      row[@headers.index('Price')].strip,
        }

        items << item
      end

      tempfile.close
      tempfile.unlink

      items
    end

    protected

    def map_hash(node)
      features = map_features(node)

      category = content_for(node, 'category')
      subcategory = content_for(node, 'subCategory')

      case category
      when 'Firearms'
        case subcategory
        when 'Pistol', 'Revolver'
          product_type = :handgun
        when 'Rifle', 'Rifle Frame', 'Shotgun', 'Short Barrel Rifle'
          product_type = :long_gun
        end
      when 'NFA - Class 3'
        case subcategory
        when 'Suppressors'
          product_type = :suppressor
        end
      end

      {
        name:              content_for(node, 'name'),
        upc:               content_for(node, 'barcod'),
        item_identifier:   content_for(node, 'id'),
        quantity:          content_for(node, 'qty').to_i,
        price:             content_for(node, 'price'),
        map_price:         content_for(node, 'MAP'),
        short_description: content_for(node, 'description'),
        product_type:      product_type,
        category:          category,
        subcategory:       subcategory,
        mfg_number:        content_for(node, 'vendorItemNo'),
        weight:            content_for(node, 'Weight'),
        brand:             content_for(node, 'Brand'),
        caliber:           content_for(node, 'Caliber') || content_for(node, 'Caliber_Gauge'),
        features:          features
      }
    end

    def map_features(node)
      features = Hash.new

      node.elements.each do |n|
        if PERMITTED_FEATURES.include?(n.name.strip)
          # fix their typo
          n.name = "Magnification" if n.name.strip == "Magnifactaion"

          features[n.name.strip] = n.text.gsub("_", " ").strip
        end
      end

      features.delete_if { |k, v| v.to_s.blank? }
      features.transform_keys! { |k| k.downcase }
      features.transform_keys! { |k| k.gsub(/[^0-9A-Za-z\_]/, '') }
      features.symbolize_keys!
    end

  end
end

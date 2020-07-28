require 'spec_helper'

describe OrionWholesale::Catalog do

  it 'has CATALOG_FILENAME constant' do
    expect(defined?(OrionWholesale::Catalog::CATALOG_FILENAME)).to eq('constant')
  end

  it 'has PERMITTED_FEATURES constant' do
    expect(defined?(OrionWholesale::Catalog::PERMITTED_FEATURES)).to eq('constant')
  end

end

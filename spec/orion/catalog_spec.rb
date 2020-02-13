require 'spec_helper'

describe Orion::Catalog do

  it 'has CATALOG_FILENAME constant' do
    expect(defined?(Orion::Catalog::CATALOG_FILENAME)).to eq('constant')
  end

  it 'has PERMITTED_FEATURES constant' do
    expect(defined?(Orion::Catalog::PERMITTED_FEATURES)).to eq('constant')
  end

end

require 'rails_helper'
require 'jaro_winkler'
RSpec.describe JaroWinkler do
  describe '.similarity_distance' do
    it 'should' do
      expect( JaroWinkler.similarity_distance( "henka",     "henkan"    )).to be_within(0.9).of(0.9722)
      expect( JaroWinkler.similarity_distance( "al",        "al"        )).to be_within(0.9).of(1.0)
      expect( JaroWinkler.similarity_distance( "martha",    "marhta"    )).to be_within(0.81).of(1.0)
      expect( JaroWinkler.similarity_distance("zac ephron", "zac efron" )).to be > ( JaroWinkler.similarity_distance("zac ephron", "kai ephron" ))
    end
  end
end

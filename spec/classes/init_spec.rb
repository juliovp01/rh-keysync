require 'spec_helper'
describe 'keysync' do

  context 'with defaults for all parameters' do
    it { should contain_class('keysync') }
  end
end

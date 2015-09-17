require_relative '../../lib/list_values'

RSpec.describe ListValues do
  module TestList
    extend ListValues
    ONE = 'one'
    TWO = 'two'
  end
  
  it "turns a constants module into a list of values" do
    expect(TestList.values).to contain_exactly('one', 'two')
  end
end

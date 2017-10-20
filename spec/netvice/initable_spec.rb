require "spec_helper"

describe Netvice::Initable do
  let(:person_class) {
    Class.new do
      attr_accessor :name, :age
      include Netvice::Initable
    end
  }

  it 'can initialize and set states' do
    person = person_class.new(name: "Adam", age: 21)
    expect(person.name).to eq 'Adam'
    expect(person.age).to eq 21
  end

  it 'can instantiate without given any arg' do
    person = person_class.new
    expect(person.name).to be_nil
    expect(person.age).to be_nil
  end
end

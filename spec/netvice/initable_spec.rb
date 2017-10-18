require "spec_helper"

describe Netvice::Initable do
  class Person
    attr_accessor :name, :age
    include Netvice::Initable
  end

  it 'can initialize and set states' do
    person = Person.new(name: "Adam", age: 21)
    expect(person.name).to eq 'Adam'
    expect(person.age).to eq 21
  end

  it 'can instantiate without given any arg' do
    person = Person.new
    expect(person.name).to be_nil
    expect(person.age).to be_nil
  end
end

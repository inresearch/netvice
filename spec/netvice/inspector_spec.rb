require "spec_helper"

describe Netvice::Inspector do
  class Person
    attr_accessor :name, :age, :gender
    include Netvice::Inspector

    def inspect
      inspector([:name, :age])
    end
  end

  it 'prints name and age properly when both exist' do
    person = Person.new(name: 'Sun', age: 21, gender: 'm')
    expect(person.inspect).to eq '#<Person name=Sun age=21>'
  end

  it 'prints name when only it exists' do
    person = Person.new(name: 'Sun', gender: 'm')
    expect(person.inspect).to eq '#<Person name=Sun>'
  end

  it 'prints age when only it exists' do
    person = Person.new(age: 21, gender: 'm')
    expect(person.inspect).to eq '#<Person age=21>'
  end

  it 'prints just the class when no args exists' do
    person = Person.new(gender: 'm')
    expect(person.inspect).to eq '#<Person>'
    person = Person.new()
    expect(person.inspect).to eq '#<Person>'
  end
end

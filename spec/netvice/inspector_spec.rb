require "spec_helper"

describe Netvice::Inspector do
  let(:person_class) {
    Person = Class.new do
      attr_accessor :name, :age, :gender
      include Netvice::Inspector
      include Netvice::Initable

      def inspect
        inspector([:name, :age])
      end
    end
    Person
  }

  after do
    Object.send(:remove_const, :Person)
  end

  it 'prints name and age properly when both exist' do
    person = person_class.new(name: 'Sun', age: 21, gender: 'm')
    expect(person.inspect).to eq '#<Person name=Sun age=21>'
  end

  it 'prints name when only it exists' do
    person = person_class.new(name: 'Sun', gender: 'm')
    expect(person.inspect).to eq '#<Person name=Sun>'
  end

  it 'prints age when only it exists' do
    person = person_class.new(age: 21, gender: 'm')
    expect(person.inspect).to eq '#<Person age=21>'
  end

  it 'prints just the class when no args exists' do
    person = person_class.new(gender: 'm')
    expect(person.inspect).to eq '#<Person>'
    person = person_class.new()
    expect(person.inspect).to eq '#<Person>'
  end
end

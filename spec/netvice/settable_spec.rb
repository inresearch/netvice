require "spec_helper"

describe Netvice::Settable do
  class Something
    attr_accessor :name, :age
    include Netvice::Settable
  end

  subject { Something.new }

  it 'allow to set attributes in bulk' do
    expect(subject.name).to be_nil
    expect(subject.age).to be_nil
    subject.set name: "Adam", age: 21
    expect(subject.name).to eq "Adam"
  end

  it 'allows set inexistent variables and nothing will change' do
    subject.set noname: "Adam", noage: 21
    expect(subject.name).to be_nil
    expect(subject.age).to be_nil
    expect(subject.respond_to?(:noname)).to be false
    expect(subject.respond_to?(:noage)).to be false
  end
end

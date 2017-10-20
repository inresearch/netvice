require "spec_helper"

describe Netvice::Dimensionable do
  let(:dims) { described_class::DIMS }
  let(:person_class) {
    Class.new do
      include Netvice::Dimensionable
      include Netvice::Initable
      attr_accessor :name

      dim :age, as: :fixnum, nullable: false
      dim :profile_picture, as: :string
      dim :is_banned, as: :boolean, nullable: false
    end
  }

  subject { person_class.new }
  let(:profile_picture_url) { "http://example.com/me.jpg" }
  before { subject.set(age: 25, profile_picture: profile_picture_url, is_banned: false) }

  it 'stores dims data' do
    expect(dims[person_class].keys).to eq [:age, :profile_picture, :is_banned]
    expect(dims[person_class][:age].as).to eq :fixnum
    expect(dims[person_class][:age].nullable).to eq false
    expect(dims[person_class][:profile_picture].as).to eq :string
    expect(dims[person_class][:profile_picture].nullable).to eq true
    expect(dims[person_class].keys).to_not include(:name)
  end

  it 'can set dim data with setter' do
    subject.age = 25
    subject.profile_picture = profile_picture_url
    expect(subject.age).to eq 25
    expect(subject.profile_picture).to eq profile_picture_url
  end

  it 'can set dim data through initialization' do
    subject = person_class.new(
      age: 25,
      profile_picture: profile_picture_url
    )
    expect(subject.age).to eq 25
    expect(subject.profile_picture).to eq profile_picture_url
  end

  it 'cannot accept value it supposed not to accept' do
    expect { subject.age = profile_picture_url }.to raise_error(Netvice::WrongDimension)
    expect { subject.age = 20.5 }.to_not raise_error
  end

  it 'cannot accept nul when not nullable' do
    expect { subject.age = nil }.to raise_error(Netvice::WrongDimension)
    expect { subject.profile_picture = nil }.to_not raise_error
  end

  describe '#instance_dimensions' do
    it 'gives all dimension fields as hash' do
      expect(subject.instance_dimensions).to eq({
        age: "25",
        profile_picture: profile_picture_url,
        is_banned: 0
      })
    end
  end

  describe '#load_dimensions' do
    it 'can convert to proper value' do
      subject = person_class.new
      expect(subject.age).to be_nil
      expect(subject.profile_picture).to be_nil
      expect(subject.is_banned).to be_nil

      subject.load_dimensions({
        age: "25",
        profile_picture: profile_picture_url,
        is_banned: 0
      })
      expect(subject.age).to eq 25
      expect(subject.profile_picture).to eq profile_picture_url
      expect(subject.is_banned).to eq false
    end
  end
end

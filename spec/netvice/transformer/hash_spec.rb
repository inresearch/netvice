require "spec_helper"

describe Netvice::Transformer::Hash do
  subject { described_class }

  it "#deep_symbolize_keys" do
    data = {
      'data' => {
        'student' => {
          'name' => 'Adam',
          'age' => 24
        },
        Integer => 'integer',
        2 => 2
      }
    }

    expect(subject.deep_symbolize_keys(data)).to eq({:data=>{
      :student=>{:name=>"Adam", :age=>24},
      Integer=>"integer",
      2=>2}
    })
  end
end

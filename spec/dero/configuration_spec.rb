require 'spec_helper'

describe Dero::Configuration do
  let(:conf) { Netvice.conf }
  after { Netvice.reset_configuration! }

  describe '#workdir' do
    context 'no rails' do
      it 'returns pwd' do
        expect(Dir.pwd).to_not eq ""
        expect(Dir.pwd).to_not be_nil
        expect(conf.dero.workdir).to eq Dir.pwd
      end
    end

    context 'in rails' do
      it 'returns root' do
        module Rails
          extend self
          def root
            "someroot"
          end
        end
        expect(conf.dero.workdir).to eq "someroot"
        Object.send(:remove_const, :Rails)
        expect(Object.constants.include?(:Rails)).to be false
      end
    end

    it 'resets the in app pattern if workdir is changed' do
      allow(Dir).to receive(:pwd).and_return("somedir")
      old_pattern = %Q{(?-mix:^(somedir\\/)?(?-mix:(bin|exe|app|config|lib|test)))}
      new_pattern = %Q{(?-mix:^(newdir\\/)?(?-mix:(bin|exe|app|config|lib|test)))}
      expect(Dero::Kernel::Line.in_app_pattern.to_s).to eq old_pattern
      conf.dero.workdir "newdir"
      expect(Dero::Kernel::Line.in_app_pattern.to_s).to eq new_pattern
    end
  end

  it 'fails' do
    expect(20).to eq 25
  end
end

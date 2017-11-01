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
        conf = Netvice::Configuration.new 
        expect(conf.dero.workdir).to eq "someroot"
        Object.send(:remove_const, :Rails)
        expect(Object.constants.include?(:Rails)).to be false
      end
    end

    it 'resets the in app pattern if workdir is changed' do
      allow(Dir).to receive(:pwd).and_return("somedir")
      old_pattern = %Q{(?-mix:^(somedir\\/)?(?-mix:(bin|exe|app|config|lib|test)))}
      new_pattern = %Q{(?-mix:^(newdir\\/)?(?-mix:(bin|exe|app|config|lib|test)))}
      Netvice.reset_configuration!
      expect(Dero::Kernel::Line.in_app_pattern.to_s).to eq old_pattern
      conf.dero.workdir "newdir"
      expect(Dero::Kernel::Line.in_app_pattern.to_s).to eq new_pattern
    end

    it 'resets the http headers regex if masked_http_headers is changed' do
      expect(Dero::Processor::HttpHeaders.fields_re.to_s).to eq %Q{(?i-mx:Authorization)}
      conf.dero.masked_http_headers ['A', 'B']
      expect(Dero::Processor::HttpHeaders.fields_re.to_s).to eq %Q{(?i-mx:A|B)}
    end

    it 'resets the fields regex if masked_fields is changed, and append the masked fields instead of replace' do
      expect(Dero::Processor::SensitiveMasker.fields_re.to_s).to eq %Q{(?i-mx:authorization|password|passwd|pass|secret|ssn|social(.*)?sec)}
      conf.dero.masked_fields ['when_will_you_marry']
      expect(Dero::Processor::SensitiveMasker.fields_re.to_s).to eq %Q{(?i-mx:authorization|password|passwd|pass|secret|ssn|social(.*)?sec|\\bwhen_will_you_marry\\b)}
    end

    it 'excludes from masked fields if it is in unmasked_fields' do
      expect(Dero::Processor::SensitiveMasker.fields_re.to_s).to eq %Q{(?i-mx:authorization|password|passwd|pass|secret|ssn|social(.*)?sec)}
      conf.dero.unmasked_fields ['password']
      expect(Dero::Processor::SensitiveMasker.fields_re.to_s).to eq %Q{(?i-mx:authorization|passwd|pass|secret|ssn|social(.*)?sec)}
    end
  end
end

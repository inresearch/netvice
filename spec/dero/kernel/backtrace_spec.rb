require "spec_helper"

describe Netvice::Dero::Kernel::Backtrace do
  let(:trace) {[
    "/Users/wegodev/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/pry-0.11.1/lib/pry/pry_instance.rb:355:in `eval'",
    "/Users/wegodev/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/pry-0.11.1/lib/pry/pry_instance.rb:355:in `evaluate_ruby'",
    "/Users/wegodev/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/pry-0.11.1/lib/pry/pry_instance.rb:323:in `handle_line'",
    "/Users/wegodev/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/pry-0.11.1/lib/pry/repl.rb:77:in `block in repl'",
    "/Users/wegodev/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/pry-0.11.1/lib/pry/input_lock.rb:61:in `__with_ownership'",
    "/Users/wegodev/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/pry-0.11.1/lib/pry/input_lock.rb:79:in `with_ownership'",
    "/Users/wegodev/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/pry-0.11.1/lib/pry/repl.rb:38:in `start'",
    "/Users/wegodev/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/pry-0.11.1/lib/pry/repl.rb:13:in `start'",
    "/Users/wegodev/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/pry-0.11.1/lib/pry/pry_class.rb:192:in `start'",
    "/Users/wegodev/sup/netvice/spec/dero/kernel/backtrace_spec.rb:8:in `block (2 levels) in <top (required)>'",
  ]}

  subject { described_class.parse(trace) }

  it '#lines' do
    expect(subject.lines.first).to be_a Netvice::Dero::Kernel::Line
  end

  it '#to_s' do
    expect(subject.to_s).to eq %Q{/Users/wegodev/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/pry-0.11.1/lib/pry/pry_instance.rb:355:in `eval'
/Users/wegodev/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/pry-0.11.1/lib/pry/pry_instance.rb:355:in `evaluate_ruby'
/Users/wegodev/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/pry-0.11.1/lib/pry/pry_instance.rb:323:in `handle_line'
/Users/wegodev/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/pry-0.11.1/lib/pry/repl.rb:77:in `block in repl'
/Users/wegodev/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/pry-0.11.1/lib/pry/input_lock.rb:61:in `__with_ownership'
/Users/wegodev/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/pry-0.11.1/lib/pry/input_lock.rb:79:in `with_ownership'
/Users/wegodev/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/pry-0.11.1/lib/pry/repl.rb:38:in `start'
/Users/wegodev/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/pry-0.11.1/lib/pry/repl.rb:13:in `start'
/Users/wegodev/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/pry-0.11.1/lib/pry/pry_class.rb:192:in `start'
/Users/wegodev/sup/netvice/spec/dero/kernel/backtrace_spec.rb:8:in `block (2 levels) in <top (required)>'}
  end

  it '#==' do
    subject2 = described_class.new(trace)
    expect(subject).to be == subject2
  end
end

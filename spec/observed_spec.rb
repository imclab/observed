require 'spec_helper'
require 'observed'
require 'observed/builtin_plugins'

describe Observed do
  include FakeFS::SpecHelpers

  describe '#load!`' do

    context 'with a relative file path under the current working directory' do

      subject do
        mod = Module.new do
          extend Observed
        end
        mod.load! './observed.rb'
        mod.config
      end

      context 'with invalid file path' do
        it 'should raise an error while loading' do
          expect { subject }.to raise_error(%r|No such file or directory.+observed\.rb|)
        end
      end

      context 'with a valid relative file path' do
        before do
          File.open('./observed.rb', 'w') do |file|
            file.write(
                <<-EOS
                report /foo/, via: 'stdout'
                EOS
            )
          end
        end

        it 'should load observed.rb' do
          expect { subject }.to_not raise_error
        end
      end
    end

    context 'with an absolute file path' do

      subject {
        mod = Module.new do
          extend Observed
        end
        mod.load! '/tmp/foo/observed_conf.rb'
        mod.config
      }

      context 'when the file does not exist' do

        it 'fails to load it' do
          expect { subject }.to raise_error(%r|No such file or directory - /tmp/foo/observed_conf.rb|)
        end
      end

      context 'when the file exists' do

        before {
          FileUtils.mkdir_p('/tmp/foo')
          File.open('/tmp/foo/observed_conf.rb', 'w') do |f|
            f.write(
                <<-EOS
                report /foo/, via: 'stdout'
                EOS
            )
          end
        }

        it 'succeeds to load it' do
          expect { subject }.to_not raise_error
        end
      end
    end
  end
end

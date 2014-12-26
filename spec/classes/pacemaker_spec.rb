require 'spec_helper'

describe 'pacemaker' do

  let (:params) { {
    :pacemaker_authkey => 'foo',
    :pacemaker_nodes   => ['foo', 'bar'],
    :pacemaker_ping    => '0.0.0.0',
    :pacemaker_hacf    => 'pacemaker/ha.cf.erb',
  } }

  context 'when on an unknown OS' do
    let (:facts) { {
      :operatingsystem => 'SunOS',
      :osfamily        => 'SunOS',
    } }

    it 'should fail' do
      expect { should compile }.to raise_error(/Unsupported operating system/)
    end
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'when not passing parameters' do
        let (:params) { { } }

        it 'should fail' do
          expect { should compile }.to raise_error(/Must pass/)
        end
      end

      context 'when passing mandatory parameters' do
        it { should compile.with_all_deps }
      end
    end
  end
end

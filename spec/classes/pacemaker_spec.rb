require 'spec_helper'
describe 'pacemaker' do
  let (:pre_condition) {
    "Exec { path => '/foo' }"
  }

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
      expect { should compile }.to raise_error(Puppet::Error, /Unsupported operating system/)
    end
  end

  context 'when on Debian' do
    let (:facts) { {
      :operatingsystem => 'Debian',
      :osfamily        => 'Debian',
    } }

    context 'when not passing parameters' do
      let (:params) { { } }

      it 'should fail' do
        expect { should compile }.to raise_error(Puppet::Error, /Must pass/)
      end
    end

    context 'when passing mandatory parameters' do
      it { should compile.with_all_deps }
    end
  end

  context 'when on RedHat' do
    let (:facts) { {
      :operatingsystem => 'RedHat',
      :osfamily        => 'RedHat',
      :architecture    => 'i386',
    } }

    context 'when on unknown RedHat version' do
      let (:facts) { super().merge({
        :lsbmajdistrelease => '4',
      }) }

      it 'should fail' do
        expect { should compile }.to raise_error(Puppet::Error, /not implemented/)
      end
    end

    context 'when on RedHat 5' do
      let (:facts) { super().merge({
        :lsbmajdistrelease => '5',
      }) }

      context 'when not passing parameters' do
        let (:params) { { } }

        it 'should fail' do
          expect { should compile }.to raise_error(Puppet::Error, /Must pass/)
        end
      end

      context 'when passing mandatory parameters' do
        it { should compile.with_all_deps }
      end
    end
  end
end

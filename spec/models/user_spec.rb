require 'spec_helper'

describe User do
  describe 'validations' do
    it { should validate_presence_of(:login) }
    it { should validate_uniqueness_of(:login) }

    context 'if password_required? is true' do
      before { subject.stub(:password_required?) { true } }

      it { should ensure_length_of(:password).is_at_least(Devise.password_length.min).is_at_most(Devise.password_length.max) }
      it { should validate_presence_of(:password) }
      it { should validate_confirmation_of(:password) }
    end

    context 'if password_required? is false' do
      before { subject.stub(:password_required?) { false } }

      it { should_not ensure_length_of(:password).is_at_least(Devise.password_length.min).is_at_most(Devise.password_length.max) }
      it { should_not validate_presence_of(:password) }
      it { should_not validate_confirmation_of(:password) }
    end

    context 'if email_changed? is true' do
      before { subject.stub(:email_changed?) { true } }
      it { should allow_value('user@mail.com', 'my_superuser@lol.com.ua', '').for(:email) }
      it { should_not allow_value('user@mail', 'my_superuser@lol@com.ua').for(:email) }
    end
  end

  describe 'password_required?' do
    context 'if persisted? is true' do
      before { subject.stub(:persisted?) { true } }

      context 'if password is nil' do
        before { subject.password = nil}

        context ' if password_confirmation is nil' do
          before { subject.password_confirmation = nil}
          its(:password_required?) {should be_false}
        end

        context 'if password_confirmation is not nil' do
          before { subject.password_confirmation = '12345678'}
          its(:password_required?) {should be_true}
        end
      end

      context 'if password is not nil' do
        before { subject.password = '12345678'}

        context ' if password_confirmation is nil' do
          before { subject.password_confirmation = nil}
          its(:password_required?) {should be_true}
        end

        context 'if password_confirmation is not nil' do
          before { subject.password_confirmation = '12345678'}
          its(:password_required?) {should be_true}
        end
      end
    end
    context 'if persisted? is false' do
      before { subject.stub(:persisted?) { false } }

      context ' if password_confirmation is nil' do
        before { subject.password_confirmation = nil}
        its(:password_required?) {should be_true}
      end

      context 'if password_confirmation is not nil' do
        before { subject.password_confirmation = '12345678'}
        its(:password_required?) {should be_true}
      end

      context 'if password is nil' do
        before { subject.password = nil}

        context ' if password_confirmation is nil' do
          before { subject.password_confirmation = nil}
          its(:password_required?) {should be_true}
        end

        context 'if password_confirmation is not nil' do
          before { subject.password_confirmation = '12345678'}
          its(:password_required?) {should be_true}
        end
      end

      context 'if password is not nil' do
        before { subject.password = '12345678'}

        context ' if password_confirmation is nil' do
          before { subject.password_confirmation = nil}
          its(:password_required?) {should be_true}
        end

        context 'if password_confirmation is not nil' do
          before { subject.password_confirmation = '12345678'}
          its(:password_required?) {should be_true}
        end
      end
    end
  end
end

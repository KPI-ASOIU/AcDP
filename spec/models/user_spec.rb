require 'spec_helper'

describe User do
  describe 'associations' do
    it { should have_many(:subscriptions) }
    it { should have_many(:documents).through(:user_has_accesses)}
    it { should have_many(:user_has_accesses)}
  end

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

  describe "#roles=" do
    before(:each) { subject.role = 0 }

    context "when passed empty array" do
      before(:each) { subject.roles = [] }
      its(:role) { should eq(0) }
    end

    context "when passed unknown role" do
      before(:each) { subject.roles = ['unknown'] }
      its(:role) { should eq(0) }
    end

    context "when passed ['student']" do
      before(:each) { subject.roles = ["student"] }
      its(:role) { should eq(1) }
    end

    context "when passed ['worker']" do
      before(:each) { subject.roles = ["worker"] }
      its(:role) { should eq(2) }
    end

    context "when passed ['teacher']" do
      before(:each) { subject.roles = ["teacher"] }
      its(:role) { should eq(4) }
    end

    context "when passed ['admin']" do
      before(:each) { subject.roles = ["admin"] }
      its(:role) { should eq(8) }
    end

    context "when passed ['admin', 'teacher']" do
      before(:each) { subject.roles = ["admin", "teacher"] }
      its(:role) { should eq(12) }
    end

    context "when passed ['teacher', 'admin', 'worker']" do
      before(:each) { subject.roles = ["admin", "teacher", "worker"] }
      its(:role) { should eq(14) }
    end
  end

  describe "#roles" do
    context "when role is 0" do
      before(:each) { subject.role = 0 }
      its(:roles) { should match_array([]) }
    end

    context "when role is 1" do
      before(:each) { subject.role = 1 }
      its(:roles) { should match_array(["student"]) }
    end

    context "when role is 2" do
      before(:each) { subject.role = 2 }
      its(:roles) { should match_array(["worker"]) }
    end

    context "when role is 4" do
      before(:each) { subject.role = 4 }
      its(:roles) { should match_array(["teacher"]) }
    end

    context "when role is 8" do
      before(:each) { subject.role = 8 }
      its(:roles) { should match_array(["admin"]) }
    end

    context "when role is 12" do
      before(:each) { subject.role = 12 }
      its(:roles) { should match_array(["admin", "teacher"]) }
    end

    context "when role is 14" do
      before(:each) { subject.role = 14 }
      its(:roles) { should match_array(["admin", "teacher", "worker"]) }
    end
  end

  describe "#has_role?" do
    context "user has role 10" do
      before(:each) { subject.role = 10 }
      it "should not be unknown" do
        expect(subject.has_role? "unknown").to be_false
      end
      it "should not be student" do
        expect(subject.has_role? "student").to be_false
      end
      it "should be worker" do
        expect(subject.has_role? "worker").to be_true
      end
      it "should not be teacher" do
        expect(subject.has_role? "teacher").to be_false
      end
      it "should be admin" do
        expect(subject.has_role? "admin").to be_true
      end
    end
  end

  describe "#add_role" do
    context "when role is 0" do
      before(:each) { subject.role = 0 }

      context "when add_role 'unknown'" do
        it "should not change role" do
          expect(lambda {
            subject.add_role "unknown"
          }).to_not change(subject, :role)
        end
      end

      context "when add_role 'student'" do
        it "should not change role" do
          expect(lambda {
            subject.add_role "student"
          }).to change(subject, :role).by(1)
        end
      end

      context "when add_role 'worker'" do
        it "should not change role" do
          expect(lambda {
            subject.add_role "worker"
          }).to change(subject, :role).by(2)
        end
      end

      context "when add_role 'teacher'" do
        it "should not change role" do
          expect(lambda {
            subject.add_role "teacher"
          }).to change(subject, :role).by(4)
        end
      end


      context "when add_role 'admin'" do
        it "should not change role" do
          expect(lambda {
            subject.add_role "admin"
          }).to change(subject, :role).by(8)
        end
      end
    end

    context "when role is 10" do
      before(:each) { subject.role = 10 }

      context "when add_role 'unknown'" do
        it "should not change role" do
          expect(lambda {
            subject.add_role "unknown"
          }).to_not change(subject, :role)
        end
      end

      context "when add_role 'student'" do
        it "should not change role" do
          expect(lambda {
            subject.add_role "student"
          }).to change(subject, :role).by(1)
        end
      end

      context "when add_role 'worker'" do
        it "should not change role" do
          expect(lambda {
            subject.add_role "worker"
          }).to_not change(subject, :role).by(2)
        end
      end

      context "when add_role 'teacher'" do
        it "should not change role" do
          expect(lambda {
            subject.add_role "teacher"
          }).to change(subject, :role).by(4)
        end
      end


      context "when add_role 'admin'" do
        it "should not change role" do
          expect(lambda {
            subject.add_role "admin"
          }).to_not change(subject, :role).by(8)
        end
      end
    end
  end
  describe "#remove_role" do
    context "when role is 10" do
      before(:each) { subject.role = 10 }

      context "when remove_role 'unknown'" do
        it "should not change role" do
          expect(lambda {
            subject.remove_role "unknown"
          }).to_not change(subject, :role)
        end
      end

      context "when remove_role 'student'" do
        it "should not change role" do
          expect(lambda {
            subject.remove_role "student"
          }).to_not change(subject, :role)
        end
      end

      context "when remove_role 'worker'" do
        it "should not change role" do
          expect(lambda {
            subject.remove_role "worker"
          }).to change(subject, :role).by(-2)
        end
      end

      context "when remove_role 'teacher'" do
        it "should not change role" do
          expect(lambda {
            subject.remove_role "teacher"
          }).to_not change(subject, :role)
        end
      end


      context "when remove_role 'admin'" do
        it "should not change role" do
          expect(lambda {
            subject.remove_role "admin"
          }).to change(subject, :role).by(-8)
        end
      end
    end
  end
end

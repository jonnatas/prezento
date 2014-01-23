require 'spec_helper'

describe Configuration do
  subject { FactoryGirl.build(:configuration) }
  describe 'methods' do
    describe 'persisted?' do
      before :each do
        Configuration.expects(:exists?).with(subject.id).returns(false)
      end

      it 'should return false' do
        subject.persisted?.should eq(false)
      end
    end

    describe 'update' do
      before :each do
        @subject_params = Hash[FactoryGirl.attributes_for(:configuration).map { |k,v| [k.to_s, v.to_s] }] #FIXME: Mocha is creating the expectations with strings, but FactoryGirl returns everything with sybols and integers
      end

      context 'with valid attributes' do
        before :each do
          subject.expects(:save).returns(true)
        end

        it 'should return true' do
          subject.update(@subject_params).should eq(true)
        end
      end

      context 'with invalid attributes' do
        before :each do
          subject.expects(:save).returns(false)
        end

        it 'should return false' do
          subject.update(@subject_params).should eq(false)
        end
      end
    end
  end

  describe 'validations' do
    context 'active model validations' do  
      before :each do
        Configuration.expects(:all).at_least_once.returns([])
      end
      it { should validate_presence_of(:name) }
    end

    context 'kalibro validations' do
      before :each do
        Configuration.expects(:request).returns(42)
      end

      it 'should validate uniqueness' do
        KalibroUniquenessValidator.any_instance.expects(:validate_each).with(subject, :name, subject.name)
        subject.save
      end
    end
  end
end
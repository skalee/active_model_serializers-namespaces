require "spec_helper"

describe "When serializing objects in controller's #render method", type: :controller do

  class Model
    include ActiveModel::Serializers::JSON
    include ActiveModel::SerializerSupport

    def name
      "I'm a PORO model!"
    end

    def serializable_hash options = {}
      {name: name, serialized_by: "Skipping AMS"}
    end
  end

  class ModelSerializer < ActiveModel::Serializer
    attributes :name, :serialized_by

    def serialized_by
      "Unscoped"
    end
  end

  module Version1
    class Version1::ModelSerializer < ActiveModel::Serializer
      attributes :name, :serialized_by

      def serialized_by
        "Version 1"
      end
    end
  end

  module Version2
  end

  #####

  controller do
    include Rails.application.routes.url_helpers

    def show
      render json: Model.new
    end
  end

  before do
    routes.draw do
      get ':controller/:action', format: :json
    end

    allow(controller).to receive(:default_serializer_options){ options }
  end

  #####

  let(:serialization_result){ JSON.parse response.body, symbolize_names: true }
  let(:options){ {root: false} }


  context "and when :serialization_namespace is unspecified" do
    it "searches for serializer in the root namespace" do
      get :show
      expect(serialization_result).to eq(name: "I'm a PORO model!", serialized_by: "Unscoped")
    end

    it "always uses serializer specified with :serializer when such option is present" do
      options.merge! serializer: ::ModelSerializer
      get :show
      expect(serialization_result).to eq(name: "I'm a PORO model!", serialized_by: "Unscoped")
    end
  end

  context "and when :serialization_namespace is specified" do
    it "searches for serializer in that namespace and uses it when found" do
      options.merge! serialization_namespace: Version1
      get :show
      expect(serialization_result).to eq(name: "I'm a PORO model!", serialized_by: "Version 1")
    end

    it "searches for serializer in that namespace and uses a default serializer when not found" do
      options.merge! serialization_namespace: Version2
      get :show
      expect(serialization_result).to eq(name: "I'm a PORO model!", serialized_by: "Skipping AMS")
    end

    it "always uses serializer specified with :serializer when such option is present" do
      options.merge! serialization_namespace: Version1, serializer: ::ModelSerializer
      get :show
      expect(serialization_result).to eq(name: "I'm a PORO model!", serialized_by: "Unscoped")
    end
  end

end

require "spec_helper"

describe "When serializing objects in controller's #render method,", type: :controller do

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


  it "searches for serializer in the root namespace when serialization namespace is not specified" do
    get :show
    expect(serialization_result).to eq(name: "I'm a PORO model!", serialized_by: "Unscoped")
  end

  it "searches for serializer in the specified namespace and uses it if found" do
    options.merge! serialization_namespace: Version1
    get :show
    expect(serialization_result).to eq(name: "I'm a PORO model!", serialized_by: "Version 1")
  end

  it "uses a default serializer when none found in the specified namespace" do
    options.merge! serialization_namespace: Version2
    get :show
    expect(serialization_result).to eq(name: "I'm a PORO model!", serialized_by: "Skipping AMS")
  end

  it "always uses serializer specified with :serializer option when such option is present" do
    options.merge! serialization_namespace: Version1, serializer: ::ModelSerializer
    get :show
    expect(serialization_result).to eq(name: "I'm a PORO model!", serialized_by: "Unscoped")
  end

end

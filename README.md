# ActiveModelSerializer::Namespaces

[![Version][badge-version]][about-version]
[![Issues][badge-issues]][about-issues]
[![Build][badge-travis]][about-travis]
[![Climate][badge-climate]][about-climate]
[![Coverage][badge-coverage]][about-coverage]

## Compatibility note

This gem is designed for Active Model Serializers 0.8.x only.

Although newer versions of AMS are also available, currently 0.8.x is
[most recommended for new projects][ams-maintenance].

## When is it useful?

Short answer: when you need more than one way to serialize your models and
you want to organize that in namespaces.

For example, your application is serving a versioned API.  You want to
freeze the old API formats and actively develop upcoming version.

For example, your application is utilizing few 3rd-party services which expect
JSONs as input, so you need to convert your models somehow, preferably avoiding
mixing these integrations.

In all these cases the most natural approach is to define a separate set of
serializers for every API version or integration.  But then you discover that
you need to pass serializer name every time you use it.  Even `#has_many`
declarations in serializers require that.  And what will you do to serialize
a collection of objects of different classes?

With ActiveModelSerializer-Namespaces you can nest your serializers in modules
with no pain.  Just pass namespace of your choice and it will be used throughout
complex models and collections.  What's more, you don't need to type it in
actions, just specify it as default for the whole API version.

Creating brand new API version is again as easy as copying code to new location.

## How do I use it?

Given:

    class Article < ActiveRecord::Base
    end

    module V1
      class ArticleSerializer < ActiveModel::Serializer
      end
    end

Either specify namespace directly at `render` call:

    def some_action
      render json: article, serialization_namespace: Ver1
    end

Or set it as a default option in controller:

    def some_action
      render json: article
    end

    def default_serializer_options
      {serialization_namespace: Ver1}
    end

See [`spec/features_spec.rb`][spec-features] for more detailed examples.

## How does it works (caveats)?

The trick is to delay inferring serializer class until `#new` is called and
options hash is available.

To achieve that, `::active_model_serializer` is defined for all models, however
it returns a finder proxy object instead of serializer class.  The finder
instance performs lookup for serializer class and instantiates the serializer
in the response to `#new` call, therefore it's transparent for
Active Model Serializer internals.

As a consequence, overriding `#active_model_serializer`
or `::active_model_serializer` disables this gem for given model.

## Why it is a separate gem?

I did want to solve one of the biggest drawbacks of Active Model Serializers
0.8.  I didn't want to introduce backwards-incompatible changes into it's API.

## Contributing

Fork it, improve it then create a pull request.  You know the drill.

## See also

*   Active Model Serializers issue tracker, particularly [#144][ams-issue-144],
    but also: [#562][ams-issue-562], [#671][ams-issue-671],
    [#735][ams-issue-735] and more.
*   [ActiveModel::VersionSerializer][ams-contrib-version] — different approach
    to solve the problem

[ams-maintenance]: https://github.com/rails-api/active_model_serializers#maintenance-please-read
[ams-contrib-version]: https://github.com/hookercookerman/active_model_version_serializers
[ams-issue-144]: https://github.com/rails-api/active_model_serializers/issues/144
[ams-issue-562]: https://github.com/rails-api/active_model_serializers/issues/562
[ams-issue-671]: https://github.com/rails-api/active_model_serializers/issues/671
[ams-issue-735]: https://github.com/rails-api/active_model_serializers/issues/735
[spec-features]: https://github.com/skalee/active_model_serializers-namespaces/blob/master/spec/features_spec.rb

[about-climate]: https://codeclimate.com/github/skalee/active_model_serializers-namespaces
[about-coverage]: https://coveralls.io/r/skalee/active_model_serializers-namespaces
[about-issues]: https://github.com/skalee/active_model_serializers-namespaces/issues
[about-travis]: https://travis-ci.org/skalee/active_model_serializers-namespaces
[about-version]: https://rubygems.org/gems/active_model_serializer-namespaces
[badge-climate]: https://img.shields.io/codeclimate/github/skalee/active_model_serializers-namespaces.svg
[badge-coverage]: https://img.shields.io/coveralls/skalee/active_model_serializers-namespaces.svg
[badge-issues]: https://img.shields.io/github/issues-raw/skalee/active_model_serializers-namespaces.svg
[badge-travis]: https://img.shields.io/travis/skalee/active_model_serializers-namespaces.svg
[badge-version]: https://img.shields.io/gem/v/active_model_serializer-namespaces.svg

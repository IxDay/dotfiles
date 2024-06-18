#!/bin/env mruby

raise NotImplementedError, "you must install 'Rake'" unless Object.const_defined?(:Rake)

self.extend Rake::DSL

Rake.application.run
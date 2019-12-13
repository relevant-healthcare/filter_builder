require 'recursive-open-struct'

require 'filter_builder/operator_factory'
require 'filter_builder/field'
require 'filter_builder/where_clause'
require 'filter_builder/where_chain'
require 'filter_builder/filter'
require 'filter_builder/form'
require 'filter_builder/core_ext'
require 'filter_builder/operators/nil_operator'

module FilterBuilder
  require 'filter_builder/operators/equals_operator'
  require 'filter_builder/operators/matches_case_insensitive_operator'
  require 'filter_builder/operators/matches_case_sensitive_operator'
end

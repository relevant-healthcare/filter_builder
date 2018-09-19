class VisitType < ActiveHash::Base
  include ActiveHash::Enum

  enum_accessor :name

  self.data = [
    {
      id: 1,
      name: 'medical'
    },
    {
      id: 2,
      name: 'dental'
    }
  ]
end

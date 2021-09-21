# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { 'MyString' }
    password_digest { 'MyString' }
  end
end

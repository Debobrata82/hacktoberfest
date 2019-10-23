# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name              { 'Testerson McTest' }
    email             { 'test@mail.com' }
    uid               { rand(1..1_000_000) }
    provider_token    { user_github_token }
    terms_acceptance  { true }
    state             { 'registered' }

    trait :new do
      terms_acceptance { false }
      state { 'new' }
    end

    trait :no_email do
      email { nil }
    end

    trait :waiting do
      state { 'waiting' }
      waiting_since { Time.zone.today }

      after :build do |user|
        allow(user).to receive(:eligible_pull_requests_count).and_return(4)
      end
    end

    trait :completed do
      state { 'completed' }
      receipt { {"test": "test" }.to_json }

      after :build do |user|
        allow(user).to receive(:eligible_pull_requests_count).and_return(4)
        allow(user).to receive(:waiting_since).and_return(Time.zone.today - 8)
      end
    end

    trait :incompleted do
      state { 'incompleted' }

      after :build do |user|
        allow(user).to receive(:eligible_pull_requests_count).and_return(3)
        allow(user).to receive(:waiting_since).and_return(Time.zone.today - 8)
      end
    end

    trait :won_shirt do
      state { 'won_shirt' }
      shirt_coupon
    end

    trait :won_sticker do
      state { 'won_sticker' }
      sticker_coupon
    end

    after :build do |user|
      allow(user).to receive(:github_emails).and_return([user.email])
    end
  end
end

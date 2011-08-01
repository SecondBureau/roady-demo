Sham.define do
  name{Forgery::LoremIpsum.words(6 , :random => true)}
  username{Forgery::Name.full_name}
  password{Forgery::Basic.password(:at_least => 6, :at_most => 10)}
  email{Forgery::Internet.email_address}
  token{Forgery::Basic.text}
  provider{%w[facebook twitter].sample}
end
Account.blueprint do
  username 
  email
  password
  password_confirmation {self.password}
end
Authentication.blueprint{
  account {Account.make}
  provider
  access_token  {Sham.token}
  uid {rand(10)+1}
}

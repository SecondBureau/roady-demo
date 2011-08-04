if Rails.env.development? or Rails.env.test?
  require "md5"
else
  require "digest/md5"
  MD5 = Digest::MD5
end


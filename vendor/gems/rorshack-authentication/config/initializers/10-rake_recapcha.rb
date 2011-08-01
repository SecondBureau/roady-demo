#Domain Name:	beijing.secondbureau.com
#Public Key:	6Lc518MSAAAAAPiHmZ8pMFfiwS0CU8k6Fyz-Zr0t
#Private Key:	6Lc518MSAAAAACS-V0Jz76LxHKUKYqQhDLRYck8l
Rails.application.config.middleware.use Rack::Recaptcha, 
      :public_key => ENV["recaptcha_key"] || '6Lc518MSAAAAAPiHmZ8pMFfiwS0CU8k6Fyz-Zr0t', 
      :private_key => ENV["recaptcha_secret"] || '6Lc518MSAAAAACS-V0Jz76LxHKUKYqQhDLRYck8l'

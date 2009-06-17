module Authlogic
  module CryptoProviders
    # See the admonishment in the MD5 provider.
    #
    # Use another provider. Seriously.
    class ReverseMD5 < MD5
      def self.encrypt(*tokens)
        # just reverse the order for now
        super(tokens.flatten.reverse)
      end
    end
  end
end
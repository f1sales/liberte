require "liberte/version"

require "f1sales_custom/parser"
require "f1sales_custom/source"
require "f1sales_helpers"

module Liberte
  class Error < StandardError; end
  class F1SalesCustom::Email::Source
    def self.all
      [
        {
          email_id: 'website',
          name: 'Website - Seminovos'
        }
      ]
    end

    def self.support?(_email_id)
      true
    end
  end
  class F1SalesCustom::Email::Parser
    def parse
      parsed_email = @email.body.colons_to_hash(/(Telefone|Nome|E-mail|Mensagem|veículo|&raquo;).*?:/, false)
      source_name = F1SalesCustom::Email::Source.all[0][:name]

      {
        source: {
          name: source_name
        },
        customer: {
          name: parsed_email['nome'],
          phone: parsed_email['telefone'].tr('^0-9', ''),
          email: parsed_email['email']
        },
        product: (parsed_email['veculo'] || '').split("\n").first.strip,
        description: '',
        message: parsed_email['mensagem']
      }
    end
  end
end

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
        },
        {
          email_id: 'website',
          name: 'Website - Novos'
        }
      ]
    end

    def self.support?(email_id)
      email_id == 'website'
    end
  end
  
  class F1SalesCustom::Email::Parser
    def parse
      parsed_email = @email.body.colons_to_hash(/(Telefone|Nome|Loja|Modelo|E-mail|Mensagem|veículo|&raquo;).*?:/, false)
      vechicle = (parsed_email['veculo'] || parsed_email['modelo'] || '').split("\n").first
      store_name = parsed_email['loja']

      sources = F1SalesCustom::Email::Source.all
      source_name = store_name ? "#{sources[1][:name]} - #{store_name}" : sources[0][:name]

      {
        source: {
          name: source_name
        },
        customer: {
          name: parsed_email['nome'],
          phone: parsed_email['telefone'].tr('^0-9', ''),
          email: parsed_email['email']
        },
        product: { name: vechicle.strip },
        description: '',
        message: parsed_email['mensagem']
      }
    end
  end
end

require 'ostruct'
require "f1sales_custom/parser"
require "f1sales_custom/source"

RSpec.describe F1SalesCustom::Email::Parser do
  context 'when is about used vechicle' do
    let(:email){
      email = OpenStruct.new
      email.to = [email: 'website@liberte.f1sales.net']
      email.subject = 'SEMINOVOS - TESTANDO LEAD SITE'
      email.body = "E-mail\n\n\n\n\n    \n    \n    \n        \n            \n                \n                    \n                        SEMINOVOS - TESTANDO LEAD SITE\n                        \n                            Nome: TESTANDO LEAD SITE \n                            E-mail: teste@teste.com.br \n                            Telefone: (47) 98888-3120 \n                            Mensagem: Tenho interesse no veículo: Renault Stepway 1.6 8v ano 2014 em Blumenau/SC \n\n                            \n            &raquo; Acessar ve&iacute;culo"

      email
    }

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains lead website a source name' do
      expect(parsed_email[:source][:name]).to eq('Website - Seminovos')
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq('TESTANDO LEAD SITE')
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq('47988883120')
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq('teste@teste.com.br')
    end
  end
end

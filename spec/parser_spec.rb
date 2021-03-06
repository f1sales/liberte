require 'ostruct'
require "f1sales_custom/parser"
require "f1sales_custom/source"

RSpec.describe F1SalesCustom::Email::Parser do
  context 'when is about new vechicle' do
    let(:email){
      email = OpenStruct.new
      email.to = [email: 'website@liberte.f1sales.net']
      email.subject = 'TENHO INTERESSE - Marcio Teste'
      email.body = "<http://liberte.com.br/>\nTENHO INTERESSE - Marcio Teste\n\nNome: Marcio Teste\nE-mail: marcio@teste.com.br\nTelefone: (11) 99999-9999\nModelo: CAPTUR\nLoja: Itajaí\nMensagem: Lead teste"
      email
    }

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains lead website a new source name' do
      expect(parsed_email[:source][:name]).to eq('Website - Novos - Itajaí')
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq('Marcio Teste')
    end

    it 'contains product' do
      expect(parsed_email[:product]).to eq('CAPTUR')
    end
  end

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

    it 'contains product' do
      expect(parsed_email[:product]).to eq('Renault Stepway 1.6 8v ano 2014 em Blumenau/SC')
    end

    it 'contains message' do
      expect(parsed_email[:message]).to eq('Tenho interesse no')
    end
  end
end

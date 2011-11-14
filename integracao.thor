require "rubygems"
require "bundler/setup"

require 'extensions'

Bundler.require(:default)

class Integracao < Thor
  desc "envia", "envia dados do banco Firebird local para uma instância do Sistema de Esquadrias"

  def envia(host, chave, banco_firebird, host_firebird = 'localhost', usuario = 'sysdba', senha = 'masterkey')
    dados = { :host => host_firebird, :user => usuario, :password => senha, :encoding => 'ISO-8859-1' }
    puts "Conectando com: #{dados.inspect}"
    db = Sequel.firebird banco_firebird, dados

    db_obras = db[:obra].left_outer_join(:cidade, :id_cidade => :obr_id_cidade)

    builder = Builder::XmlMarkup.new :indent => 2
    xml = builder.integracao do |integracao|
      integracao.data_extracao(DateTime.now)
      integracao.obras do |obras|
        db_obras.each do |db_obra|
          obras.obra :id_cem => db_obra[:id_obra] do |obra|
            obra.codigo(db_obra[:obr_codigo]) if db_obra[:obr_codigo]
            obra.nome(db_obra[:obr_nome]) if db_obra[:obr_nome]
            obra.cadastro_usuario(db_obra[:id_usuario_cadastro]) if db_obra[:id_usuario_cadastro]
            obra.cadastro_data(db_obra[:obr_data_cadastro].to_datetime) if db_obra[:obr_data_cadastro].to_datetime
            obra.atualizacao_usuario(db_obra[:id_usuario_atualizacao]) if db_obra[:id_usuario_atualizacao]
            obra.atualizacao_data(db_obra[:obr_data_alteracao].to_datetime) if db_obra[:obr_data_alteracao]
            obra.endereco(db_obra[:obr_endereco]) if db_obra[:obr_endereco]
            obra.cidade db_obra[:cid_nome], :id_cem => db_obra[:obr_id_cidade], :ibge => db_obra[:idibge] if db_obra[:obr_id_cidade]
            obra.bairro(db_obra[:obr_bairro]) if db_obra[:obr_bairro]
            obra.cep(db_obra[:obr_cep]) if db_obra[:obr_cep]
            obra.tel(db_obra[:obr_tel]) if db_obra[:obr_tel]
            obra.fax(db_obra[:obr_fax]) if db_obra[:obr_fax]
            obra.contato(db_obra[:obr_contato]) if db_obra[:obr_contato]
          end
        end
      end
    end

    puts xml
  end
end

require "rubygems"
require "bundler/setup"

Bundler.require(:default)

require 'extensions'

get '/obras/:codigo' do
  content_type 'text/xml'

  Esquadrias.obra(params[:codigo])
end

#noinspection RubyConstantNamingConvention,RubyResolve
module Esquadrias
  DB = Sequel.firebird('/opt/CW30.FDB', :host => 'localhost', :user => 'sysdba', :password => 'masterkey', :encoding => 'ISO-8859-1')

  def self.obra(codigos)
    codigos = codigos.split(',') unless codigos.is_a?(Array)

    db_obras = DB[:obra].left_outer_join(:cidade, :id_cidade => :obr_id_cidade).where(:obr_codigo => codigos)

    builder = Builder::XmlMarkup.new :indent => 2
    builder.integracao do |integracao|
      integracao.meta do |meta|
        meta.data_extracao(DateTime.now)
      end

      integracao.obras do |obras|
        db_obras.all.each do |db_obra|
          obras.obra :id_cem => db_obra[:id_obra] do |obra|
            obra.dump_hash! db_obra, :obr_codigo => :codigo, :obr_nome => :nome,
                            :id_usuario_cadastro => :cadastrado_por, :obr_data_cadastro => :cadastrado_em,
                            :id_usuario_atualizacao => :atualizado_por, :obr_data_alteracao => :atualizado_em,
                            :obr_endereco => :endereco

            obra.cliente :id_cem => db_obra[:id_cliente_obra] do |cli|
              DB[:cliente].where(:id_cliente => db_obra[:id_cliente_obra]).all.each do |db_cliente|
                cli.dump_hash! db_cliente, :cli_nome => :nome, :cli_tipo => :tipo,
                               :cli_cpf_cnpj => :cpf_cnpj, :cli_rg => :rg,
                               :cli_desde => :cliente_desde,
                               :cli_data_cadastro => :cadastrado_em, :id_usuario_cadastro => :cadastrado_por,
                               :cli_data_atualizacao => :atualizado_em, :id_usuario_atualizacao => :atualizado_por,
                               :cli_homepage => :homepage, :cli_email => :email,
                               :cli_obs => :observacao
                cli.ativo db_cliente[:desativado] != 'F'

                cli.enderecos do |ends|
                  DB[:endereco].left_outer_join(:cidade, :id_cidade => :id_cidade).where(:id_cliente => db_cliente[:id_cliente]).all.each do |db_ender|
                    ends.endereco :id_cem => db_ender[:id_endereco] do |ender|
                      ender.cidade db_ender[:cid_nome], :id_cem => db_ender[:id_cidade], :ibge => db_ender[:idibge] if db_ender[:id_cidade]
                      ender.dump_hash! db_ender, :end_tipo => :tipo, :end_endereco => :logradouro, :end_numero => :numero,
                                       :end_bairro => :bairro, :end_cep => :cep, :end_tel => :telefone, :end_fax => :fax
                    end
                  end
                end
              end
            end

            obra.cidade db_obra[:cid_nome], :id_cem => db_obra[:obr_id_cidade], :ibge => db_obra[:idibge] if db_obra[:obr_id_cidade]

            obra.dump_hash! db_obra, :obr_bairro => :bairro, :obr_cep => :cep, :obr_tel => :telefone, :obr_fax => :fax,
                            :obr_contato => :contato

            obra.items do |itens|
              DB[:obitens].where(:id_obra => db_obra[:id_obra]).all.each do |db_item|
                itens.item do |item|
                  item.dump_hash! db_item, :itemobra => :codigo, :descricao => :descricao,
                                  :tipo => :tipo, :localiz => :localizacao, :qtde => :quantidade,
                                  :codesqd => :esquadria_codigo, :especial => :especial,
                                  :codproj => :projeto_codigo, :prenata => :cor, :codtrat => :tratamento,
                                  :cor_vidros => :vidro_cor, :des_vidros => :vidro_descricao
                end
              end
            end
          end
        end
      end

      integracao.usuarios do |usuarios|
        DB[:usuario].each do |db_usuario|
          usuarios.usuario :id_cem => db_usuario[:id_usuario] do |usuario|
            usuario.login db_usuario[:usu_login]
            usuario.ativo db_usuario[:desativado] == 'F'
          end
        end
      end
    end
  end
end

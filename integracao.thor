require "rubygems"
require "bundler/setup"

Bundler.require(:default)

require 'extensions'

::DB = nil

class Integracao < Thor
  desc "envia", "envia dados do banco Firebird local para uma instância do Sistema de Esquadrias"

  def envia(host, chave, db_database, fb_host = 'localhost', fb_usuario = 'sysdba', fb_senha = 'masterkey')
    # TODO: validar validade do host e chave antes de proceder com a leitura, que é um procedimento demorado

    dados = {:host => fb_host, :user => fb_usuario, :password => fb_senha, :encoding => 'ISO-8859-1'}
    ::Object.const_set(:DB, Sequel.firebird(db_database, dados))

    db_obras = DB[:obra].left_outer_join(:cidade, :id_cidade => :obr_id_cidade)

    builder = Builder::XmlMarkup.new :indent => 2
    xml = builder.integracao do |integracao|
      integracao.meta do |meta|
        meta.data_extracao(DateTime.now)
        meta.firebird do |fb|
          fb.host fb_host
          fb.database db_database
          fb.user fb_usuario
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

      integracao.obras do |obras|
        db_obras.all.each do |db_obra|
          obras.obra :id_cem => db_obra[:id_obra] do |obra|
            obra.dump_hash! db_obra, :obr_codigo => :codigo, :obr_nome => :nome,
                            :id_usuario_cadastro => :cadastrado_por, :obr_data_cadastro => :cadastrado_em,
                            :id_usuario_atualizacao => :atualizado_por, :obr_data_alteracao => :atualizado_em,
                            :obr_endereco => :endereco

            obra.cidade db_obra[:cid_nome], :id_cem => db_obra[:obr_id_cidade], :ibge => db_obra[:idibge] if db_obra[:obr_id_cidade]

            obra.dump_hash db_obra, :obr_bairro => :bairro, :obr_cep => :cep, :obr_tel => :telefone, :obr_fax => :fax,
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
    end

    # TODO: quando o XML estiver pronto, enviar ao sistema utilizando o host e chave especificados
    puts xml
  end
end

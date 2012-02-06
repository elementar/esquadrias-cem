# Projeto

Este projeto provê integração do banco de dados do sistema CEM com o Sistema de Esquadrias.

# Instalação

## Dependências

* RVM: http://beginrescueend.com/
* Ruby 1.8.7: `rvm install 1.8.7`
* Git
* Ferramentas cliente do Firebird

## Preparando o Ambiente: Instalando o Ruby

* Criar um gemset para o cem: `rvm gemset create cem`
* Instalar a gema 'bundler', se já não houver sido instalada: `rvm 1.8.7 do gem install bundler`

## Instalando o aplicativo

* Criar um diretório para a aplicação (recomendação: `/apps/esquadrias-cem`);
* Fazer o clone da aplicação: `git clone git@github.com:elementar/esquadrias-cem.git /apps/esquadrias-cem`;
* Alterar o arquivo `esquadrias.rb`, para apontar para o banco Firebird;
* Fazer a instalação das dependências: `cd /apps/esquadrias-cem; bundle install`
* Executar o serviço através do comando: `bundle exec rackup -p 9393`

## Após a Instalação

* Liberar a porta 9393 no _firewall_ da empresa, para o IP: 184.73.155.121
  (pode ser necessário fazer um NAT, consulte o suporte de rede da sua empresa);
* Anotar o IP externo e informar à Elementar, para finalizar a configuração da conta.

# Contato

Em caso de problemas, entrar em contato pelo e-mail: contato@elementarsistemas.com.br

# Copyright

Copyright (c) 2011-2012 Elementar Sistemas Ltda.

# Projeto

Este projeto provê integração do banco de dados do sistema CEM com o Sistema de Esquadrias.

# Instalação

## Dependências

* RVM: http://beginrescueend.com/
* Ruby 1.8.7: `rvm install 1.8.7`
* Git
* Ferramentas cliente do Firebird

## Preparando o Ambiente: Instalando o Ruby

* Ativar a versão 1.8.7 do Ruby: `rvm use 1.8.7`
* Criar um gemset para o cem: `rvm gemset create cem`
* Instalar a gema 'bundler', se já não houver sido instalada: `gem install bundler`

## Instalando o aplicativo

* Criar um diretório para a aplicação (recomendação: `/apps/esquadrias-cem`);
* Fazer o clone da aplicação: `git clone git@github.com:elementar/esquadrias-cem.git /apps/esquadrias-cem`;
* Alterar o arquivo `esquadrias.rb`, para apontar para o banco Firebird;
* Fazer a instalação das dependências: `cd /apps/esquadrias-cem; bundle install`

## Testando a instalação

* Executar, no diretório da aplicação, o comando: `bundle exec rackup -p 9393`
* Tentar acessar pelo navegador o endereço: http://(ip-do-servidor):9393/obras/(codigo), substituindo (ip-do-servidor)
  pelo IP do servidor e (codigo) pelo código de alguma obra válida no CEM.

## Colocando o aplicativo no ar

### Opção 1: comando direto

* Acessar o diretório onde o aplicativo está instalado;
* Executar o serviço através do comando: `nohup bundle exec rackup -p 9393 &`

### Opção 2: Passenger + Apache ou ngnix

* Instale a gema Passenger: `gem install passenger`
* Execute o instalador adequado para seu servidor: `passenger-install-apache2-module` ou `passenger-install-ngnix-module`
* Altere as configurações de seu servidor, seguindo as instruções que o instalador do Passenger informou
* Reinicie seu Apache ou ngnix.

## Após a Instalação

* Liberar a porta no _firewall_ da empresa (9393 para execução direta, 80 para Apache ou ngnix),
  para o IP: 184.73.155.121 (pode ser necessário fazer um NAT, consulte o suporte de rede da sua empresa);
* Anotar o IP externo e porta, e informar à Elementar, para finalizar a configuração da conta.

# Contato

Em caso de problemas, entrar em contato pelo e-mail: contato@elementarsistemas.com.br

# Copyright

Copyright (c) 2011-2012 Elementar Sistemas Ltda.

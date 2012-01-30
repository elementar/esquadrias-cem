= Projeto

Este projeto provê  integração do banco de dados do sistema CEM com o Sistema de Esquadrias.

= Instalação

== Dependências
* RVM: http://beginrescueend.com/
* Ruby 1.8.7: `rvm install 1.8.7`
* Git

== Preparando o Ambiente: Instalando o Ruby

* Criar um gemset para o cem: `rvm gemset create cem`
* Instalar a gema 'bundler', se já não houver sido instalada: `rvm 1.8.7 do gem install bundler`

== Instalando o aplicativo

* Fazer o clone da aplicação para algum local (recomendação: `/apps/esquadrias-cem`);
* Alterar o arquivo `esquadrias.rb`, para apontar para o banco Firebird;
* Fazer a instalação das dependências
* Executar o serviço através do comando: `rackup -p 9393 -d`

= Contato

Em caso de problemas, entrar em contato pelo e-mail: contato@elementarsistemas.com.br

= Copyright

Copyright (c) 2011-2012 Elementar Sistemas Ltda.

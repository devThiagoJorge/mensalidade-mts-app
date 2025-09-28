💳 Mensalidade MTS: Gestão de Contribuições Rotaract
🎯 Visão Geral do Projeto
Mensalidade MTS é um sistema essencial desenvolvido para digitalizar e simplificar a gestão e visualização das mensalidades do Rotaract Club de Matão Terra da Saudade.

O objetivo principal é promover transparência na gestão financeira, permitindo que os associados acompanhem de forma clara suas pendências e que a tesouraria realize o registro de pagamentos de maneira eficiente e rápida.

⚙️ Arquitetura e Tecnologias
O projeto é estruturado como uma aplicação híbrida (Flutter) consumindo uma API robusta em .NET.

💻 Tecnologias (Tech Stack)
Componente

Tecnologia

Padrão / Serviço

Aplicativo (Frontend)

Flutter

Desenvolvimento Híbrido

API (Backend)

.NET

Arquitetura de Três Camadas

Banco de Dados

PostgreSQL

Hospedado e gerenciado via Supabase

📐 Padrão de Arquitetura
O Backend (.NET) utiliza o padrão de projeto Arquitetura de Três Camadas (Three-Layer Architecture) para garantir separação de responsabilidades, manutenibilidade e escalabilidade:

Camada de Apresentação: Lida com a interface do usuário (Flutter) e a comunicação com a API (Controllers).

Camada de Negócios (Business Logic): Contém as regras de negócio do Rotaract (como a geração de mensalidades e as regras de roles).

Camada de Dados (Data Access): Responsável pela persistência, usando o PostgreSQL (Supabase).

✅ Requisitos e Funcionalidades
O sistema foi desenhado para atender às necessidades específicas da gestão de mensalidades e controle de acesso:

1. Gestão de Associados e Pagamentos (Role: Tesoureiro)
Cadastro: Tesoureiros podem cadastrar novos associados no sistema.

Status: Tesoureiros podem inativar ou reativar associados.

Pagamentos: Tesoureiros podem registrar pagamentos e marcar mensalidades como pagas na plataforma.

Geração Automática de Mensalidades:

Toda vez que um novo associado é cadastrado, o sistema gera automaticamente as mensalidades pendentes para toda a gestão a partir do próximo mês (regra: o primeiro mês de associação não é cobrado).

2. Controle de Acesso e Roles
O sistema opera com um modelo de permissões baseado em roles:

Role

Principal Função

Privilégios Chave

Admin

Gerenciamento total do sistema e infraestrutura.

Acesso completo a todas as funcionalidades.

Tesoureiro

Gestão financeira e de associados.

Cadastro, Inativação, Registro de Pagamentos.

Associado

Usuário padrão.

Visualização das mensalidades pendentes.

3. Fluxo de Transição de Tesouraria
O Tesoureiro atual pode adicionar um novo Tesoureiro para a próxima gestão.

Ao realizar essa ação, o Tesoureiro que executa o comando perde sua role de Tesoureiro e é automaticamente rebaixado para a role de Associado padrão.

🚀 Como Executar o Projeto (Setup)
Para rodar a aplicação localmente, siga os passos abaixo para o Backend (.NET) e o Aplicativo (Flutter).

1. Configuração do Banco de Dados (Supabase/PostgreSQL)
Crie uma conta no Supabase e configure um novo projeto.

Obtenha as credenciais de conexão do PostgreSQL.

Crie as tabelas e o schema inicial (verifique a pasta de Materiais para scripts de Database).

2. Configuração do Backend (.NET)
Clone o repositório da API.

Navegue até o diretório raiz da API.

Configure o arquivo de settings (appsettings.json) com as credenciais do PostgreSQL/Supabase.

Execute o projeto:

dotnet restore
dotnet run

3. Configuração do Aplicativo (Flutter)
Certifique-se de ter o Flutter SDK instalado.

Clone o repositório do Aplicativo.

Configure a URL base da API .NET no ambiente (variáveis de ambiente ou arquivo de constantes).

Rode a aplicação:

flutter pub get
flutter run

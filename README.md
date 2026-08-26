# Estoque Firmafloor — versão compartilhada

Aplicativo web estático com a interface atual preservada e uma camada opcional de Supabase para login, persistência compartilhada e atualização em tempo real.

## Configuração rápida

1. Crie um projeto no Supabase.
2. Execute `supabase-schema.sql` no SQL Editor.
3. Antes de abrir/publicar, crie um pequeno arquivo de configuração a partir de `config.example.js` e carregue-o antes do `index.html` (ou substitua os valores no bloco de configuração do próprio HTML) com a URL e a chave anon pública do projeto.
4. Crie manualmente no Supabase Auth o único usuário `estoquefirmafloor@gmail.com` e defina a senha compartilhada da equipe. A tela do aplicativo não permite novos cadastros.
5. Promova esse usuário a administrador com o SQL indicado no esquema.
6. Publique a pasta em Vercel, Netlify ou outro serviço de hospedagem estática.

## Perfis

A base está pronta para autenticação. O esquema cria `profiles` automaticamente para cada usuário. O primeiro usuário deve ser promovido com o SQL indicado no esquema. Administradores mantêm ações de cadastro/alteração/exclusão; operadores ficam em modo operacional, sem ações destrutivas na interface. Ajuste as políticas RLS conforme a política interna da empresa.

## Dados incluídos

- `seed-data.json`: catálogo, vendas e movimentações do aplicativo atual.
- `migration-sales.json`: vendas lidas da planilha de controle existente.

A primeira sessão autenticada sem estado remoto publica o estado inicial incluído no aplicativo. Depois disso, alterações são sincronizadas pela tabela `app_state`. O modo sem configuração continua funcionando localmente no navegador, para conferência e uso individual.

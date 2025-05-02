# Sistema de Clínica Médica com IA e Digitalização

Sistema de gestão para clínica médica com funcionalidades de digitalização e processamento de documentos utilizando IA e OCR.

## Descrição

Este sistema tem como objetivo digitalizar e gerenciar informações de uma clínica médica, incluindo:

- Digitalização e interpretação de fichas físicas utilizando OCR e IA
- Gerenciamento de pacientes, médicos e especialidades
- Agendamento inteligente de consultas
- Acesso ao histórico médico dos pacientes
- Integração com planos de saúde

## Estrutura do Projeto

```
clinica/
├── src/
│   ├── routes/            # Rotas da API
│   ├── database/          # Camada de acesso ao banco de dados
│   ├── ai_integration/    # Integração com APIs de IA e OCR
│   └── utils/             # Utilitários
├── uploads/               # Diretório para upload temporário de documentos
│   ├── documents/         # Documentos digitalizados
│   └── images/            # Imagens de apoio
├── logs/                  # Logs da aplicação
├── tests/                 # Testes automatizados
├── .env                   # Variáveis de ambiente (não versionado)
├── .env.example           # Exemplo de variáveis de ambiente
└── requirements.txt       # Dependências do projeto
```

## Requisitos

- Python 3.10+
- PostgreSQL 14+
- Acesso a APIs de OCR e IA (como Google Cloud Vision, Azure Form Recognizer, etc.)

## Configuração

1. Clone o repositório:

   ```
   git clone https://github.com/seu-usuario/clinica.git
   cd clinica
   ```

2. Crie e ative um ambiente virtual:

   ```
   python -m venv venv
   source venv/bin/activate  # No Windows: venv\Scripts\activate
   ```

3. Instale as dependências:

   ```
   pip install -r requirements.txt
   ```

4. Configure as variáveis de ambiente:

   ```
   cp .env.example .env
   # Edite o arquivo .env com suas configurações
   ```

5. Crie as pastas necessárias:
   ```
   python src/utils/create_dirs.py
   ```

6. Crie o banco de dados PostgreSQL e inicialize o esquema:
   ```
   createdb clinica_medica_dev  # Para ambiente de desenvolvimento
   python src/utils/init_db.py
   ```

## Iniciar o Servidor

Para iniciar o servidor de desenvolvimento:

```
uvicorn src.main:app --reload
```

A API estará disponível em `http://localhost:8000`. A documentação interativa da API estará em `http://localhost:8000/docs`.

## Endpoints da API

### Pacientes

- `GET /api/patients` - Listar todos os pacientes
- `GET /api/patients/{id}` - Obter um paciente específico
- `POST /api/patients` - Criar um novo paciente
- `PUT /api/patients/{id}` - Atualizar um paciente
- `DELETE /api/patients/{id}` - Excluir um paciente

### Médicos

- `GET /api/doctors` - Listar todos os médicos
- `GET /api/doctors/{id}` - Obter um médico específico
- `POST /api/doctors` - Criar um novo médico
- `PUT /api/doctors/{id}` - Atualizar um médico
- `DELETE /api/doctors/{id}` - Excluir um médico

### Consultas

- `GET /api/appointments` - Listar todas as consultas
- `GET /api/appointments/{id}` - Obter uma consulta específica
- `POST /api/appointments` - Agendar uma nova consulta
- `PUT /api/appointments/{id}` - Atualizar uma consulta
- `DELETE /api/appointments/{id}` - Cancelar uma consulta

### Prontuários Médicos

- `GET /api/medical-records/{id}` - Obter um prontuário específico
- `GET /api/medical-records/patient/{patient_id}` - Obter prontuários de um paciente
- `POST /api/medical-records` - Criar um novo prontuário
- `PUT /api/medical-records/{id}` - Atualizar um prontuário
- `DELETE /api/medical-records/{id}` - Excluir um prontuário

### Serviços de IA

- `POST /api/ai/analyze` - Solicitar análise de dados médicos
- `GET /api/ai/analysis/{id}` - Obter resultados de análise
- `GET /api/ai/patient/{patient_id}/analyses` - Obter análises de um paciente
- `POST /api/ai/summarize` - Gerar resumo de prontuário médico

## Funcionalidades Principais

1. **Digitalização e Processamento de Documentos**

   - Upload de imagens/PDFs de prontuários médicos
   - Processamento OCR dos documentos
   - Extração estruturada de informações

2. **Gerenciamento de Pacientes**

   - Cadastro, consulta, atualização e exclusão de pacientes
   - Histórico de atendimentos

3. **Agendamento de Consultas**

   - Agendamento com validação de conflitos
   - Notificações de consultas

4. **Funcionalidades de IA**
   - Sugestão de agendamentos baseados no histórico
   - Análise e resumo de prontuários médicos

## Desenvolvimento

### Ambientes

- **dev**: Ambiente de desenvolvimento
- **test**: Ambiente de testes
- **prod**: Ambiente de produção

Configure o ambiente através da variável de ambiente `ENVIRONMENT`.

### Execução de Testes

```
pytest
```

## Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request

## Licença

Este projeto está licenciado sob a licença MIT - veja o arquivo LICENSE para detalhes. 
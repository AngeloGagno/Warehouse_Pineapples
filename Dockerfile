# Use a imagem base do Python
FROM python:3.12-slim

# Instalar o dbt
RUN pip install dbt-postgres

# Definir o diretório de trabalho
WORKDIR /usr/app

# Copiar o seu projeto dbt para dentro do contêiner
COPY Pineapples /usr/app/Pineapples
COPY Pineapples/dbt_project.yml /usr/app/dbt_project.yml

# Comando padrão para rodar dbt
CMD ["dbt", "run"]

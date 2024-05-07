FROM node
USER root
RUN mkdir /home/atpqa_bancamovil \
&& chmod 2777 /home/atpqa_bancamovil
COPY . /home/atpqa_bancamovil
WORKDIR /home/atpqa_bancamovil
RUN npm install
# comando para ejecutar los tests scripts
# RUN npm run wdio 
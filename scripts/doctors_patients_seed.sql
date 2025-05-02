-- Doctors
INSERT INTO public.doctors
(id, "name", specialization, email, phone, created_at, updated_at)
VALUES(nextval('doctors_id_seq'::regclass), 'Esther Barros', 'Ginecologia', 'bruna41@yahoo.com.br', '+55 21 1379-7283', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.doctors
(id, "name", specialization, email, phone, created_at, updated_at)
VALUES(nextval('doctors_id_seq'::regclass), 'Sra. Mariana Correia', 'Cardiologia', 'joaquimsales@mendes.org', '+55 (051) 5239 6725', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.doctors
(id, "name", specialization, email, phone, created_at, updated_at)
VALUES(nextval('doctors_id_seq'::regclass), 'Diego Vieira', 'Ortopedia', 'almeidadaniel@nunes.com', '+55 21 9987-7346', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.doctors
(id, "name", specialization, email, phone, created_at, updated_at)
VALUES(nextval('doctors_id_seq'::regclass), 'Isis Porto', 'Dermatologia', 'ramosbernardo@hotmail.com', '(071) 9730 5848', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.doctors
(id, "name", specialization, email, phone, created_at, updated_at)
VALUES(nextval('doctors_id_seq'::regclass), 'Ana Lívia Vieira', 'Pediatria', 'oaragao@uol.com.br', '(011) 3410 6243', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.doctors
(id, "name", specialization, email, phone, created_at, updated_at)
VALUES(nextval('doctors_id_seq'::regclass), 'Davi Rocha', 'Neurologia', 'joao-felipe85@bol.com.br', '81 1264-0310', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.doctors
(id, "name", specialization, email, phone, created_at, updated_at)
VALUES(nextval('doctors_id_seq'::regclass), 'Lívia Barros', 'Psiquiatria', 'zsilva@rodrigues.br', '(021) 3777-6217', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.doctors
(id, "name", specialization, email, phone, created_at, updated_at)
VALUES(nextval('doctors_id_seq'::regclass), 'Thomas Barros', 'Endocrinologia', 'raqueldias@yahoo.com.br', '61 0841-1263', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.doctors
(id, "name", specialization, email, phone, created_at, updated_at)
VALUES(nextval('doctors_id_seq'::regclass), 'Letícia Souza', 'Urologia', 'scastro@gmail.com', '0300-512-2520', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.doctors
(id, "name", specialization, email, phone, created_at, updated_at)
VALUES(nextval('doctors_id_seq'::regclass), 'Breno Melo', 'Oftalmologia', 'yurifarias@uol.com.br', '(031) 2477 3151', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Patients
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Maria Vitória Fernandes', '1953-05-21', 'F', 'ianfogaca@monteiro.com', '+55 31 7225-9303', 'Sítio Emanuel Gomes, 4, Conjunto Floramar, 35396-255 Barros de Gonçalves / AM', 'Almeida', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Larissa Pires', '2010-07-06', 'M', 'gduarte@yahoo.com.br', '31 0140 0807', 'Favela de da Conceição, 17, Mariquinhas, 88681-520 Almeida / CE', 'Freitas', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Luigi Ribeiro', '2021-02-15', 'M', 'novaesolivia@silva.com', '(041) 6813-3325', 'Conjunto Bruna Oliveira, 65, Santa Terezinha, 72382-458 Cunha de Mendes / DF', 'Rezende - EI', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Olivia Rezende', '1982-05-09', 'M', 'fariascaue@goncalves.br', '(084) 8805 7564', 'Rua de Vieira, 11, Andiroba, 85450859 Pinto / MS', 'Castro S/A', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Dr. Rodrigo da Costa', '1962-11-02', 'M', 'fogacadiogo@bol.com.br', '81 4232-7111', 'Morro Miguel Duarte, 637, Serra, 61793643 das Neves Grande / RR', 'Costela Castro S/A', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'João Miguel Castro', '1988-10-18', 'F', 'murilo89@bol.com.br', '41 9351-7060', 'Travessa de Ferreira, 15, Silveira, 80827746 Pereira do Campo / PB', 'Lima', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Isaac Fernandes', '1977-10-17', 'M', 'kjesus@monteiro.br', '61 6464-5718', 'Fazenda de Vieira, 99, Bom Jesus, 95880-113 Souza / AL', 'Mendes da Rocha - EI', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'João Cunha', '1992-12-20', 'F', 'samuel20@rocha.com', '+55 (011) 4263 1778', 'Vale de Nunes, 71, Mangueiras, 88800008 da Conceição / AC', 'Farias', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Dra. Bruna Pereira', '1926-04-26', 'F', 'zalves@da.org', '+55 71 4031 2338', 'Viaduto Porto, 9, Serra Do Curral, 12721504 Silva de Oliveira / AL', 'Araújo S.A.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Fernando Souza', '1987-10-29', 'F', 'vitor54@lopes.com', '(061) 0734 9982', 'Favela Almeida, 11, Vitoria, 43011-711 da Costa de Monteiro / RR', 'Pereira Novaes - ME', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Melissa da Rosa', '2006-09-15', 'M', 'da-luzfrancisco@carvalho.br', '+55 51 4629 1366', 'Jardim de Ferreira, Santa Sofia, 07786-482 Teixeira de Moreira / RR', 'Silva', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Samuel da Conceição', '1984-12-07', 'M', 'rduarte@rezende.com', '(061) 9216 9659', 'Jardim de da Luz, 9, Mineirão, 23334697 Ferreira / SP', 'Sales Ltda.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Helena Dias', '1997-08-30', 'F', 'lorena74@farias.net', '+55 81 6230-0990', 'Área Melissa Lima, 53, Vila Nova Cachoeirinha 3ª Seção, 07755-391 Cardoso Grande / ES', 'Farias Melo Ltda.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Arthur da Costa', '1990-03-24', 'F', 'rdias@yahoo.com.br', '+55 31 7669 0701', 'Passarela Ana Carolina Costa, 81, Piraja, 16618615 das Neves / MA', 'Cardoso', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Marcelo Cavalcanti', '2011-11-21', 'M', 'qcostela@gmail.com', '51 4212 9555', 'Morro Milena Novaes, 6, Primeiro De Maio, 40663772 Nunes de da Luz / RN', 'da Cunha', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Sra. Letícia Alves', '1982-05-28', 'F', 'raulda-costa@ig.com.br', '(031) 6001-3023', 'Travessa Campos, 80, Vila Maria, 19389749 Silveira do Oeste / AL', 'Pinto - ME', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Vitor Silva', '1967-09-02', 'F', 'luna45@das.org', '+55 21 4453 5840', 'Favela Milena Gomes, 47, Beija Flor, 02887779 Nunes de Minas / MA', 'Teixeira - ME', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Enzo Gabriel da Mota', '2012-12-19', 'F', 'fernandesmaria-vitoria@gmail.com', '+55 (041) 0239 6311', 'Trecho Anthony Rocha, Santa Maria, 02222-819 Almeida / AP', 'Moura Ltda.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Sophie Moreira', '1989-02-23', 'F', 'alanada-rosa@ig.com.br', '0900-354-8705', 'Núcleo Rodrigues, 26, Vila Independencia 2ª Seção, 42727-633 Duarte / BA', 'da Mota', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Dra. Maysa Fernandes', '1930-11-21', 'M', 'luiz-gustavo33@uol.com.br', '+55 71 9608 2045', 'Quadra de Vieira, 624, Estrela Do Oriente, 08561562 Oliveira do Campo / PB', 'Gomes', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Ana Vitória Mendes', '1958-12-22', 'M', 'hviana@uol.com.br', '71 0410 8395', 'Fazenda da Rocha, Milionario, 09303-594 Rezende de Moura / BA', 'Caldeira', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Rafaela Melo', '1957-11-10', 'F', 'sabrina45@cardoso.com', '+55 61 1418-3845', 'Lago de Vieira, 84, São José, 71992-582 Martins / PA', 'Rezende', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Emilly Farias', '1977-07-09', 'M', 'diogomoreira@costela.com', '+55 21 9527 3959', 'Viaduto de Peixoto, 96, São Vicente, 89262702 da Cruz / ES', 'Nunes', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Joana Araújo', '1958-06-12', 'M', 'goncalveskaique@cardoso.org', '(051) 3828-7434', 'Via de Duarte, 87, São Sebastião, 27794-707 Duarte / PR', 'Cavalcanti', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Renan Nunes', '1960-06-23', 'M', 'mirellanovaes@mendes.com', '+55 (011) 1261-2164', 'Travessa Bryan Almeida, 48, Vila Real 2ª Seção, 73450855 Pereira / PB', 'Sales Ltda.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Sra. Milena Moraes', '1948-06-04', 'F', 'claramoura@da.com', '+55 11 9500 3305', 'Vereda de Gonçalves, 4, Mariquinhas, 78540-204 da Cruz da Prata / PB', 'da Mata - EI', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Dr. Theo Rodrigues', '1964-04-27', 'F', 'joao-pedroda-rosa@silva.net', '+55 (021) 9306-4642', 'Aeroporto de Cunha, 7, Inconfidência, 27537047 Fernandes de Caldeira / MT', 'Azevedo S.A.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Dr. Danilo Cunha', '1958-07-21', 'M', 'fcarvalho@da.br', '+55 61 8343 3996', 'Estrada da Cunha, 7, Barro Preto, 19598924 Pinto da Praia / ES', 'Pinto', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'João Pedro Pires', '1986-10-15', 'M', 'joaquim43@sales.com', '21 7790 8099', 'Viela de Alves, 15, Vila Maloca, 71917-139 Martins / RJ', 'Dias', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Lívia da Luz', '2003-11-06', 'F', 'carolinafarias@yahoo.com.br', '84 2934-0741', 'Recanto Lorenzo Duarte, 97, Vila Aeroporto Jaraguá, 55304116 Dias de Costa / BA', 'Rocha', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Srta. Sophia Campos', '1938-09-22', 'F', 'goncalvesmaysa@monteiro.com', '0900-101-2909', 'Conjunto Jesus, Jardim Alvorada, 25372205 Teixeira / BA', 'Pereira - ME', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Giovanna Teixeira', '1937-09-08', 'F', 'breno96@hotmail.com', '0500 270 1780', 'Viela Freitas, Gameleira, 00813-414 Correia / ES', 'Alves', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Beatriz Silva', '1994-03-29', 'F', 'barbosaeduarda@pereira.br', '(071) 2945-1994', 'Área Stephany Jesus, 404, Vila Cloris, 81417919 Ribeiro / PI', 'da Cunha', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Erick Pereira', '1979-07-09', 'M', 'moraesjuan@silva.com', '0300 828 3691', 'Lago Leandro Pinto, 99, Centro, 96216137 da Cruz do Norte / DF', 'Cardoso', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Emanuelly Azevedo', '2008-11-30', 'M', 'ana-carolina95@vieira.br', '+55 (021) 1128 6297', 'Aeroporto Maysa Martins, 53, Paquetá, 41201-883 Teixeira / MG', 'da Costa', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Benício Dias', '1952-01-27', 'M', 'moreiracaue@bol.com.br', '0800 609 1142', 'Núcleo Caroline Pereira, 43, Biquinhas, 19482478 Dias da Serra / RN', 'da Rocha', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Raul Ramos', '1976-12-21', 'F', 'oliveirarafaela@bol.com.br', '+55 (031) 1833-3956', 'Jardim de Peixoto, 14, Vila Santa Monica 2ª Seção, 85405-451 Costa Paulista / RS', 'Farias Farias e Filhos', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Catarina Carvalho', '1958-09-20', 'F', 'juliasales@barros.com', '31 8686 1214', 'Condomínio Yuri da Cruz, 79, Santo Agostinho, 15364730 Cardoso Paulista / RO', 'Gonçalves', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Mariana Sales', '1946-02-18', 'F', 'davi-luiz28@pires.com', '+55 (041) 4080 1886', 'Conjunto de Pereira, 6, Nova America, 85905-991 Lopes Grande / AL', 'Fernandes Silveira Ltda.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Alícia Ferreira', '1973-02-27', 'M', 'joao-guilherme66@pires.com', '11 9372 2134', 'Ladeira Moura, 54, Belvedere, 64716253 Jesus / BA', 'Martins', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Luana Peixoto', '1974-06-16', 'M', 'hazevedo@gmail.com', '0800 722 4752', 'Viela de Porto, 16, Vila Nova Dos Milionarios, 75058279 da Cruz / AM', 'Ferreira Silveira e Filhos', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Kevin da Rosa', '1925-05-02', 'M', 'esther74@da.com', '(071) 5488-5142', 'Trevo Pedro Henrique Campos, Santo André, 26254-729 da Rosa do Galho / GO', 'da Luz', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'João Gabriel Santos', '2012-08-25', 'M', 'nunesfelipe@hotmail.com', '+55 (071) 2892-1853', 'Travessa Anthony Barros, 104, Vila Trinta E Um De Março, 57702200 Monteiro das Flores / CE', 'Silveira', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Dra. Isabella da Rocha', '1978-07-06', 'M', 'augusto83@pires.com', '(051) 7621 4240', 'Vereda da Rocha, Conjunto Bonsucesso, 52112332 Azevedo de Goiás / DF', 'Farias', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Dr. Diego Moreira', '2021-09-22', 'F', 'vsales@uol.com.br', '51 7889 9674', 'Rodovia de Vieira, 96, Jardim Atlântico, 18676092 da Paz / PA', 'Caldeira Ltda.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Sra. Olivia Novaes', '2023-05-24', 'M', 'da-costarebeca@da.org', '+55 (071) 2486 1699', 'Viela Cardoso, 863, Maria Tereza, 70488225 Mendes / MS', 'Nogueira e Filhos', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Elisa Barros', '1990-04-29', 'F', 'yasminrodrigues@uol.com.br', '0500-734-1688', 'Campo Sophia Souza, Nossa Senhora Aparecida, 24939-303 Alves / RR', 'Moraes S/A', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Maria Vitória Freitas', '1985-09-16', 'F', 'erick87@ig.com.br', '11 0666-5855', 'Condomínio de Duarte, São Vicente, 90060256 Silveira / SE', 'Rodrigues', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Maria Luiza Caldeira', '1993-06-11', 'F', 'nsilveira@cunha.org', '+55 31 8077-1112', 'Pátio de Ramos, 54, Bairro Das Indústrias Ii, 16632-066 Lopes da Prata / CE', 'Nunes Monteiro - ME', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Rodrigo Aragão', '1995-05-19', 'F', 'catarina48@uol.com.br', '+55 (081) 2774 1964', 'Jardim Bruna da Mota, 31, Vila Calafate, 34248871 Sales / MS', 'Lopes', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Igor Alves', '1931-11-16', 'M', 'danilo11@ig.com.br', '(031) 9680 0482', 'Vereda Emanuelly Viana, 36, Vila Nossa Senhora Do Rosário, 87834140 Barros / PR', 'Barbosa', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Gabriela Freitas', '1967-12-06', 'M', 'monteironicole@hotmail.com', '51 0611 9109', 'Praia de Ribeiro, 84, Gutierrez, 67196625 da Rocha / PB', 'Cunha e Filhos', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Catarina Gonçalves', '1973-09-05', 'F', 'bruna27@cardoso.com', '(021) 5133 9416', 'Sítio Barbosa, 46, Vila Novo São Lucas, 97477-287 Gonçalves / ES', 'Rezende S.A.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Srta. Ana Lívia Cunha', '1988-09-08', 'F', 'vieiralucas@ig.com.br', '71 5694 4353', 'Aeroporto Lopes, 952, Calafate, 24353-033 Rocha do Sul / AP', 'Lopes S/A', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'João Felipe da Costa', '1971-03-12', 'F', 'thomas14@hotmail.com', '+55 31 4959 8684', 'Quadra de Silva, Vila Paraíso, 10897-994 Gonçalves / MG', 'da Cunha', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Cecília Cardoso', '1962-01-13', 'F', 'faraujo@ig.com.br', '+55 21 2299 7141', 'Chácara de Monteiro, 3, Senhor Dos Passos, 51628-320 Gonçalves de Silva / SE', 'Peixoto da Mata e Filhos', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Júlia Ferreira', '1929-04-03', 'M', 'ramosisabelly@lima.com', '+55 51 2114 0202', 'Conjunto de Nascimento, 61, Sion, 51672-845 Porto / AL', 'Oliveira', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Luiz Henrique Almeida', '1985-02-10', 'F', 'rsouza@uol.com.br', '(011) 6908 2170', 'Trevo de Nascimento, 90, Mangueiras, 58618-606 das Neves / RJ', 'Lima', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Arthur Melo', '2024-03-02', 'M', 'vcampos@yahoo.com.br', '+55 (021) 1625 5290', 'Estrada Nogueira, 89, Primeiro De Maio, 01784107 Duarte de da Cruz / RS', 'Barbosa S.A.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Leandro Duarte', '2024-01-27', 'M', 'nicolasaraujo@ig.com.br', '0300-606-0900', 'Aeroporto Joana Silveira, 15, Santa Lúcia, 29866-919 Alves / MT', 'Nogueira', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Nina Nogueira', '1927-10-19', 'F', 'ceciliada-cunha@uol.com.br', '(031) 3125-6585', 'Recanto Clarice das Neves, 42, Dona Clara, 41173-872 Lopes / PA', 'das Neves', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Augusto Porto', '1968-07-27', 'F', 'mendeslarissa@santos.br', '0500 497 6102', 'Alameda da Cruz, 50, São Sebastião, 27196687 Mendes Verde / MT', 'Cardoso', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Yuri da Rocha', '2011-06-19', 'M', 'silvaclara@gomes.br', '21 9012 7026', 'Viaduto de da Rocha, 296, São João Batista, 48207539 Pereira dos Dourados / SP', 'da Mata', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Sr. Bryan Souza', '1956-11-05', 'F', 'rochabenjamin@da.org', '+55 41 5190 4240', 'Favela Marina Costa, 280, Nova Suíça, 00535-724 Melo de Nunes / PI', 'Moura da Cruz - EI', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Ana Lívia Freitas', '1959-01-05', 'F', 'da-costaelisa@cavalcanti.br', '84 1755 6235', 'Condomínio Almeida, 80, Vila Petropolis, 79295814 Rocha / PA', 'Costa', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Kamilly Caldeira', '1992-08-23', 'M', 'marina15@yahoo.com.br', '+55 11 8069 8468', 'Sítio da Cruz, 9, Caetano Furquim, 30224939 Lopes do Galho / RJ', 'Ramos - EI', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Emanuelly Correia', '2017-08-09', 'M', 'tvieira@pinto.br', '0300 954 1031', 'Recanto de Moura, Vila Esplanada, 09436010 Pires / MT', 'Porto da Luz Ltda.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Raquel da Paz', '1963-05-21', 'M', 'ana-liviacunha@ig.com.br', '+55 41 6669 9685', 'Setor de Melo, 91, Solar Do Barreiro, 66548725 da Rocha de Barbosa / PA', 'Rocha Santos S.A.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Samuel Viana', '2013-11-06', 'M', 'emillycosta@gmail.com', '+55 21 2314 8039', 'Área Aragão, 225, Ribeiro De Abreu, 69010443 Dias / PE', 'Dias', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Marcela Peixoto', '2015-11-27', 'M', 'da-pazolivia@aragao.com', '+55 84 0362 0545', 'Lagoa Costa, 993, Diamante, 22496774 Teixeira / RN', 'Lopes Vieira - ME', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'João Vitor Gomes', '1998-07-16', 'F', 'alicia41@campos.org', '+55 61 0296-2730', 'Vereda de Nogueira, 59, Frei Leopoldo, 79995640 da Paz / TO', 'da Cunha', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Stephany Moraes', '2022-03-11', 'F', 'tduarte@melo.com', '+55 84 9340-2673', 'Lagoa Cauê Moraes, 4, Vila Canto Do Sabiá, 76694858 da Cruz da Mata / DF', 'Costela', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Maria Sophia Lopes', '2017-02-17', 'F', 'da-luzmaria-vitoria@santos.com', '(061) 9049-8369', 'Trevo Ribeiro, 1, Santo Agostinho, 51739-131 Martins de Santos / AM', 'Jesus - EI', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'João Guilherme Farias', '1999-09-08', 'F', 'wviana@uol.com.br', '0800 177 3826', 'Travessa Fernando da Rocha, 61, Vitoria, 17325-614 Ramos / MT', 'Nogueira', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'João Lucas Castro', '1987-07-16', 'F', 'mariamoreira@hotmail.com', '+55 (061) 7552-0530', 'Conjunto Carvalho, 2, Lagoinha, 10816517 Melo das Pedras / MA', 'da Mota', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Nicolas Peixoto', '1946-08-16', 'F', 'ana-juliada-conceicao@da.br', '0800-163-6844', 'Praia de da Cunha, 743, União, 41899360 Barbosa / CE', 'Santos S/A', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Júlia Cardoso', '1989-10-28', 'M', 'cteixeira@ig.com.br', '(084) 4083-6949', 'Distrito Fogaça, 64, Flamengo, 52496618 Moura da Prata / MA', 'Barbosa', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Breno Oliveira', '1958-08-20', 'M', 'luiz-henriquemelo@hotmail.com', '+55 (041) 5816 1402', 'Viela de da Conceição, 591, Camponesa 1ª Seção, 04208-133 Mendes / PA', 'Ferreira', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Pietra Nascimento', '2018-02-04', 'M', 'luiz-gustavo60@bol.com.br', '21 6704-5160', 'Residencial Lara da Paz, 29, Nossa Senhora De Fátima, 07925-200 Moura do Amparo / AC', 'Carvalho Ltda.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Thomas Carvalho', '1958-03-16', 'F', 'fernando05@alves.br', '(051) 4590 8332', 'Distrito Nogueira, 716, Boa Vista, 42372629 Peixoto / PA', 'Peixoto Porto Ltda.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Maria Julia Peixoto', '2016-07-16', 'M', 'caiogomes@uol.com.br', '(071) 8337 2955', 'Lagoa Luiz Felipe Alves, 782, Vila Santa Monica 2ª Seção, 91598-703 Carvalho / PA', 'da Paz', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Dr. Lucas Cardoso', '1988-06-03', 'F', 'oliviacardoso@nascimento.com', '+55 31 8260-0165', 'Esplanada Ana Júlia Alves, 71, Outro, 06943-728 Santos de Fernandes / SC', 'Lima Gonçalves - ME', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Davi Santos', '1976-06-29', 'F', 'diaslarissa@nascimento.br', '81 7106-2234', 'Residencial Kamilly Lima, 19, Ápia, 74493-923 Dias / MA', 'Caldeira da Mota S.A.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Pedro Caldeira', '1940-06-14', 'M', 'catarina14@ferreira.com', '0800 064 3967', 'Conjunto de Nogueira, Camponesa 2ª Seção, 54587-939 Caldeira de Minas / PI', 'da Mota', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Maitê Moura', '2020-08-18', 'M', 'anthony32@ig.com.br', '+55 51 6158 2814', 'Sítio Nogueira, 7, Ambrosina, 70376961 da Rocha / AP', 'da Cruz e Filhos', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Matheus Barros', '1983-12-21', 'F', 'souzagabriel@ig.com.br', '11 9799 9259', 'Distrito Vicente Pires, 759, Novo Das Industrias, 80581-182 da Cunha / MT', 'Pires', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Pedro Miguel Mendes', '2011-05-06', 'M', 'elisada-rocha@mendes.com', '51 4885 0286', 'Viela Teixeira, 57, Vila Maloca, 37321-657 da Luz / MG', 'Teixeira Lopes Ltda.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Dr. Luiz Fernando Nunes', '1977-06-18', 'M', 'nda-costa@uol.com.br', '+55 (081) 5328-1834', 'Quadra de da Cruz, 13, Marilandia, 18581-510 da Cunha / TO', 'Rodrigues S/A', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Gustavo Henrique Teixeira', '1934-11-29', 'M', 'kribeiro@rocha.br', '61 1898 0946', 'Ladeira Nicolas Souza, 498, Barão Homem De Melo 3ª Seção, 20126887 Silveira do Campo / CE', 'Pinto', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Nicole Jesus', '1963-07-29', 'F', 'arthurlima@gmail.com', '0500-835-7800', 'Residencial de Lima, 970, Barão Homem De Melo 1ª Seção, 19460384 Viana / PB', 'Moreira e Filhos', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Juliana Sales', '2019-06-01', 'F', 'milena81@gmail.com', '(081) 3054-4557', 'Loteamento Gonçalves, 75, Ribeiro De Abreu, 16855435 Costa / CE', 'Gonçalves', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Sophia Campos', '1962-09-19', 'M', 'caldeiraana@jesus.br', '0500 641 7520', 'Parque de Nunes, 8, Boa Esperança, 73801-653 Nunes da Serra / GO', 'Pereira - ME', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Emanuelly Carvalho', '1975-10-21', 'M', 'sabrinarezende@gmail.com', '(011) 8570 3502', 'Passarela de Silva, 9, Buraco Quente, 22383-693 Azevedo da Serra / RS', 'da Mata', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Ryan Aragão', '1960-06-18', 'F', 'stephanylima@das.com', '+55 (061) 3603-9345', 'Vereda Monteiro, 24, Eymard, 33776-686 Silveira / CE', 'Rocha', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Mirella Nunes', '2003-10-03', 'F', 'yago90@da.com', '(084) 3981-7079', 'Estrada Isis da Costa, 75, Jardim Felicidade, 22689991 da Luz / PB', 'Rodrigues Ltda.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Giovanna da Rosa', '1977-05-07', 'M', 'brenofreitas@lopes.net', '71 5166 6911', 'Quadra Ana Laura Vieira, 3, Taquaril, 10381-479 Correia da Praia / RS', 'Castro', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Clarice Teixeira', '1970-03-05', 'F', 'da-pazcaio@hotmail.com', '84 4325 7905', 'Largo Nascimento, 971, Tupi B, 87458-810 da Costa / PE', 'Moura', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Dr. Theo da Luz', '2007-03-30', 'F', 'levi79@ig.com.br', '+55 21 7317-8227', 'Condomínio da Luz, 11, Prado, 14833021 Martins / RJ', 'Cardoso', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Enrico Rodrigues', '1937-02-02', 'F', 'ecostela@ig.com.br', '(031) 6629 7954', 'Avenida Lívia Santos, 4, Sagrada Família, 61232-484 Cunha / SE', 'Araújo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.patients
(id, "name", date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at)
VALUES(nextval('patients_id_seq'::regclass), 'Luiz Miguel Fernandes', '2004-12-28', 'F', 'caroline02@hotmail.com', '+55 81 1503-6893', 'Recanto de Peixoto, 43, Vila Nossa Senhora Do Rosário, 61245468 Gonçalves do Campo / AM', 'Rodrigues das Neves S.A.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
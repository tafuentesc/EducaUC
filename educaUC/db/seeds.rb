#users
User.create(email: 'luke@rebels.com', name:'Luke', lastname:'Skywalker', hash_password: '123456');
#Templates
#Escalas
EscalaTemplate.create(nombre: 'ITERS-R');
EscalaTemplate.create(nombre: 'ECERS-R');
#SubEscalas
SubescalaTemplate.create(nombre: 'Espacio y Mueble', numero: 1, escala_template_id: 1);
SubescalaTemplate.create(nombre: 'Rutinas del Cuidado Personal', numero: 2, escala_template_id: 1);
SubescalaTemplate.create(nombre: 'Escuchar y Hablar', numero: 3, escala_template_id: 1);
SubescalaTemplate.create(nombre: 'Actividades', numero: 4, escala_template_id: 1);
SubescalaTemplate.create(nombre: 'Interaccion', numero: 5, escala_template_id: 1);
SubescalaTemplate.create(nombre: 'Estructura del Programa', numero: 6, escala_template_id: 1);
SubescalaTemplate.create(nombre: 'Padres y Personal', numero: 7, escala_template_id: 1);

SubescalaTemplate.create(nombre: 'Espacio y Mueble', numero: 1, escala_template_id: 2);
SubescalaTemplate.create(nombre: 'Rutinas del Cuidado Personal', numero: 2, escala_template_id: 2);
SubescalaTemplate.create(nombre: 'Lenguaje-Razonamiento', numero: 3, escala_template_id: 2);
SubescalaTemplate.create(nombre: 'Actividades', numero: 4, escala_template_id: 2);
SubescalaTemplate.create(nombre: 'Interaccion', numero: 5, escala_template_id: 2);
SubescalaTemplate.create(nombre: 'Estructura del Programa', numero: 6, escala_template_id: 2);
SubescalaTemplate.create(nombre: 'Padres y Personal', numero: 7, escala_template_id: 2);
#item --- solo las de espacio y mueble, luego hay que agregar las demas.
ItemTemplate.create(nombre: 'Espacio Interior', numero: 1, subescala_template_id: 1);
ItemTemplate.create(nombre: 'Muebles para el cuidado rutinario y el juego', numero: 2, subescala_template_id: 1);
ItemTemplate.create(nombre: 'Provisiones para el relajamiento y el confort', numero: 3, subescala_template_id: 1);
ItemTemplate.create(nombre: 'Organizacion de la sala', numero: 4, subescala_template_id: 1);
ItemTemplate.create(nombre: 'Exhibiciones para los ninos', numero: 5, subescala_template_id: 1);

ItemTemplate.create(nombre: 'Espacio Interior', numero: 1, subescala_template_id: 8);
ItemTemplate.create(nombre: 'Muebles para el cuidado rutinario, el juego y el aprendizaje', numero: 2, subescala_template_id: 8);
ItemTemplate.create(nombre: 'Muebles para el relajamiento y el confort', numero: 3, subescala_template_id: 8);
ItemTemplate.create(nombre: 'Organizacion de la sala para el juego', numero: 4, subescala_template_id: 8);
ItemTemplate.create(nombre: 'Espacio para la privacidad', numero: 5, subescala_template_id: 8);
ItemTemplate.create(nombre: 'Exhibiciones relacionadas con los ninos', numero: 6, subescala_template_id: 8);
ItemTemplate.create(nombre: 'Espacio para el juego motor grueso', numero: 7, subescala_template_id: 8);
ItemTemplate.create(nombre: 'Equipo para actividades motoras gruesas', numero: 8, subescala_template_id: 8);

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

# Indicadores Item 1, Sub-escala 1, Escala ITERS
IndicadorTemplate.create(columna: 1, fila: 1, has_na: false, item_template_id: 1, descripcion: 'No hay suficiente espacio interior para ninos, adultos y muebles')
IndicadorTemplate.create(columna: 1, fila: 2, has_na: false, item_template_id: 1, descripcion: 'El espacio no tiene suficiente luz, control de temperatura o materiales que absorban el sonido')
IndicadorTemplate.create(columna: 1, fila: 3, has_na: false, item_template_id: 1, descripcion: 'El espacio esta en mal estado.')
IndicadorTemplate.create(columna: 1, fila: 4, has_na: false, item_template_id: 1, descripcion: 'El espacio esta mal mantenido.')
IndicadorTemplate.create(columna: 3, fila: 1, has_na: false, item_template_id: 1, descripcion: 'Hay suficiente espacio interior para ninos, adultos y muebles.')
IndicadorTemplate.create(columna: 3, fila: 2, has_na: false, item_template_id: 1, descripcion: 'El espacio tiene suficiente luz, control de temperatura o materiales que absorben el sonido.')
IndicadorTemplate.create(columna: 3, fila: 3, has_na: false, item_template_id: 1, descripcion: 'El espacio esta en buen estado.')
IndicadorTemplate.create(columna: 3, fila: 4, has_na: false, item_template_id: 1, descripcion: 'El espacio esta bastante limpio y bien mantenido.')
IndicadorTemplate.create(columna: 3, fila: 5, has_na: true, item_template_id: 1, descripcion: 'El espacio es accesible a todos los ninos y adultos con discapacidades que estan usando actualmente la sala de clases.')
IndicadorTemplate.create(columna: 5, fila: 1, has_na: false, item_template_id: 1, descripcion: 'Hay amplio espacio interior para ninos, adultos y muebles.')
IndicadorTemplate.create(columna: 5, fila: 2, has_na: false, item_template_id: 1, descripcion: 'Hay buena ventilacion y entra una cierta medida de luz natural por las ventanas o tragaluces.')
IndicadorTemplate.create(columna: 5, fila: 3, has_na: false, item_template_id: 1, descripcion: 'El espacio es accesible a ninos y adultos con discapacidades.')
IndicadorTemplate.create(columna: 7, fila: 1, has_na: false, item_template_id: 1, descripcion: 'Se puede controlar la luz natural que entra.')
IndicadorTemplate.create(columna: 7, fila: 2, has_na: false, item_template_id: 1, descripcion: 'Se puede controlar la ventilacion')
IndicadorTemplate.create(columna: 7, fila: 3, has_na: false, item_template_id: 1, descripcion: 'Los pisos, las paredes y otra superficies integradas estan hechos de materiales faciles de limpiar.')

# Indicadores Item 1, Sub-escala 1, Escala ECERS
IndicadorTemplate.create(columna: 1, fila: 1, has_na: false, item_template_id: 6, descripcion: 'No hay suficiente espacio para ninos, adultos, y muebles.')
IndicadorTemplate.create(columna: 1, fila: 2, has_na: false, item_template_id: 6, descripcion: 'El espacio no tiene suficiente luz, ventilacion, control de temperatura, o materiales que absorben el sonido.')
IndicadorTemplate.create(columna: 1, fila: 3, has_na: false, item_template_id: 6, descripcion: 'El espacio esta en malas condiciones.')
IndicadorTemplate.create(columna: 1, fila: 4, has_na: false, item_template_id: 6, descripcion: 'El espacio esta mal mantenido.')
IndicadorTemplate.create(columna: 3, fila: 1, has_na: false, item_template_id: 6, descripcion: 'Hay suficiente espacio interior para ninos, adultos, y muebles.')
IndicadorTemplate.create(columna: 3, fila: 2, has_na: false, item_template_id: 6, descripcion: 'El espacio tiene suficiente luz, ventilacion control de temperatura, y materiales que absorben el sonido.')
IndicadorTemplate.create(columna: 3, fila: 3, has_na: false, item_template_id: 6, descripcion: 'El espacio esta en buenas condiciones.')
IndicadorTemplate.create(columna: 3, fila: 4, has_na: false, item_template_id: 6, descripcion: 'El espacio esta bastante limpio y bien mantenido.')
IndicadorTemplate.create(columna: 3, fila: 5, has_na: true, item_template_id: 6, descripcion: 'El espacio es accesible a todos los ninos y adultos que estan usando la sala de clase.')
IndicadorTemplate.create(columna: 5, fila: 1, has_na: false, item_template_id: 6, descripcion: 'Hay espacio amplio al interior que les permite a los ninos y a los adultos moverse facilmente.')
IndicadorTemplate.create(columna: 5, fila: 2, has_na: false, item_template_id: 6, descripcion: 'Hay buena ventilacion, entra alguna luz natural a traves de las ventanas o por un tragaluz.')
IndicadorTemplate.create(columna: 5, fila: 3, has_na: false, item_template_id: 6, descripcion: 'El espacio es accesible a todos los ninos y adultos con discapacidades.')
IndicadorTemplate.create(columna: 7, fila: 1, has_na: false, item_template_id: 6, descripcion: 'Se puede controlar la luz natural que entra.')
IndicadorTemplate.create(columna: 7, fila: 2, has_na: false, item_template_id: 6, descripcion: 'Se puede controlar la ventilacion.')

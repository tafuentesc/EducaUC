// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(function(){
	// vinculamos con la función markPreviousIndicators
	$("section.item").delegate("input.no_node","click",markPreviousIndicators);
	// vinculamos con la función toggleVisibility
	$("div.sub-escala").delegate("a", "click", toggleVisibility)

	// Variable para almacenar el valor previamente seleccionado en select#escala:
	var previous_option = 0;
	
	// Función para cargar dinámicamente la escala dependiendo de la opción seleccionada:
	$("select#escala").change(function(){
		// Antes que nada, verificamos que no haya nada seleccionado. De ser así, pedimos confirmación,
		// puesto que cambiar la escala borrará la información agregada:
		if($("div#escala_container").find("input:checked").length > 0)
		{
			// TODO: Agregar diálogo que confirme acción
			alert("NO puede, hay elementos seleccionados. DES-SELECCIONE TODO MANUALMENTE ANTES DE CONTINUAR... o wait... NO PUEDES! MUAJAJAJAAA!!!! >:D");
			return;
		}
	
		// Primero, extraemos el id seleccionado
		id = $(this).val();
		
		// En caso de que sea el placeholder (o algún valor no válido) no hacemos nada
		if(!(id == "1" || id == "2"))
			return;		
		
		// Almacenamos la posición del escroll bar
		scrollTop = $("body").scrollTop();
				
		// Construimos la llamada Ajax:
		$.ajax({
			url: '/evaluaciones/escala/' + id,
			type: "GET",
			timeout: 8000,
			before: function(){
				// Ponemos el gif de "cargando"
				$("div#loading").show();
			},
			complete: function(){
				// Ocultamos el gif:
				$("div#loading").hide();
			},
			success: function(result){
				// antes de hacer fadeOut le agregamos un alto, para que el scrollTop no se vaya a cualquier lado
				$("div#ajax_container").css('min-height','500px');
				
				$("div#escala_container").fadeOut(function(){
					$("div#escala_container").html(result).fadeIn(function(){
						// No es lo que quiero, pero servirá para avanzar por los ítems al presionar teclas
						$("body").animate({scrollTop: scrollTop}, 500);
					});
				})								
				// Actualizamos el valor de previous_option
				previous_option = id;
			},
			error: function()
			{
				// volvemos select#escala al previous_option y mostramos mensaje de error:
				$("select#escala").val(previous_option);
				alert("An error ocurred!");
			}
		});
	
	});

	// Función para rellenar con "SI" los espacios vacíos	
	function markPreviousIndicators(){
		// Obtenemos el valor del radio_button (si es la primera columna, true; caso contrario, false)
		value = $(this).attr("value")=="true";
		
		// en este caso, this es el radio button => td es el padre... tr es el padre del padre!
		row = $(this).parent().parent();

		// no nos interesa partir de éste, sino de su antecesor:
		row = row.prev();
	
		// variable que indica si se ha encontrado un registro marcado (en ese caso nos detenemos)
		has_checked_value = false;
	
		count = 0;
	
		// row.length == 0 <=> row = []
		while(!has_checked_value && row.length != 0)
		{			
			// En caso de que row sea el header de la tabla, cambiamos de tabla
			if(row.hasClass('table_header'))
				row = row.parent().parent().prev().find('tr:last')
				
			// NOTA: parent() es tbody => parent().parent() es table!
			// row.children().length == 3 <=> no tiene N/A (esos los dejamos vacíos)
			// => no funciona! (todos tienen 4 hijos)
			if(row.is('tr'))
			{
				// Si es fila, revisamos si algún valor está chequeado
				// de ser así, se marca que se encontró un registro
				if(row.find('input:checked').length > 0)
					has_checked_value = true;
				else
				{
					// En caso contrario, se busca el que no tenga clase 
				  input = row.find("input[class='']");
				  
				  // En caso de haber sólo uno, lo marcamos
				  if(input.length == 1)
				  	input.prop('checked',true);

				  // Si hay más de uno => hay N/A => no hacemos nada
				  count = count + 1;				  
				}
			}

			row = row.prev();
		}
	};
		
	function toggleVisibility(e)
	{
		e.preventDefault();
		
		$parent = $(this).parents(".navbar").first();
		
		// Si está expandido, lo contraemos
		if($(this).children("i").hasClass("icon-chevron-down"))
		{
			$(this).children("i").removeClass("icon-chevron-down");
			$parent.children("div.item_body").slideUp();
			$(this).children("i").addClass("icon-chevron-left");
		}
		else if($(this).children("i").hasClass("icon-chevron-left"))
		{
			$(this).children("i").removeClass("icon-chevron-left");
			$parent.children("div.item_body").slideDown();
			$(this).children("i").addClass("icon-chevron-down");
		}
	}
	
});

// OBSERVACIÓN!!!
// -----------------------------------------------------------------------------------------
// USAR :onclick en f.radio_button_field entrega como this otro objeto! (ni idea cual es)...
// => usamos :class => 'no_node' y $("input.no_node").click(...) => entrega radio button! ;)

// Sólo vincularemos los radio buttons de 'NO':
function markPreviousIndicators_obsolete()
{
	// en este caso, this es el radio button => td es el padre... tr es el padre del padre!
	row = $(this).parent().parent();
	
	alert($(this).is('input') + " " + $(e).localName);
	
	var count = 0;
	
	while(row.length != 0)
	{
		if(row.is('tr'))
		{
		    count = count + 1;
		    alert(count);
		}

		row = row.prev();
	}
	
		
	//alert("the checkbox has " + count + " previous rows");
}

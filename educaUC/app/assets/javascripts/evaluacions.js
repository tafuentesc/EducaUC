// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(function(){
	// NOTA: Delegates no funcionan si el selector también se carga dede ajax!

	// vinculamos con la función markPreviousIndicators
	$("section.item").delegate("input.no_node","click",markPreviousIndicators);
	//$("ajax_container").delegate("input.no_node","click",markPreviousIndicators);
	// vinculamos con la función toggleVisibility
	$("div.sub-escala").delegate("header", "click", toggleVisibility)
	//$("ajax_container").delegate("a", "click", toggleVisibility)
	
	//$("form#new_evaluacion").live("submit",validateData);
	$("form input[name='commit']").click(validateData)

	$("div#show-escala input").attr("disabled", "disabled");
	
	// Vinculamos los errores a goToError:	
	$("body").delegate("li.alert.alert-error","click",goToError);

	// vinculamos onClick de los links en los indicadores con deleteIndicador:
	$("body").delegate("a.details_btn.btn-mini.close.active","click", deleteIndicador);


	// Variable para almacenar el valor previamente seleccionado en select#escala:
	var previous_option = 0;
	
	// Función para cargar dinámicamente la escala dependiendo de la opción seleccionada:
	$("select#escala").change(function(){
		// Antes que nada, verificamos que no haya nada seleccionado. De ser así, pedimos confirmación,
		// puesto que cambiar la escala borrará la información agregada:
		if($("div#escala_container").find("input:checked").length > 0)
		{
			// TODO: Agregar diálogo que confirme acción
		}
	
		// Primero, extraemos el id seleccionado
		id = $(this).val();
		
		// En caso de que sea el placeholder (o algún valor no válido) no hacemos nada
		if(!(id == "1" || id == "2"))
			return;		
		
		// Almacenamos la posición del escroll bar
		scrollTop = $("body").scrollTop();

		$("div#loading").show();
				
		// Construimos la llamada Ajax:
		$.ajax({
			url: '/evaluaciones/escala/' + id,
			type: "GET",
			timeout: 15000,
			before: function(){
				// Ponemos el gif de "cargando"
			},
			complete: function(){
				// Ocultamos el gif:
				$("div#loading").hide();
			},
			success: function(result){
				// antes de hacer fadeOut le agregamos un alto, para que el scrollTop no se vaya a cualquier lado
				$("div#ajax_container").css('min-height','1000px');
				
				$("div#escala_container").fadeOut(function(){
					$("div#escala_container").html(result).fadeIn(function(){
						// No es lo que quiero, pero servirá para avanzar por los ítems al presionar teclas
						$("body").animate({scrollTop: scrollTop}, 500);

						// vinculamos con delegate:
						$("section.item input.no_node").click(markPreviousIndicators);
						$("div#ajax_container header").click(toggleVisibility)

						// Actualizamos el valor de previous_option
						previous_option = id;

					});
					// Quitamos clase not_loaded:
					$("div#escala_container").removeClass("not_loaded");
				})								
			},
			error: function()
			{
				// volvemos select#escala al previous_option y mostramos mensaje de error:
				$("select#escala").val(previous_option);
				alert("No se ha podido cargar el form, por favor intente nuevamente");
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
	
		$item_body = $(this).siblings('div.item_body');
		$icon = $(this).find('ul.nav.pull-right li a i');
		
		// Si está expandido, lo contraemos
		if($icon.hasClass("icon-chevron-down"))
		{
			$icon.removeClass("icon-chevron-down");
			$item_body.slideUp();
			$icon.addClass("icon-chevron-left");
		}
		else if($icon.hasClass("icon-chevron-left"))
		{
			$icon.removeClass("icon-chevron-left");
			$item_body.slideDown();
			$icon.addClass("icon-chevron-down");
		}
	}
	
	function goToError(){
		// buscamos pading del body:
		var offset = parseInt($('body').css('padding-top'));
	
		// Leemos posición del error:
		var scrollPos = $(this).attr("data-scrollTop");
		var scrollPos = scrollPos - offset;
		
		// Animamos hacia el scrollTop
		 $('html, body').animate({
		  scrollTop: scrollPos
		 }, 1000);
	}
	
	function buildError($obj, $errorUl, error)
	{
			// Obtenemos scroll position del objeto:
			var objScrollTop = $obj.offset().top;
			
			// construimos error:
			var errorHTML = "<li class='alert alert-error' data-scrollTop='"+objScrollTop+"'><button type='button' class='close' data-dismiss='alert'>&times;</button>"+error+"</li>"
					
			// Agregamos el error a $errorUl:
			$errorUl.append(errorHTML);	
	}
	
	// chequea si el valor de $obj es '' o null; en caso de serlo, agrega el
	// error a $errorUl
	function checkIfBlank($obj, $errorUl, error){
		if($obj.val()==null || $obj.val()=='')
		{
			buildError($obj,$errorUl,error);		
			$obj.addClass("blank_entry");
			return true;
		}
		$obj.removeClass("blank_entry");
		return false;
	}	
	
	function validateData(){

		// Variable que verificaremos:
		var dataOk = true;
	
		// <ul> donde cargaremos los errores:
		var $errorUl = $("ul#errorUl");
		
		// limpiamos su contenido:
		$errorUl.html('');		
		
		// ----------------------------------------
		// Comenzamos las validaciones:
		// ----------------------------------------
	
		// Primero, validamos nombre_sala, centro_id
		var $salaObj = $("input#evaluacion_nombre_sala");
		var $centroObj = $("select#evaluacion_centro_id");
		
		var salaOk = checkIfBlank($salaObj, $errorUl, "El nombre de la sala no puede estar vacío.")
		var centroOk = checkIfBlank($centroObj, $errorUl, "La evaluación debe tener un centro asociado.")
		
		// Validamos que tenga escala:
		$escalaContainer = $('div#escala_container');
				
		// validamos la escala:
		escalaOk = validateEscala($escalaContainer, $errorUl);
		
		// Agrupamos resultados:		
		dataOk = salaOk && centroOk && escalaOk;
		
		// si la data tiene errores, desplazamos la ventana hacia arriba
		if(!dataOk)
		{
			// Animamos hacia el scrollTop
			$('html, body').animate({
			scrollTop: 0
			}, 1000);
		}
			
		return dataOk;
	}
	
	function validateEscala($escalaContainer, $errorUl)
	{
		// variable que indica si la escala está correcta:
		escalaOk = true;
		
		// Si no cargó nada, agregamos el error:
		if($escalaContainer.find('div.sub-escala section.item div.item_body input[type="radio"]').length == 0)
		{
			// En este caso escala container está vacío => lo vinculamos con el selector de escala:
			buildError($("select#escala"),$errorUl, "La evaluación debe tener una escala asociada.");
			
			// En este caso tendremos que agregar y remover la escala manualmente:
			$("select#escala").addClass("blank_entry");
			return false;
		}
		else
			$("select#escala").removeClass("blank_entry");

			
		// Si se cargó, verificamos que haya, al menos, un indicador seleccionado:
		if($escalaContainer.find('div.sub-escala section.item div.item_body input[type="radio"]:checked').length == 0)
		{
			// agregamos error:
			buildError($escalaContainer,$errorUl, "La evaluación no puede estar vacía.");

			// Retornamos pues no hay nada más que validar:		
			return false;
		}

		// Para cada Item, en cada sub-escala do:
		$escalaContainer.find('div.sub-escala').each(function(sub_esc_index, subEscala){
			$(subEscala).find('section.item').each(function(item_index, item){
				// Variable que indica si el ítem está ok:
				itemOk = true;
			
				// Buscamos el primer no_node
				$first_no =	$(item).find('div.item_body input[type="radio"].no_node:checked').first();
				si_count = $(item).find('div.item_body input[type="radio"]:checked').length;
				
				// si está vacío, debemos ver si tiene algún 'sí'; en ese caso, levantamos un error:
				if($first_no.length == 0 && si_count > 0)
				{
					buildError($(item),$errorUl,"Ítem inválido: El último indicador marcado debe ser 'no'.");
					$(item).addClass("blank_entry");
				}
				else
				{
					// En caso contrario, procedemos a evaluar el resto:
					$(item).addClass("blank_entry");				

					// Ahora, revisamos que todos los elementos antes de estén marcados:
					// ==================================================================

					// en este caso, $first_no es el radio button => td es el padre... tr es el padre del padre!
					row = $first_no.parent().parent();

					// no nos interesa partir de éste, sino de su antecesor:
					row = row.prev();
		
					// row.length == 0 <=> row = []
					while(row.length != 0)
					{			
						// En caso de que row sea el header de la tabla, cambiamos de tabla
						if(row.hasClass('table_header'))
							row = row.parent().parent().prev().find('tr:last')
				
						// NOTA: parent() es tbody => parent().parent() es table!
						if(row.is('tr'))
						{
							// Si es fila, revisamos si algún valor está chequeado
							// De no ser así, lo marcamos como en blanco:
							if(row.find('input:checked').length == 0)
							{
								escalaOk = false;
								itemOk = false;
								row.addClass('blank_entry');
							}
							else
								row.removeClass('blank_entry');
						}

						row = row.prev();
					}
				
					// Revisamos si el item está OK. En caso de no estarlo, agregamos el error:				 
					if(!itemOk)
					{
						buildError($(item),$errorUl,"Ítem inválido: No todos los indicadores antes del primer 'no' son positivos (En el caso de la primera columna, deben ser negativos).");
					
						$(item).addClass("blank_entry");
					}
					else
						$(item).addClass("blank_entry");				
				}				
			});
		});
		
		return escalaOk;
	}
	
	// Función para borrar un indicador
	function deleteIndicador(event){
		event.preventDefault();

		// borramos todos los indicadores de la fila:	
		$(this).parents("tr").find("input[type='radio']").each(function(index, indicador){
			$(indicador).prop('checked', false);
		});
	}
	
});

// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(function(){
	// NOTA: Delegates no funcionan si el selector también se carga dede ajax!

	// Variable que indica la cantidad de errores actuales:
	var errorCount = 0;

	// vinculamos con la función markPreviousIndicators
	$("section.item").delegate("input.no_node","click",markPreviousIndicators);
	//$("ajax_container").delegate("input.no_node","click",markPreviousIndicators);
	// vinculamos con la función toggleVisibility
	$("div.sub-escala").delegate("header", "click", toggleVisibility)
	$("div.sub-escala").delegate("header input[type='checkbox']", "click", function(e){
		e.stopPropagation();
	})
	//$("ajax_container").delegate("a", "click", toggleVisibility)
	
	//$("form#new_evaluacion").live("submit",validateData);
	$("form input[name='commit']").click(validateData)

	$("div#show-escala input").attr("disabled", "disabled");
	
	// Vinculamos los errores a goToError:	
	$("body").delegate("li.alert.alert-error","click",goToError);

	// vinculamos onClick de los links en los indicadores con deleteIndicador:
	$("body").delegate("a.details_btn.btn-mini.close.active","click", deleteIndicador);

	// delegate para mostrar la cruz de limpiar registro:
	$("section.item").delegate("input[type='radio']:not(.default_node)","click",showClearIndicador);


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

						$("div.sub-escala").delegate("header input[type='checkbox']", "click", function(e){
							e.stopPropagation();
						})
						// vinculamos onClick de los links en los indicadores con deleteIndicador:
						$("body").delegate("a.details_btn.btn-mini.close.active","click", deleteIndicador);

						// delegate para mostrar la cruz de limpiar registro:
						$("section.item").delegate("input[type='radio']:not(.default_node)","click",showClearIndicador);

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
		// En este caso, this es el radio button => td es el padre... tr es el padre del padre!
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
				if(row.find('input[type="radio"].si_node:checked, input[type="radio"].no_node:checked').length > 0)
					has_checked_value = true;
				else
				{
					// En caso contrario, revisamos si tiene NA node: 
				  input = row.find("input.na_node, input.si_node");
				  
				  // En caso de haber sólo uno, implica que no tiene NA node,
				  // por lo que procedemos a marcarlo:
				  if(input.length == 1){
				  	input.prop('checked',true);
						
						// Mostramos la cruz para limpiar el indicador:
						$clear_indicador = input.parents("tr").find("a.clearIndicador");
						$clear_indicador.addClass("active");
					}
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
		
		// llamamos a toggleObjectVisibility con los parámetros extraídos:
		toggleObjectVisibility($item_body, $icon);
	}
	
	function toggleObjectVisibility($item_body, $icon){
			// Si está expandido, lo contraemos
		if($icon.hasClass("icon-chevron-down"))
		{
			$icon.removeClass("icon-chevron-down");
			$item_body.slideUp();
			$icon.addClass("icon-chevron-left");
		}
		// En caso contrario, lo expandimos
		else if($icon.hasClass("icon-chevron-left"))
		{
			$icon.removeClass("icon-chevron-left");
			$item_body.slideDown();
			$icon.addClass("icon-chevron-down");
		}
	}
	
	function goToError(){
		// buscamos padding del body:
		var offset = parseInt($('body').css('padding-top'));
	
		// Leemos posición del error:
		var scrollPos = $(this).attr("data-scrollTop");
		var scrollPos = scrollPos - offset;
		
		// Obtenemos el objeto associado:
		var errorId = $(this).data("error");
		var $obj = $("[data-error='" + errorId + "']");
		
		// Vamos hacia el objeto
		goToObject($obj, scrollPos);
	}
	
	function goToObject($obj, scrollPos){
		
		// Revisamos si el elemento es un item. En caso de serlo, debemos
		// ocultar todos los items previos a éste en su sub-escala y
		// todas las sub-escalas previas:
		if($obj.is("section.item")){
			// 1. Ocultar hermanos previos:
			$obj.prevAll("section.item").each(function(item_index, item){
				// Revisamos si está expandido; si es así, lo comprimimos:
				var $item_body = $(item).children("div.item_body");
				var displayOption = $item_body.css("display");
				
				if(displayOption == "block"){
					var $icon = $(item).find("ul.nav.pull-right li a i");
					toggleObjectVisibility($item_body, $icon)				
				}
			});
			
			// 2. Ocultar sub-escalas anteriores: 
			var $sub_escala = $obj.parents("div.sub-escala");
			$sub_escala.prevAll("div.sub-escala").each(function(s_esc_index, sub){
				// Revisamos si está expandido; si es así, lo comprimimos:
				var $sub_body = $(sub).children("div.item_body");
				var displayOption = $sub_body.css("display");
				
				if(displayOption == "block"){
					var $icon = $(sub).find("ul.nav.pull-right li a i:first");
					toggleObjectVisibility($sub_body, $icon)				
				}
			});
		}
		
		// Finalmente, animamos hacia el scrollTop
		 $('html, body').animate({
		  scrollTop: scrollPos
		 }, 1000);
	}
	
	function buildError($obj, $errorUl, error)
	{
			// incrementamos la cantidad de errores actualmente registrados:
			errorCount = errorCount + 1;
	
			// Obtenemos scroll position del objeto:
			var objScrollTop = $obj.offset().top;
			
			// construimos error:
			var errorHTML = "<li class='alert alert-error' data-scrollTop='"+ objScrollTop + 
			"' data-error='" + errorCount + 
			"'><button type='button' class='close' data-dismiss='alert'>&times;</button>" + error + 
			"</li>";
			
			// Agregamos data-error al $obj para identificarlo más tarde:
			$obj.attr("data-error", errorCount);
			
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
		
		// TODO: resetar objectos con data-error y resetear errorCount
		
		// ----------------------------------------
		// Comenzamos las validaciones:
		// ----------------------------------------
	
		// Primero, validamos nombre_sala, centro_id
		var $salaObj = $("input#evaluacion_nombre_sala");
		var $centroObj = $("select#evaluacion_centro_id");
		
		var salaOk = !checkIfBlank($salaObj, $errorUl, "El nombre de la sala no puede estar vacío.")
		var centroOk = !checkIfBlank($centroObj, $errorUl, "La evaluación debe tener un centro asociado.")
		
		// Validamos que tenga escala:
		$escalaContainer = $('div#escala_container');
				
		// validamos la escala:
		escalaOk = validateEscala($escalaContainer, $errorUl);

		// Agrupamos resultados:		
		dataOk = salaOk && centroOk && escalaOk;

//		alert("salaOk= " + salaOk + 
//					"\ncentroOk= " + centroOk +
//					"\nescalaOk= " + escalaOk + 
//					"\n--------------------------" +
//					"\ndataOk= " + dataOk);
		
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
				si_count = $(item).find('div.item_body input[type="radio"].si_node:checked').length;
				
				// si está vacío, debemos ver si tiene algún 'sí'; en ese caso, levantamos un error:
				if($first_no.length == 0)
				{
					if(si_count > 0){
						buildError($(item),$errorUl,"Ítem inválido: El último indicador marcado debe ser 'no'.");
						$(item).addClass("blank_entry");
						escalaOk = false;
						itemOk = false;
					}
				}
				// En caso contrario, procedemos a evaluar el resto:
				else
				{
					$(item).addClass("blank_entry");				

					// Primero revisamos que todos los elementos de la columna estén marcados:
					// ==================================================================
					$first_no.parents("tr").nextAll("tr").each(function(tr_index, tr_entry){
						// revisamos si la entrada está vacía. En ese caso, señalamos el error:
						if($(tr_entry).find("input[type='radio']:not(.default_node):checked").length == 0){
							$(tr_entry).addClass("blank_entry");
							escalaOk = false;
							itemOk = false;
						}
					});
					
					if(!itemOk){
						buildError($(item),$errorUl,"Ítem inválido: No todos los indicadores después del primer 'no' están marcados.");
						itemOk = true;	// reseteamos el flag de errores en el item.
					}

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
							// (omitimos el radiobutton de default, puesto que de lo contrario siempre
							// habrá un valor seleccionado)
							if(row.find('input.si_node:checked, input.no_node:checked, input.na_node:checked').length == 0)
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
						$(item).removeClass("blank_entry");				
				}				
			});
		});
		
		return escalaOk;
	}
		
	// función para mostrar la 'X' que permite limpiar el indicador:
	function showClearIndicador(){
		// buscamos el link oculto que permite 'limpiar' el indicador:
		$clear_indicador = $(this).parents("tr").find("a.clearIndicador");
	
		// Procedemos a mostrarlo:
		$clear_indicador.addClass("active");
	}
	
	// Función para borrar un indicador, es decir, setearlo a su valor por defecto
	function deleteIndicador(event){
		event.preventDefault();

		// buscamos el radio button oculto que permite setear el valor a su valor por defecto:
		$default_node = $(this).parents("tr").find("input[type='radio'].default_node");
		
		// hecho esto, lo seleccionamos (hacer esto deseleccionará el valor previo automáticamente):
		$default_node.prop('checked', true);
		
		// Finalmente lo ocultamos:
		$(this).removeClass("active");
	}
});

// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(function(){
	$("tr.record td").click(loadRecord);
	
	function loadRecord()
	{
		// primero, verificamos que no contenga un switch o botón
		// en caso de ser así, no hacemos nada
		if($(this).find("input, a, button, select").length > 0)
			return;
	
		// En caso contrario, procedemos a cargar la url del usuario:
		var id = $(this).parent().attr("data-id");
		var record_class = $(this).parent().attr("data-class")
		
		// construimos url:
		var url = '/' + record_class + '/' + id;
		
		// redirijimos:
		window.location = url;
	};
	
	// Función para modificar rol de un usuario:
	$("tr.user-record select#admin").change(function(){
		var id = $(this).parents('tr.user-record').first().attr("data-id");
		
		// Obtenemos valiable seleccionada
		var $selected = $(this).find('option:selected')
		
		// obtenemos valor:
		var value = $selected.val();
		
		// verificamos que sea válido; en caso contrario, no hacemos nada:
		if(!(value == "1" || value == "0"))
			return;
		
		// hacemos llamada ajax
		$.ajax({
			url: '/users/' + id +'.json',
			data: { 'user': {'admin': value} },
			type: 'PUT',
			timeout: 8000,
			success: function(){
			},
			error: function(){
				// Si falló, mostramos un alert que indica que no se marcó:
				alert('No se pudo cambiar el rol del usuario');
				
				// volvemos al estado anterior, para esto lo desmarcamos...
				$selected.prop('selected',false);
				
				// y marcamos a su hermano:
				$selected.siblings().first().prop('selected',true);
				
			}
		});
	
	})
	
	// Función para modificar si una cuenta está activa
	$("tr.user-record div#active input[type='checkbox']").change(function(){
		// obtenemos id del usuario:
		var id = $(this).parents('tr.user-record').first().attr("data-id");

		// obtenemos si está chequeado o no
		var checked = $(this).prop('checked');
		
		// objeto this
		var $checkbox = $(this);
		
		// hacemos llamada ajax
		$.ajax({
			url: '/users/' + id +'.json',
			data: { 'user': {'active': checked ? 1 : 0} },
			type: 'PUT',
			timeout: 8000,
			success: function(){
			},
			error: function(){
				// Si falló, mostramos un alert que indica que no se marcó:
				alert('No se pudo activar/desactivar el usuario');
				
				// volvemos al estado anterior...
				$checkbox.prop('checked',!checked);				
		
				// y reflejamos esto en el controlador:
				if(checked)
				{
					$checkbox.parent().removeClass('switch-on');
					$checkbox.parent().addClass('switch-off');
				}
				else
				{
					$checkbox.parent().removeClass('switch-off');
					$checkbox.parent().addClass('switch-on');
				}
			}
		});
	});
});

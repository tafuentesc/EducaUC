// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(function(){
	$("tr.user-record td").click(loadUserRecord);
	
	function loadUserRecord()
	{
		// primero, verificamos que no contenga un switch o botón
		// en caso de ser así, no hacemos nada
		if($(this).find("input, a, button, select").length > 0)
			return;
	
		// En caso contrario, procedemos a cargar la url del usuario:
		var id = $(this).parent().attr("data-id");
		
		// construimos url:
		var url = '/users/'+id;
		
		// redirijimos:
		window.location = url;
	};
	
	// Función para modificar si una cuenta está activa
	$("tr.user-record div#active input[type='checkbox']").change(function(){
		// obtenemos id del usuario:
		var id = $(this).parents('tr.user-record').first().attr("data-id");

		// obtenemos si está chequeado o no
		var checked = $(this).prop('checked');
		
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
				
				// volvemos al estado anterior
				$(this).prop('checked',!checked);
			}
		});
	});
});

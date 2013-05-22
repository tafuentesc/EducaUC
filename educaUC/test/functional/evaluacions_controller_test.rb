require 'test_helper'

class EvaluacionsControllerTest < ActionController::TestCase
  setup do
    @evaluacion = evaluacions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:evaluacions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create evaluacion" do
    assert_difference('Evaluacion.count') do
      post :create, evaluacion: { encargado: @evaluacion.encargado, fecha_de_evaluacion: @evaluacion.fecha_de_evaluacion, horario_final: @evaluacion.horario_final, horario_inicial: @evaluacion.horario_inicial, nombre_sala: @evaluacion.nombre_sala }
    end

    assert_redirected_to evaluacion_path(assigns(:evaluacion))
  end

  test "should show evaluacion" do
    get :show, id: @evaluacion
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @evaluacion
    assert_response :success
  end

  test "should update evaluacion" do
    put :update, id: @evaluacion, evaluacion: { encargado: @evaluacion.encargado, fecha_de_evaluacion: @evaluacion.fecha_de_evaluacion, horario_final: @evaluacion.horario_final, horario_inicial: @evaluacion.horario_inicial, nombre_sala: @evaluacion.nombre_sala }
    assert_redirected_to evaluacion_path(assigns(:evaluacion))
  end

  test "should destroy evaluacion" do
    assert_difference('Evaluacion.count', -1) do
      delete :destroy, id: @evaluacion
    end

    assert_redirected_to evaluacions_path
  end
end

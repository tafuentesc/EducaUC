# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131026064908) do

  create_table "centros", :force => true do |t|
    t.string   "nombre"
    t.string   "direccion"
    t.string   "directora"
    t.string   "sostenedor"
    t.string   "telefono"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "escala_templates", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "escalas", :force => true do |t|
    t.integer  "escala_template_id"
    t.integer  "evaluacion_id"
    t.integer  "eval"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "evaluacions", :force => true do |t|
    t.string   "nombre_sala"
    t.datetime "fecha_de_evaluacion"
    t.integer  "encargado"
    t.time     "horario_inicial"
    t.time     "horario_final"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "estado",              :default => 0, :null => false
    t.integer  "centro_id"
  end

  create_table "indicador_templates", :force => true do |t|
    t.text     "descripcion"
    t.integer  "item_template_id"
    t.integer  "columna"
    t.integer  "fila"
    t.boolean  "has_na"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.text     "tooltip"
  end

  create_table "indicadors", :force => true do |t|
    t.integer  "indicador_template_id"
    t.integer  "item_id"
    t.integer  "eval",                  :default => -2
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  create_table "item_templates", :force => true do |t|
    t.string   "nombre"
    t.string   "descripcion"
    t.integer  "subescala_template_id"
    t.boolean  "has_na"
    t.integer  "numero"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "items", :force => true do |t|
    t.integer  "item_template_id"
    t.integer  "subescala_id"
    t.integer  "eval",             :default => 0
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.text     "observaciones"
  end

  create_table "objetados", :force => true do |t|
    t.integer  "evaluacion_id"
    t.integer  "admin_id"
    t.string   "razon"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "salas", :force => true do |t|
    t.string   "nombre"
    t.integer  "centro_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "subescala_templates", :force => true do |t|
    t.string   "nombre"
    t.integer  "numero"
    t.integer  "escala_template_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "subescalas", :force => true do |t|
    t.integer  "subescala_template_id"
    t.integer  "escala_id"
    t.integer  "eval",                  :default => 0
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "lastname"
    t.integer  "active"
    t.boolean  "admin"
    t.string   "hash_password"
    t.string   "token"
    t.string   "salt"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end

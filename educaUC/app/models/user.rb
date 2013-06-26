require 'securerandom'

class User < ActiveRecord::Base
  attr_accessible :admin, :active, :email, :hash_password, :id, :lastname, :name, :salt, :token
	# deleted/ changed attributes: deleted->active, profile

	#has_many :dataFiles, :primary_key => :email, :foreign_key => :owner, :dependent => :destroy
	before_save :encrypt_password
	before_create :set_defaults
	
	validates_presence_of :name, :lastname
	validates_uniqueness_of :email
	validate :email, :format => { :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/, :message => "Email address not valid" }
	
	has_many :evaluaciones, :class_name => Evaluacion, :foreign_key => :encargado
	
	def set_defaults
		self.active = 1
		
		if(self.admin==nil)
			self.admin = false
		end
	end
	
	def generateToken
		# generamos session_id
		session_token = SecureRandom.hex(16)
		
		self.token = session_token
		self.save
		return session_token
	end
	
	# TODO: revisar comparando con Taller_Web/
	def encrypt_password
			# Generamos Salt y encriptamos el password del nuevo usuario
			if(self.salt.nil?)
				self.salt = SecureRandom.hex(16) 
			end
			
			if(self.hash_password_changed?)
				password = self.salt + self.hash_password
			
				10.times do |x|
					password = Digest::SHA1.hexdigest(password)
				end

				self.hash_password = password
			end
			# enviamos mail al usuario con su contraseñas
			# UserMailer.welcome_email(self, unencripted_pass).deliver
	end
	
	# Atributo virtual que indica si es un admin o no
	def role
		if(self.admin?) 
			return "Administrador"
		else
			return "Digitador"
		end
	end
	
	def role=(new_role)
		if(new_role=="Digitador")
			self.admin = false
		elsif(new_role=="Administrador")
			self.admin = true
		else
			self.admin = nil
		end
	end
end

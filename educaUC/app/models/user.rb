require 'securerandom'

class User < ActiveRecord::Base
  attr_accessible :admin, :deleted, :email, :hash_password, :id, :lastname, :name, :salt, :profile, :token

	#has_many :dataFiles, :primary_key => :email, :foreign_key => :owner, :dependent => :destroy
	before_create :generate_password
	validates_uniqueness_of :email
	validate :email, :format => { :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/, :message => "Email address not valid" }
	
	has_many :evaluaciones, :class_name => Evaluacion, :foreign_key => :encargado
	
	def generateToken
		# generamos session_id
		session_token = SecureRandom.hex(16)
		
		self.token = session_token
		self.save
		return session_token
	end
	
	def generate_password
			# Generamos Salt y encriptamos el password del nuevo usuario
			self.salt = SecureRandom.hex(16) 
			puts self.hash_password
			password = salt + self.hash_password

			
			10.times do |x|
				password = Digest::SHA1.hexdigest(password)
			end

			self.hash_password = password
			
			# enviamos mail al usuario con su contraseñas
			# UserMailer.welcome_email(self, unencripted_pass).deliver
	end

end

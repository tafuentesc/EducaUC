module EvaluacionsHelper

	def createPDF
		pdf = Prawn::Document.new
		pdf.text "Hello World!"
		pdf.render_file "test.pdf"
	end


end

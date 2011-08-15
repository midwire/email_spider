class EmailsController < ApplicationController
  def index
    @emails = Email.all
    respond_to do |format|
      format.html
      format.csv do
        csv_string = FasterCSV.generate do |csv|
          # header row
          csv << ["email address"]
          # data rows
          @emails.each do |email|
            csv << [email.address]
          end
        end
        
        # send it to the browser
        send_data csv_string,
                  :type => 'text/csv; charset=iso-8859-1; header=present',
                  :disposition => "attachment; filename=emails.csv"
        
      end
    end
  end
end

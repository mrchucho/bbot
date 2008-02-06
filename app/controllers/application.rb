class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  helper :all 

  rescue_from ActiveRecordRecord::RecordInvalid, :with => :invalid_record

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # Commented out for localhost
  # protect_from_forgery # :secret => '453ac4c5492006093d78dbdfbbcdce09'

private
  def invalid_record(exception)
    record = exception.record
    respond_to do |format|
      format.html { render :action => (record.new_record? ? 'new' : 'edit') }
      format.xml  { render :xml => record.errors.to_xml, :status => :unprocessable_entity }
      format.js   { render :json => record.errors.to_json, :status => :unprocessable_entity }
    end
  end
end

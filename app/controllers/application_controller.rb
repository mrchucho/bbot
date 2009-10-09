class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  helper :all 
  rescue_from ActiveRecord::RecordInvalid, :with => :invalid_record

  protect_from_forgery

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

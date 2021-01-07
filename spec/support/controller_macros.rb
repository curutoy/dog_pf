module ControllerMacros
  def protector_signed_in?
    sign_in protector
  end
end

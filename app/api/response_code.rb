# frozen_string_literal: true

#
# Returns the result Code definition
#
# @author hubery.cui
#
module ResponseCode
  # ----------------------------------------------------------------------------#
  # Exception (1-9999) #
  # The code # is reserved here for the return result of exception handling
  # ------------------------------------------------------------------#

  # ---------------------a system exception (1-1999) ------------------------------------------------------------#
  # ---------------------a system exception exception coding on the level of development to achieve, mainly in 
  # ---------------------the service of the developer for system maintenance ---------------------

  # ----------------------general exception (1-99) ----------------------------------------------------------------#

  FAILED = 1 # Universal failure
  AUTH_FAILED = 2 # Authentication fails

  # -----------------------the interface layer anomaly (100-299) ---------------------------------------------------------#

  API_PARAMS_ERROR = 100 # Interface layer parameters are abnormal

  # -----------------------logic layer anomalies (300-499) ---------------------#

  CMD_VALIDATE_ERROR = 300 # Logical Level validation General exception
  CMD_VALIDATE_MIX_ERROR = 301 # Logical level validates mixed exceptions
  CMD_VALIDATE_INVALID_ERROR = 302 # The logical layer fails to pass the verification
  CMD_VALIDATE_REQUIRED_ERROR = 303 # The logical layer must verify the exception

  # -----------------------model layer anomalies (500-699) ---------------------------------------------------------#

  # -----------------------a business exception (2000-8999) --------------------------------------------------------#
  # ----------------------a business exception is abnormal coding product definition, that is, mainly in the service of the product and user screen problem ---------------------------#
  AUTHORIZE_FAILED = 2000
  # -------------------------------------------------------------------------------#
  # Normal (10000-19999) #
  # Encoding # is reserved here for the return result of normal processing
  # -------------------------------------------------#

  SUCCESS = 10000 # Universal success
end

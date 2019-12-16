require './config/environment'

use Rack::MethodOverride

run ApplicationController
use UsersController
use AccountController
use AppointmentsController
use ServicesController
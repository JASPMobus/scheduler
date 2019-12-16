require './config/environment'

use Rack::MethodOverride

run ApplicationController
use UsersController
use AccountController
use ScheduleController
use AppointmentsController
use ServicesController
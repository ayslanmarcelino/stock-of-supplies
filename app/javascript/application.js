// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import Swal from 'sweetalert2';
import '../../lib/assets/javascripts/confirm';
import '../../lib/assets/javascripts/masks';
import '../../lib/assets/javascripts/fill_address';
import '../../lib/assets/javascripts/required_fields';
import '../../lib/assets/javascripts/validate_document_number/person';
import 'chartkick/chart.js'

window.Swal = Swal;

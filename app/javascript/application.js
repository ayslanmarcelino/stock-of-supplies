// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import Swal from 'sweetalert2';
import '../../lib/assets/javascripts/confirm';
import '../../lib/assets/javascripts/masks';
import '../../lib/assets/javascripts/fill_address';
import '../../lib/assets/javascripts/chart';
import '../../lib/assets/javascripts/required_fields';
import '../../lib/assets/javascripts/order_fields';
import '../../lib/assets/javascripts/validates/document_number/person';
import '../../lib/assets/javascripts/validates/cns_number';
import 'chartkick/chart.js'

window.Swal = Swal;

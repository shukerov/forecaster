import $ from "jquery";
import selectize from "selectize/dist/js/standalone/selectize.min.js";
import "selectize/dist/css/selectize.default.css";

// fetches locations from our RoR backend
async function getLocations(address, callback) {
  const addressPromise = await fetch(`/locations/index.json?address_search=${address}`);
  const addressJSON = await addressPromise.json();

  callback(addressJSON);
}

// selectize fields
// TODO: need to throttle this
$('#address').selectize({
  valueField: 'address_info',
  labelField: 'address_name',
  searchField: ['address_name'],
  closeAfterSelect: true,
  load: getLocations,
});



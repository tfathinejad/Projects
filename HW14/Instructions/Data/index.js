// Get references to the tbody element, input field and button
var $tbody = document.querySelector("tbody");
var $datetimeInput = document.querySelector("#datetime");
var $cityInput = document.querySelector("#city");
var $stateInput = document.querySelector("#state");
var $countryInput = document.querySelector("#country");
var $shapeInput = document.querySelector("#shape");
var $searchBtn = document.querySelector("#search");

// Add an event listener to the searchButton, call handleSearchButtonClick when clicked
$searchBtn.addEventListener("click", handleSearchButtonClick);

// Set filteredAddresses to addressData initially
var filteredData = dataSet;
// console.log(addressData)

// renderTable renders the filteredAddresses to the tbody
function renderTable() {
  $tbody.innerHTML = "";
  for (var i = 0; i < filteredData.length; i++) {
    // Get get the current address object and its fields
    var info = filteredData[i];
    var fields = Object.keys(info);
    // Create a new row in the tbody, set the index to be i + startingIndex
    var $row = $tbody.insertRow(i);
    for (var j = 0; j < fields.length; j++) {
      // For every field in the address object, create a new cell at set its inner text to be the current value at the current address's field
      var field = fields[j];
      var $cell = $row.insertCell(j);
      $cell.innerText = info[field];
    }
    // console.log(info)
  }
}

function handleSearchButtonClick() {
  // Format the user's search by removing leading and trailing whitespace, lowercase the string

  var filterDate = $datetimeInput.value;
  // var filterCity = $cityInput.value.trim().toLowerCase;
  // var filterState = $stateInput.value.trim().toLowerCase();
  // var filterCountry = $countryInput.value.trim().toLowerCase();
  // var filterShape = $shapeInput.value.trim().toLowerCase;


  // console.log(filterDate)
  // Set filteredAddresses to an array of all addresses whose "state" matches the filter
  // infox is chicken
  filteredData = dataSet.filter(function(infox) {
    // If true, add the address to the filteredAddresses, otherwise don't add it to filteredAddresses
    // console.log(infox)
    // false, 0, '', null, undefined ====> false
    if (filterDate && filterDate != infox.datetime) {
      // console.log('failed on dat);
      return false;
    }
    //   else {
    //   console.log('passed date');
    // }

    // console.log('=== filter date ===');
    // console.log(filterDate);
    // console.log(infox.date.trim().toLowerCase());
  

    // if (filterCity && filterCity != infox.city.trim().toLowerCase()) {
    //   console.log(filterCity)
    //   return false;
    // }

    // if (filterState && filterState != infox.state.trim().toLowerCase()) {
    //   return false;
    // }

    // if (filterCountry && filterCountry != infox.country.trim().toLowerCase()) {
    //   return false;
    // }


    // if (filterShape && filterShape != infox.shape.trim().toLowerCase()) {
    //   return false;
    // }

    // console.log(filteredData)
    return true;
  });

  // console.log(filteredAddresses)
  renderTable();
}

// Render the table for the first time on page load
renderTable();

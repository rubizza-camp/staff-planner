changeAction = function(select){
  const selectedValue = select.options[select.selectedIndex].value;
  document.getElementById('events_form').action = `/employees/${selectedValue}/events`;
}

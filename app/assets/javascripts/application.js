// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require autocomplete-rails
//= require jquery.cookie
//= require bootstrap-datepicker
//= require twitter/bootstrap
//= require jquery.turbolinks
//= require jquery_nested_form
//= require_tree .


$(document).ready(function() {
	if($.cookie("time_zone") == null) {
    	$.ajax({
           url: "/set_time_zone",
           type: "POST",
           dataType: "html",
		   headers: {
		      'X-Transaction': 'POST Timezone',
		      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') },
           data: { 'time_zone_name': jstz.determine().name() }
           });
	}
	
	$('.datepicker').datepicker({
		format: "dd-mm-yyyy",
		weekStart: 1 // day of the week start. 0 for Sunday - 6 for Saturday
	});
		
	$('#myModal').on('shown.bs.modal', function() {
	    $("#q_in_modal").keypress(function(e) {
		    if (e.keyCode == $.ui.keyCode.ENTER) {
				return false;
		    }
		});
		
	})    
})

$(document).on('nested:fieldAdded', function(event){
  // this field was just inserted into your form
  var field = event.field; 
  // it's a jQuery object already! Now you can find date input
  var dateField = field.find('.datepicker');
  // and activate datepicker on it
  dateField.datepicker({ format: 'yyyy-mm-dd' });
})

function check_if_costumer_exists(object, type) {
	$.ajax({
        url: "/check_if_costumer_exists",
        type: "POST",
        dataType: "html",
		headers: {
		   'X-Transaction': 'POST Timezone',
		   'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') },
        data: { 'type': type, 'value' : object.value }, 
		success: function(data) {
			if(data != "null") {
				var json = JSON.parse(data)
				$('#customer_rut').val(json['rut']);
				$('#customer_name').val(json['name']);
				$('#customer_email').val(json['email']);
				$('#customer_phone_number').val(json['phone_number']);
				if(json['birthday'] != null) {
					$('#customer_birthday').val(json['birthday'].substring(0, 10));
				} else {
					$('#customer_birthday').val("");
				}
			}
        }
    });
}

function search_products_ajax(supplier_account_id) {
	$.ajax({
        url: "/search_products_ajax",
        type: "POST",
        dataType: "html",
		headers: {
		   'X-Transaction': 'POST SearchProduct',
		   'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') },
        data: { 'q' : $('#q_in_modal').val(), 'supplier_account_id' : supplier_account_id }, 
		success: function(data) {
			if(data != "null") {
				$( "#records_table tbody tr" ).remove();
				var response = JSON.parse(data)
				$.each(response, function(i, item) {
			        var $tr = $('<tr>').append(
   						$('<td>').html('<img src="'+item.image_url+'" />'),
			            $('<td>').text(item.name),
			            $('<td>').text(item.size),
						$('<td>').text(item.color),
						$('<td>').text(item.barcode)).appendTo('#records_table');
			    });
        	}
		}
    });
}

function update_product_name_label(field, supplier_account_id) {
	aux = field.id.replace(/[^0-9]/g,'');
	$.ajax({
        url: "/search_product_ajax",
        type: "POST",
        dataType: "html",
		headers: {
		   'X-Transaction': 'POST SearchProduct',
		   'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') },
        data: { 'q' : field.value, 'supplier_account_id' : supplier_account_id }, 
		success: function(data) {
			if(data != "null") {
				var response = JSON.parse(data);
		        $("[for='supply_purchase_supply_purchase_product_sizes_attributes_"+aux+"_product_stock_size_barcode']")[0].innerHTML = response.name;
        	}
		}
    });
}

function get_gift_card_value(field) {
	aux = field.id.replace(/[^0-9]/g,'');
	barcode = field.value
	total = $('#total').html().replace(/\D/g,'');
	$.ajax({
        url: "/get_gift_card_value",
        type: "POST",
        dataType: "html",
		headers: {
		   'X-Transaction': 'POST Timezone',
		   'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') },
        data: { 'barcode': barcode }, 
		success: function(data) {
			if(data != "null") {
				var json = JSON.parse(data);
				if(json['status'] == 'valid') {
			        $("[for='purchase_gift_cards_attributes_"+aux+"_barcode']")[0].innerHTML = 'Valor GiftCard: $ '+json['amount'];
					new_total = total - json['amount']
					$('#total').html('$ '+new_total);
					$('#purchase_payments_attributes_0_amount').val(new_total);
				} else {
			        $("[for='purchase_gift_cards_attributes_"+aux+"_barcode']")[0].innerHTML = 'GiftCard ya utilizada';
				}
			} else {
			        $("[for='purchase_gift_cards_attributes_"+aux+"_barcode']")[0].innerHTML = 'GiftCard no encontrada';
			}
        }
    });
	
}

function calculate_subtotal_with_discount(object, subtotal, type) {
	total = 0
	if(type == "percentage") {
		total = subtotal * (1-object.value/100)
	} else {
		total = subtotal - object.value
	}
	$('#total').html('$ '+Math.ceil(total));
	$('#purchase_payments_attributes_0_amount').val(total);
}

function update_warehouse() {
	$.cookie("warehouse_id", $('#warehouse_id').val())
	location.reload();
}

function printDiv(divName) {
	$('#'+divName).printThis({ pageTitle: 'Barcodes'})
}
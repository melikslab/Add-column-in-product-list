 <th style="width: 7rem">
    <input type="hidden" id="filter_column_mpn" name="filter_column_mpn" value="" sql="">
    <input class="form-control form-min-max" type="text" id="filter_column_mpn_min" value="" placeholder="Mín." aria-label="valor mínimo de filter_column_mpn">
    <input class="form-control form-min-max" type="text" id="filter_column_mpn_max" value="" placeholder="Máx." aria-label="valor máximo de filter_column_mpn">
</th>

<script>
    $(document).ready(function() {
        var sliderInput = $('#filter_column_mpn');
        var minInput = $('#filter_column_mpn_min');
        var maxInput = $('#filter_column_mpn_max');

        // parse and fix init value
        var value = sliderInput.attr('sql');
        if (value != '') {
            value = value.replace('BETWEEN ', '');
            value = value.replace(' AND ', ',');
            value = value.replace('<=', '0,');
            value = value.replace('>=', '3000000000,');
            value = value.split(',');
            value[0] = Number(value[0]);
            value[1] = Number(value[1]);
        } else {
            value = [0, 3000000000];
        }
        value = value.sort(function sortNumber(a,b) {
            return a - b;
        });

        // Init inputs
        if (value[0] > 0)
            minInput.val(value[0]);
        if (value[1] < 3000000000)
            maxInput.val(value[1]);

        // Change events
        var inputFlasher = function(input) {
            // animate input to highlight it (like a pulsate effect on jqueryUI)
            $(input).stop().delay(100)
                    .fadeIn(100).fadeOut(100)
                    .queue(function() { $(this).css("background-color", "#FF5555").dequeue(); })
                    .fadeIn(160).fadeOut(160).fadeIn(160).fadeOut(160).fadeIn(160)
                    .animate({ backgroundColor: "#FFFFFF"}, 800);
        };
        var updater = function(srcElement) {
            var isMinModified = (srcElement.attr('id') == minInput.attr('id'));

            // retrieve values, replace ',' by '.', cast them into numbers (float/int)
            var newValues = [(minInput.val()!='')?Number(minInput.val().replace(',', '.')):0, (maxInput.val()!='')?Number(maxInput.val().replace(',', '.')):3000000000];

            // if newValues are out of bounds, or not valid, fix the element.
            if (isMinModified && !(newValues[0] >= 0 && newValues[0] <= 3000000000)) {
                newValues[0] = 0;
                minInput.val('');
                inputFlasher(minInput);
            }
            if (!isMinModified && !(newValues[1] >= 0 && newValues[1] <= 3000000000)) {
                newValues[1] = 3000000000;
                maxInput.val('');
                inputFlasher(maxInput);
            }

            // if newValues are not ordered, fix the opposite input.
            if (isMinModified && newValues[0] > newValues[1]) {
                newValues[1] = newValues[0];
                maxInput.val(newValues[0]);
                inputFlasher(maxInput);
            }
            if (!isMinModified && newValues[0] > newValues[1]) {
                newValues[0] = newValues[1];
                minInput.val(newValues[0]);
                inputFlasher(minInput);
            }

            if (newValues[0] == 0 && newValues[1] == 3000000000) {
                sliderInput.attr('value', '');
            } else if (newValues[0] == 0) {
                sliderInput.attr('value', '<='+newValues[1]);
            } else if (newValues[1] == 3000000000) {
                sliderInput.attr('value', '>='+newValues[0]);
            } else {
                sliderInput.attr('value', 'BETWEEN ' + newValues[0] + ' AND ' + newValues[1]);
            }

                    }
        minInput.on('change', function(event) {
            updater($(event.srcElement));
        });
        maxInput.on('change', function(event) {
            updater($(event.srcElement));
        });
    });
</script>
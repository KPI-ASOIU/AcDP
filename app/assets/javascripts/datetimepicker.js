$.fn.datetimepicker = function(config) {
    var $target = this,
        module;

    config = {
        format: 'DD.MM.YYYY HH:mm'
    }

    module = {
        date: moment($target.val(), config.format),
        focus: moment($target.val(), config.format),
        initialize: function() {
            $target.wrap('<div class="ui icon date input"></div>');
            $target.after(function() {
                module.popup = $('<div class="ui popup transition hidden">');
                module.initCalendar(module.date);
                return module.popup;
            });
            $target.after('<i class="calendar icon"></i>');
            $target.popup({
                hoverable: true,
                inline: true,
                on: 'click',
                position: 'bottom left'
            });
            this.target = $target;
            this.addEventListeners();
        },
        initCalendar: function(date) {
            var $timepicker = this.buildTimePicker(date);
            this.popup.append(this.buildDatePicker(date));
            this.popup.append($timepicker);
            $timepicker.transition('hide');
        },
        buildTimePicker: function(date) {
            // split the function
            var $timepicker = $("<table class='timepicker'>"),
                $switchControl = $("<thead>"),
                $timeControls = $("<tbody>"),
                $switcher = $("<th id='switchToDate' colspan='7'><i class='calendar icon'></i></th>"),
                $upControls = $("<tr>"),
                $time = $("<tr>"),
                $downControls = $("<tr>"),
                $hourUpControl = $('<th><i class="angle up icon"></i></td>'),
                $hourDownControl = $('<th><i class="angle down icon"></i></td>'),
                $minuteUpControl = $('<th><i class="angle up icon"></i></td>'),
                $minuteDownControl = $('<th><i class="angle down icon"></i></td>');
            $switchControl.append($switcher)
            $hourUpControl.data('unit', 'hours')
            $hourDownControl.data('unit', 'hours')
            $minuteUpControl.data('unit', 'minutes')
            $minuteDownControl.data('unit', 'minutes')
            $upControls.append($hourUpControl)
            $upControls.append($('<td>'))
            $upControls.append($minuteUpControl)
            $time.append($("<td id='hours'>" + date.format("HH") + "</td>"))
            $time.append($("<td>:</td>"))
            $time.append($("<td id='minutes'>" + date.format("mm") + "</td>"))
            $downControls.append($hourDownControl)
            $downControls.append($('<td>'))
            $downControls.append($minuteDownControl)
            $timeControls.append($upControls)
            $timeControls.append($time)
            $timeControls.append($downControls)
            $timepicker.append($switchControl)
            $timepicker.append($timeControls)
            return $timepicker
        },
        adjustStartDate: function(date) {
            var weekday = date.weekday(); // ranges from 0 to 6 (Monday to Sunday)
            return date.subtract(weekday, 'days')
        },
        buildDatePicker: function(date) {
            var startDate = this.adjustStartDate(moment(date).startOf('month')),
                endDate = moment(date).endOf('month'),
                currentDate = moment(startDate),
                $calendar = $("<table>"),
                $month = $("<tbody>"),
                $switcher = $("<tfoot>");
            $switcher.append($('<th id="switchToTime" colspan="7"><i class="time icon"></th>'))
            $month.append(this.buildMonthHeader());
            while (currentDate < endDate) {
                $week = $("<tr>")
                while (currentDate.weekday() < 6) {
                    this.appendDayToWeek(currentDate, $week)
                }
                this.appendDayToWeek(currentDate, $week)
                $month.append($week);
            }
            $calendar.append(this.buildDateControls(date));
            $calendar.append($month);
            $calendar.append($switcher);
            return $calendar;
        },
        buildDateControls: function(date) {
            var $controls = $("<thead>"),
                controlHeader = date.format("MMMM YYYY"),
                $prevControl = $("<th class='prev'><i class='angle left icon'></i></th>"),
                $nextControl = $("<th class='next'><i class='angle right icon'></i></th>"),
                $switchControl = $("<th class='switch' colspan='5'>" + controlHeader + "</th>");
            $controls.append($prevControl);
            $controls.append($switchControl);
            $controls.append($nextControl);
            return $controls;
        },
        appendDayToWeek: function(date, week) {
            week.append(this.buildDay(date));
            date.add(1, 'days');
        },
        constructWeekdaysList: function() {
            var momentWeekdays = moment.weekdaysShort(),
                week = [0, 1, 2, 3, 4, 5, 6];
            return $.map(week, function(val, i) {
                return momentWeekdays[moment().weekday(val).day()]
            })
        },
        buildMonthHeader: function() {
            var $header = $("<tr>");
            $.each(this.constructWeekdaysList(), function() {
                $header.append($("<th>" + this + "</th>"));
            });
            return $header;
        },
        buildDay: function(date) {
            if (date.isSame(moment(), 'day')) {
                var day = $("<td class='present day'>" + date.date() + "</td>")
            } else if (date.isBefore(module.focus, 'month')) {
                var day = $("<td class='past day'>" + date.date() + "</td>")
            } else if (date.isAfter(module.focus, 'month')) {
                var day = $("<td class='future day'>" + date.date() + "</td>")
            } else {
                var day = $("<td class='day'>" + date.date() + "</td>")
            }

            if (date.isSame(module.date, 'day'))
                day.addClass('active')
            day.data('date', moment(date));
            return day
        },
        activate: function(day) {
            $('td.day').removeClass('active');
            day.addClass('active');
        },
        refreshCalendar: function(pastDate, $day) {
            if (!this.date.isSame(pastDate, 'month') && !this.focus.isSame(this.date, 'month')) {
                console.log("FULL REFRESH!!!")
                this.popup.empty();
                this.focus = this.date;
                this.initCalendar(this.date);
                $day = null;
            }
            if (!$day) {
                $day = this.popup.find('td.day:not(.past):not(.future)').filter(function() {
                    return $(this).text() == module.date.date()
                });
            }
            module.activate($day);
        },
        previous: function() {
            var trice = moment(this.focus).subtract(1, 'month');
            module.focus = trice;
            this.popup.empty();
            this.initCalendar(trice);
        },
        next: function() {
            var trice = moment(this.focus).add(1, 'month');
            module.focus = trice;
            this.popup.empty();
            this.initCalendar(trice);
        },
        addEventListeners: function() {
            $(document).on('click', 'td.day', function(e) {
                e.stopPropagation();

                var pastDate = module.date,
                    $timepicker = $(this).closest('.date.input').find('table.timepicker'),
                    $hours = $timepicker.find('#hours'),
                    $minutes = $timepicker.find('#minutes');
                module.date = $(this).data('date');
                module.target.val(module.date.format("DD.MM.YYYY HH:mm"));
                $hours.text(module.date.format("HH"))
                $minutes.text(module.date.format("mm"))
                module.refreshCalendar(pastDate, $(this));
            });

            $(document).on('click', 'th.prev', function(e) {
                e.stopPropagation();
                module.previous();
            });

            $(document).on('click', 'th.next', function(e) {
                e.stopPropagation();
                module.next();
            });

            $(document).on('click', 'table.timepicker tbody th', function(e) {
                e.stopPropagation();

                var $timepicker = $(this).closest('table.timepicker'),
                    $hours = $timepicker.find('#hours'),
                    $minutes = $timepicker.find('#minutes'),
                    trice = moment(module.date);
                if ($(this).find('i').hasClass('up')) {
                    module.date.add(1, $(this).data('unit'))
                } else {
                    module.date.subtract(1, $(this).data('unit'))
                }
                module.target.val(module.date.format("DD.MM.YYYY HH:mm"));
                $hours.text(module.date.format("HH"))
                $minutes.text(module.date.format("mm"))
                if (!module.date.isSame(trice, 'date')) {
                    module.refreshCalendar(trice);
                }
            });

            $(document).on('click', 'th#switchToTime', function(e) {
                e.stopPropagation();
                var $timepicker = module.popup.find('table.timepicker'),
                    $datepicker = module.popup.find('table:first');
                $datepicker.transition('hide');
                $timepicker.transition('show');
            });

            $(document).on('click', 'th#switchToDate', function(e) {
                e.stopPropagation();
                var $timepicker = module.popup.find('table.timepicker'),
                    $datepicker = module.popup.find('table:first');
                $timepicker.transition('hide');
                $datepicker.transition('show');
            });
        }
    }

    module.initialize();

    return this
}

$('#eventDate').datetimepicker();


// $(function() {
//     function matchDateRegex(date) {
//         return /[0-9]{2}\.[0-9]{2}\.[0-9]{4}/.test(date)
//     }

//     $('#startDate').datetimepicker({
//         // TODO
//         // 	=> make here default project language
//         useCurrent: false,
//         defaultDate: '',
//         pickTime: false,
//         language: 'uk'
//     });

//     $('#endDate').datetimepicker({
//         // TODO
//         // 	=> make here default project language
//         useCurrent: false,
//         defaultDate: '',
//         pickTime: false,
//         language: 'uk'
//     });

//     $('#creationStartDate').datetimepicker({
//         // TODO
//         // 	=> make here default project language
//         useCurrent: false,
//         defaultDate: '',
//         pickTime: false,
//         language: 'uk'
//     });

//     $('#creationEndDate').datetimepicker({
//         // TODO
//         // 	=> make here default project language
//         useCurrent: false,
//         defaultDate: '',
//         pickTime: false,
//         language: 'uk'
//     });

//     $('#taskDate').datetimepicker({
//         // TODO
//         //  => make here default project language
//         useCurrent: false,
//         defaultDate: '',
//         language: 'uk',
//         icons: {
//             time: 'time icon',
//             date: 'calendar icon'
//         }
//     });

//     $('#eventDate').datetimepicker({
//         // TODO
//         //  => make here default project language
//         useCurrent: false,
//         defaultDate: '',
//         pickTime: false,
//         language: 'uk'
//     });

//     $('#taskDate').change(function() {
//         if (!matchDateRegex($(this).val()))
//             $(this).val('')
//     });

//     $('#eventDate').change(function() {
//         if (!matchDateRegex($(this).val()))
//             $(this).val('')
//     });

//     $('#startDate').change(function() {
//         if (!matchDateRegex($(this).val()))
//             $(this).val('')
//     });

//     $('#endDate').change(function() {
//         if (!matchDateRegex($(this).val()))
//             $(this).val('')
//     });

//     $('#creationStartDate').change(function() {
//         if (!matchDateRegex($(this).val()))
//             $(this).val('')
//     });

//     $('#creationEndDate').change(function() {
//         if (!matchDateRegex($(this).val()))
//             $(this).val('')
//     });
// });
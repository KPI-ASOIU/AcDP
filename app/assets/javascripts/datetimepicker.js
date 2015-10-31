$.fn.datetimepicker = function(config) {
    var $target = this,
        module;

    module = {
        date: moment(),
        initialize: function() {
            $target.wrap('<div class="ui icon date input"></div>');
            $target.after(function() {
                var popup = $('<div class="ui popup transition hidden">');
                module.initCalendar(popup);
                return popup;
            });
            $target.after('<i class="calendar icon"></i>');
            $target.popup({
                inline: true,
                on: 'click',
                position: 'bottom left'
            });
        },
        initCalendar: function(element) {
            element.append(this.buildMonth(this.date));
        },
        adjustStartDate: function(date) {
            var weekday = date.weekday(); // ranges from 0 to 6 (Monday to Sunday)
            return date.subtract(weekday, 'days')
        },
        buildMonth: function() {
            var startDate = this.adjustStartDate(moment(this.date).startOf('month')),
                endDate = moment(this.date).endOf('month'),
                currentDate = moment(startDate),
                $calendar = $("<table>"),
                $month = $("<tbody>");
            $month.append(this.buildMonthHeader());
            while (currentDate < endDate) {
                $week = $("<tr>")
                while (currentDate.weekday() < 6) {
                    this.appendDayToWeek(currentDate, $week)
                }
                this.appendDayToWeek(currentDate, $week)
                $month.append($week);
            }
            $calendar.append(this.buildDateControls());
            $calendar.append($month);
            return $calendar;
        },
        buildDateControls: function() {
            var $controls = $("<thead>"),
                controlHeader = this.date.format("MMMM YYYY"),
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
                return $("<td class='present day active'>" + date.date() + "</td>")
            } else if (date.isBefore(moment(), 'month')) {
                return $("<td class='past day'>" + date.date() + "</td>")
            } else if (date.isAfter(moment(), 'month')) {
                return $("<td class='future day'>" + date.date() + "</td>")
            } else {
                return $("<td class='day'>" + date.date() + "</td>")
            }
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
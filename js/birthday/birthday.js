(function ($) {
    $.extend({
        ms_DatePicker: function (options) {
            var defaults = {
                YearSelector: "#birthday_Y",
                MonthSelector: "#birthday_M",
                DaySelector: "#birthday_D",
                FirstText: "--",
                FirstText1: "年",
                FirstText2: "月",
                FirstText3: "日",
                FirstValue: ""
            };
            var opts = $.extend({}, defaults, options);
            var $YearSelector = $(opts.YearSelector);
            var $MonthSelector = $(opts.MonthSelector);
            var $DaySelector = $(opts.DaySelector);

            var FirstText1 = opts.FirstText1;
            var FirstText2 = opts.FirstText2;
            var FirstText3 = opts.FirstText3;
            var FirstValue = opts.FirstValue;

            // 初始化

            var str1 = "<option value=\"" + FirstValue + "\">" + FirstText1 + "</option>";
            var str2 = "<option value=\"" + FirstValue + "\">" + FirstText2 + "</option>";
            var str3 = "<option value=\"" + FirstValue + "\">" + FirstText3 + "</option>";
            $YearSelector.html(str1);
            $MonthSelector.html(str2);
            $DaySelector.html(str3);

            // 年份列表
            var yearNow = new Date().getFullYear();
            var yearSel = $YearSelector.attr("rel");
            for (var i = yearNow; i >= 1900; i--) {
                var sed = yearSel == i ? "selected" : "";
                var yearStr = "<option value=\"" + i + "\" " + sed + ">" + i + "</option>";
                $YearSelector.append(yearStr);
            }

            // 月份列表
            var monthSel = $MonthSelector.attr("rel");
            for (var i = 1; i <= 12; i++) {
                var sed = monthSel == i ? "selected" : "";
                var monthStr = "<option value=\"" + i + "\" " + sed + ">" + i + "</option>";
                $MonthSelector.append(monthStr);
            }

            // 日列表(僅當選擇了年月)
            function BuildDay() {
                if ($YearSelector.val() == 0 || $MonthSelector.val() == 0) {
                    // 未選擇年份或者月份
                    $DaySelector.html(str3);
                } else {
                    $DaySelector.html(str3);
                    var year = parseInt($YearSelector.val());
                    var month = parseInt($MonthSelector.val());
                    var dayCount = 0;
                    switch (month) {
                        case 1:
                        case 3:
                        case 5:
                        case 7:
                        case 8:
                        case 10:
                        case 12:
                            dayCount = 31;
                            break;
                        case 4:
                        case 6:
                        case 9:
                        case 11:
                            dayCount = 30;
                            break;
                        case 2:
                            dayCount = 28;
                            if ((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0)) {
                                dayCount = 29;
                            }
                            break;
                        default:
                            break;
                    }

                    var daySel = $DaySelector.attr("rel");
                    for (var i = 1; i <= dayCount; i++) {
                        var sed = daySel == i ? "selected" : "";
                        var dayStr = "<option value=\"" + i + "\" " + sed + ">" + i + "</option>";
                        $DaySelector.append(dayStr);
                    }
                }
            }
            $MonthSelector.change(function () {
                BuildDay();
            });
            $YearSelector.change(function () {
                BuildDay();
            });
            if ($DaySelector.attr("rel") != "") {
                BuildDay();
            }
        } // End ms_DatePicker
    });
})(jQuery);
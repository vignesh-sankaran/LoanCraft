//GLOBAL VARS
var URL = window.location.href.toLowerCase();
var CALC_NAME = 'Mortgage';
var CALC_STYLE = '';
var START_BUFFER_RATE = 2; // what interest rate rise to start with when using 'what if interest rates change' option
//var CALC_NAME = 'Personal loan';
var changeCount = 0;

if (URL.indexOf("personal-loan-calculator") !== -1) {
    CALC_NAME = 'Personal loan';
}

if (URL.indexOf('mortgage-calculator') === -1 && CALC_NAME === 'Mortgage') { CALC_STYLE = 'mini'; }


// CALC_STYLE = ''; //TEMP FOR LOCAL
if (CALC_STYLE === 'mini') {
    document.getElementById("content").classList.add("interest-rate-only");
}

//TODO: Remove below when moving to production. Only used to test Personal loan
//if ( URL.indexOf( CALC_NAME.toLowerCase() ) === -1 ) { CALC_NAME = 'Personal loan'; }  //if 'mortgage' is not in the URL change the name to loan


$(document).ready(function () {

    //Draw calculator
    DrawCalculator();
    checkHashBang(); // check if we need to show a specific calc on load

    // keyboard accessibility
    //$('#calculator-container h4').attr( {'tabindex': '0', 'role': 'button'} );
    $('#calculator-container').on('keydown', '[role="button"]', function (e) { // watch for keyboard clicks on all buttons
        var key = e.which; // 13 = Return, 32 = Space
        if ((key === 13) || (key === 32)) { $(this).click(); }
    });

    // url management
    $(window).on('hashchange', function () { checkHashBang(); });

    function checkHashBang() {
        var hashBang = window.location.hash;
        if (hashBang.substring(0, 1) == "#") { hashBang = hashBang.substring(1, hashBang.length); }
        else { hashBang = ''; }
        if (hashBang) {
            var el = document.getElementById(hashBang);
            if (el !== null) {
                var top = document.getElementById(hashBang).offsetTop;
                var rem = parseFloat(window.getComputedStyle(document.body).getPropertyValue('font-size'));
                var headerHeight = document.querySelector('header').offsetHeight;
                window.scroll(0, (top - headerHeight - 1 * rem));
            }
        }
    }

    //blur on enter key
    $('input').on('keypress', function (e) { if (e.keyCode == 13) { $(this).blur(); } });

    //validate inputs
    //set the min and max loan
    $('#repay-length1, #repay-length1-explore, #length1, #length1-explore').blur(function () {
        if ($(this).val() < 1) { $(this).val(1); }
        if ($(this).val() > 30 && CALC_NAME === 'Mortgage') { $(this).val(30); }
        if ($(this).val() > 15 && CALC_NAME === 'Personal loan') { $(this).val(15); }
    });
    //set a cap of 50% interest rate
    $('#repay-rate1, #repay-rate1-explore, #rate1, #rate1-explore, #howlong-rate1, #howlong-rate1-explore').blur(function () { if ($(this).val() > 50) { $(this).val(50); } });
    //the repayment can't be less than the fees so adjust if its too low
    //$('#payment1').blur(function () { alert( $(this).val() ) });

    $('#calculator-container input[type="text"]').focus(function () { this.select(); $(this).removeClass('empty'); if ($('#repayments input.empty:visible').length == 0) { $('#repayments .label-required').remove(); } if ($('#howlong input.empty:visible').length == 0) { $('#howlong .label-required').remove(); } if ($('#borrow input.empty:visible').length == 0) { $('#borrow .label-required').remove(); } });
    $('#calculator-container input[type="text"]').mouseup(function (e) { e.preventDefault(); });
    $('#calculator-container input[type="text"]').blur(function () {
        if (this.value.length < 1) { this.value = (this.defaultValue); }
        if ($(this).hasClass('dollars')) { $(this).val('$' + formatNumber($(this).val(), 0, 0, true)); }
        if ($(this).hasClass('interest')) { $(this).val(formatNumber($(this).val(), 0, 2, true) + '%'); }
        if ($(this).hasClass('years')) { $(this).val(parseInt($(this).val()) + ' years'); }
    });
    $('input.int').keyup(function () { this.value = this.value.replace(/[^0-9]/g, ''); }); //full numbers only
    $('input.float').keyup(function () { this.value = this.value.replace(/[^0-9\.]/g, ''); }); //decimal numbers

    // Update the interest rate only on the first time the explore open is opened
    var howlongRateSet = true;
    $('#howlong .explore h4').click(function (event) {
        if (howlongRateSet && $('#howlong-rate1').val().length > 0) {
            $('#howlong-rate1-explore').val($('#howlong-rate1').val()).removeClass('empty');
            howlongRateSet = false;
        }
    });

    $(document).on('click', '.whatif', function () { $(this).parents('.tab').find('.explore h4').trigger('click'); });
    $('.explore').on('click', 'h4', function () { $(this).toggleClass('open'); $(this).nextAll('div.more').slideToggle(); $(this).parents('.tab').find('input').first().blur(); });
    $('.explore h4').append('<span class="icon"/>');

    //CALCULATE - had to use multiple selectors because not attaching correctly in <ie10
    $('#repayments').on('change', 'select', function () { CalculateRepayments(this); });
    $('#repayments').on('blur', 'input', function () { CalculateRepayments(this); });
    $('#borrow').on('change', 'select', function () { CalculateBorrowAmount(this); });
    $('#borrow').on('blur', 'input', function () { CalculateBorrowAmount(this); });
    $('#howlong').on('change', 'select', function () { CalculateHowlong(this); });
    $('#howlong').on('blur', 'input', function () { CalculateHowlong(this); });


    $('#repay-btn-lessRate').click(function (event) {
        changeInterestRate(document.getElementById("repay-lbl-intRate"), -.25, parseFloat(document.getElementById("repay-rate1").value));
        CalculateRepayments(this);
    });
    $('#repay-btn-moreRate').click(function (event) {
        changeInterestRate(document.getElementById("repay-lbl-intRate"), .25, parseFloat(document.getElementById("repay-rate1").value));
        CalculateRepayments(this);
    });

    $('#howmuch-btn-lessRate').click(function (event) {
        changeInterestRate(document.getElementById("howmuch-lbl-intRate"), -.25, parseFloat(document.getElementById("rate1").value));
        CalculateBorrowAmount(this);
    });
    $('#howmuch-btn-moreRate').click(function (event) {
        changeInterestRate(document.getElementById("howmuch-lbl-intRate"), .25, parseFloat(document.getElementById("rate1").value));
        CalculateBorrowAmount(this);
    });

    $('#howlong-btn-lessRate').click(function (event) {
        changeInterestRate(document.getElementById("howlong-lbl-intRate"), -.25, parseFloat(document.getElementById("howlong-rate1").value));
        CalculateHowlong(this);
    });
    $('#howlong-btn-moreRate').click(function (event) {
        changeInterestRate(document.getElementById("howlong-lbl-intRate"), .25, parseFloat(document.getElementById("howlong-rate1").value));
        CalculateHowlong(this);
    });

    $('#repay-picker').change(function (event) {
        if ($(this).val() == 'interestRateChange') {
            document.getElementById("repay-container-intrate").classList.remove("hide");
            document.getElementById("repay-container-alternative").classList.add("hide");
        } else if ($(this).val() == 'alternative') {
            document.getElementById("repay-container-intrate").classList.add("hide");
            document.getElementById("repay-container-alternative").classList.remove("hide");
        }
    });

    $('#howmuch-picker').change(function (event) {
        if ($(this).val() == 'interestRateChange') {
            document.getElementById("howmuch-container-intrate").classList.remove("hide");
            document.getElementById("howmuch-container-alternative").classList.add("hide");
        } else if ($(this).val() == 'alternative') {
            document.getElementById("howmuch-container-intrate").classList.add("hide");
            document.getElementById("howmuch-container-alternative").classList.remove("hide");
        }
    });

    $('#howlong-picker').change(function (event) {
        if ($(this).val() == 'interestRateChange') {
            document.getElementById("howlong-container-intrate").classList.remove("hide");
            document.getElementById("howlong-container-alternative").classList.add("hide");
        } else if ($(this).val() == 'alternative') {
            document.getElementById("howlong-container-intrate").classList.add("hide");
            document.getElementById("howlong-container-alternative").classList.remove("hide");
        }
    });

    function changeInterestRate(el, amt, currentAmt) {
        var rate = el.dataset.rate;
        var newRate = Number(rate) + amt;
        if (currentAmt + newRate >= 0) {
            el.dataset.rate = newRate;
            var plusMinus = "&plus;";
            if (newRate < 0) {
                plusMinus = "&minus;"
            }
            el.innerHTML = plusMinus + formatNumber(newRate, 0, 2, true) + '%';
        }

    }



    //if this is the personal loan calculator change some of the defaults
    if (CALC_NAME === 'Personal loan') { $('#repay-length1, #repay-length1-explore, #length1, #length1-explore').val('5 years'); }
    // if this is mortgage calculator add a tip to the borrowing tab
    //if ( CALC_NAME === 'Mortgage' ) { $('#borrow .inline-result').append('<br/><span><strong>Tip:</strong> This is the maximum, but <strong>plan ahead</strong> for interest rate rises (explore scenario below)</span>'); }


    //INTEREST RATE PICKER
    if (CALC_NAME === 'Mortgage') {

        //add in button under each interest rate field
        $('.interest').after('<span class="inline-interest-rate"><br><button>use avg rate (<span class="interest-rate-val"></span>)</button></span>');

        $('.interest-rate-val').html(CalculateInterestRate($('#loan-type').val(), $('#repayment-type').val())); //set on load

        //If 'Average interest rate' fields change
        $('#interest-rate').on('change', '#loan-type, #repayment-type', function () {
            $('.interest-rate-val').html(CalculateInterestRate($('#loan-type').val(), $('#repayment-type').val()));
        });

        //Interest rate button clicked - set textbox and recalculate
        $('.inline-interest-rate button').click(function (event) {
            var val = $(this).find('span').text();
            val.replace("%", "");

            var $input = $(this).parent().parent().find('input');
            $input.val(val);
            $input.removeClass('empty');

            // work out what container button was in to recalculate
            var $rateContainer = $(this).parent().parent().parent().parent();
            if ($rateContainer.hasClass('alternative')) {
                $rateContainer = $rateContainer.parent().parent().parent();
            }
            if ($rateContainer.attr('id') === 'repayments') {
                CalculateRepayments(document.getElementById($input.attr('id')));
            }
            else if ($rateContainer.attr('id') === 'borrow') {
                CalculateBorrowAmount(document.getElementById($input.attr('id')));
            }
            else if ($rateContainer.attr('id') === 'howlong') {
                CalculateHowlong(document.getElementById($input.attr('id')));
            }

            moneysmartjs.trackEvent('Calculator - ' + CALC_NAME + ': ' + $input.parents('p').children('label').html(), 'Interest rate picker - ' + $input.attr('id'), val);
        });

    }


    //ANALYTICS
    $('#calculator-container').on('change', 'select', function (event) {
        moneysmartjs.trackEvent('Calculator - ' + CALC_NAME + CALC_STYLE + ': ' + $(this).parents('p').children('label').html(), 'Select - ' + this.id, $(this).children("option:selected").text());
    });
    $('#calculator-container').on('blur', 'input', function (event) {
        moneysmartjs.trackEvent('Calculator - ' + CALC_NAME + CALC_STYLE + ': ' + $(this).parents('p').children('label').html(), 'Input - ' + this.id, $(this).val());
    });

    $('#calculator-container').on('click', 'button', function (event) {
        // track up/down interest rate buttons
        if ($(this).parent().hasClass('container-rate-change')) {
            moneysmartjs.trackEvent('Calculator - ' + CALC_NAME + CALC_STYLE + ': ' + $(this).attr('title'), 'Click - ' + this.id, $(this).parents('span').children('span:first').text());
        }
    });

});

/**
 * @return {string}
 */
function CalculateInterestRate(loanType, repaymentType) {
    if (loanType === "owner-occupier" && repaymentType === "interest-only") {
        return rateData.ownerOccupied_InterestOnly + "%";
    }
    else if (loanType === "owner-occupier" && repaymentType === "principal-and-interest") {
        return rateData.ownerOccupied_PrincipalAndInterest + "%";
    }
    else if (loanType === "investment" && repaymentType === "interest-only") {
        return rateData.investment_InterestOnly + "%";
    }
    else if (loanType === "investment" && repaymentType === "principal-and-interest") {
        return rateData.investment_PrincipalAndInterest + "%";
    }
    else {
        return "";
    }
}

function DrawCalculator() { // CALCULATOR HTML
    var html = '<div class="calc-container" id="interest-rate"></div><div class="calc-container" id="repayments"></div><div class="calc-container" id="borrow"></div><div class="calc-container" id="howlong"></div>';
    $("#calculator-container").html(html);

    // Interest rate helper if Mortgage
    if (CALC_NAME == "Mortgage") {
        html = '<h2><span>Average interest rate</span></h2>' +
            '<div class="flex input">' +
            '<p>Choose your loan and repayment types to see the average interest rate for new home loans in ' + rateData.lastUpdated + ' (Reserve Bank of Australia). Interest rates are rising, so the average rate may now be higher.</p>' +
            '<p><label for="loan-type">Loan type</label><select id="loan-type"><option selected="selected" value="owner-occupier">Owner occupier</option><option value="investment">Investment</option></select></p>' +
            '<p><label for="repayment-type">Repayment type</label><select id="repayment-type"><option selected="selected" value="principal-and-interest">Principal and interest</option><option value="interest-only">Interest only</option></select></p>' +
            '<p class="interest-value-container"><label>Average interest rate ' + rateData.lastUpdated + '</label><span class="interest-rate-val"></span></p>' +
            '</div>';
        $("#interest-rate").html(html);
    }
    // How much will my repayments be?
    html = '<h2>How much will my ' + CALC_NAME.toLowerCase() + ' repayments be?</h2>' +
        '<div class="flex input">' +
        '<p class="label-required">required field</p>' +
        '<h3 class="col100">' + CALC_NAME + ' details</h3>' +
        '<p><label for="repay-amount1">Amount borrowed:</label><input type="text" inputmode="numeric" id="repay-amount1" class="dollars int empty"/></p>' +
        '<p><label for="repay-rate1">Interest rate:</label><input type="text" inputmode="decimal" id="repay-rate1" class="interest float empty"/></p>' +
        '<p><label for="repay-freq1">Repayment frequency:</label><select class="frequency-select" id="repay-freq1"></select></p>' +
        '<p><label for="repay-length1">Length of loan:</label><input type="text" inputmode="numeric" id="repay-length1" value="25 years" class="years int"/></p>' +
        '<p><label for="repay-fee1">Fees:</label><input type="text" inputmode="numeric" id="repay-fee1" value="$10" class="dollars int"/></p>' +
        '<p><label for="repay-feefreq1">Fees frequency:</label><select class="frequency-select" id="repay-feefreq1"></select></p>' +
        '<div class="result col100">' +
        '<p class="inline-result col100 highlight-container">Your repayments will be: <span></span></p>' +
        '<h3 class="col100">Total repayments <button class="tooltip"><span class="tooltiptext">The total amount you will pay your lender over the length of the loan.</span></button></h3>' +
        '<div class="chart result-box col100"></div>';
    // How much will my repayments be? Explore
    html = html + '<div class="alternative col100">' +
        '<h4 class="col100"><select id="repay-picker" class="whatifPicker"><option value="interestRateChange">&nbsp;What if interest rates change</option><option value="alternative">&nbsp;Compare alternative loan</option></select></h4>' +
        '<div id="repay-container-intrate" class="alternative-fields">' +
        '<p style="padding-left: 0"><span class="lbl-highlight">Interest rates change by<span class="container-rate-change"><button title="Decrease interest rate" class="btn-square btn-icon-down" id="repay-btn-lessRate"><span class="no-opacity">&darr;</span></button><span data-rate="' + START_BUFFER_RATE + '" id="repay-lbl-intRate" class="rate-change-value">&plus;' + formatNumber(START_BUFFER_RATE, 0, 2, true) + '%</span><button title="Increase interest rate" class="btn-square btn-icon-up" id="repay-btn-moreRate"><span class="no-opacity">&uarr;</span></button></span></p>' +
        '<div class="container-interest-results">' +
        '<p class="mid-col"><span>New interest rate</span><span id="repay-lbl-newIntRate"></span></p>' +
        '<p class="mid-col"><span>Your new repayments</span><span id="repay-lbl-newRepayment"></span></p>' +
        '<p class="large-col"><span id="repay-lbl-resultDesc">Your repayments will cost an extra</span><span id="repay-lbl-intRateDiff"></span></p>' +
        '</div>' +
        '</div>' +
        '<div id="repay-container-alternative" class="alternative-fields hide">' +
        '<p><label for="repay-rate1-explore">Interest rate:</label><input type="text" inputmode="decimal" id="repay-rate1-explore" class="small interest float empty"/></p>' +
        '<p><label for="repay-amount1-explore">Amount borrowed:</label><input type="text" inputmode="numeric" id="repay-amount1-explore" class="small dollars int empty"/></p>' +
        '<p class="explore-select"><label for="repay-freq1-explore">Repayment frequency:</label><select class="frequency-select" id="repay-freq1-explore"></select></p>' +
        '<p><label for="repay-length1-explore">Length of loan:</label><input type="text" inputmode="numeric" id="repay-length1-explore" value="25 years" class="small years int"/></p>' +
        '</div></div></div>';
    $("#repayments").html(html);


    // How much can I borrow?
    html = '<h2>How much can I borrow?</h2>' +
        '<div class="flex input">' +
        '<p class="label-required">required field</p>' +
        '<h3 class="col100">' + CALC_NAME + ' details</h3>' +
        '<p><label for="payment1">Affordable repayment:</label><input type="text" inputmode="numeric" id="payment1" class="dollars int empty"/></p>' +
        '<p><label for="freq1">Repayment frequency:</label><select class="frequency-select" id="freq1"></select></p>' +
        '<p><label for="rate1">Interest rate:</label><input type="text" inputmode="decimal" id="rate1" class="interest float empty"/> </p>' +
        '<p><label for="length1">Length of loan:</label><input type="text" inputmode="numeric" id="length1" value="25 years" class="years int"/></p>' +
        '<p><label for="fee1">Fees:</label><input type="text" inputmode="numeric" id="fee1" value="$10" class="dollars int"/></p>' +
        '<p><label for="feefreq1">Fees frequency:</label><select class="frequency-select" id="feefreq1"></select></p>' +
        '<div class="result col100">' +
        '<p class="inline-result col100 highlight-container">You can borrow: <span></span></p>' +
        '<h3 class="col100">Total repayments <button class="tooltip"><span class="tooltiptext">The total amount you will pay your lender over the length of the loan.</span></button></h3>' +
        '<div class="chart result-box col100"></div>';
    // How much can I borrow? Explore
    html = html + '<div class="alternative col100">' +
        '<h4 class="col100"><select id="howmuch-picker" class="whatifPicker"><option value="interestRateChange">&nbsp;What if interest rates change</option><option value="alternative">&nbsp;Compare alternative loan</option></select></h4>' +
        '<div id="howmuch-container-intrate" class="alternative-fields">' +
        '<p style="padding-left: 0"><span class="lbl-highlight">Interest rates change by<span class="container-rate-change"><button title="Decrease interest rate" class="btn-square btn-icon-down" id="howmuch-btn-lessRate"><span class="no-opacity">&darr;</span></button><span data-rate="' + START_BUFFER_RATE + '" id="howmuch-lbl-intRate" class="rate-change-value">&plus;' + formatNumber(START_BUFFER_RATE, 0, 2, true) + '%</span><button title="Increase interest rate" class="btn-square btn-icon-up" id="howmuch-btn-moreRate"><span class="no-opacity">&uarr;</span></button></span></p>' +
        '<div class="container-interest-results">' +
        '<p class="mid-col"><span>New interest rate</span><span id="howmuch-lbl-newIntRate"></span></p>' +
        '<p class="mid-col"><span>Your new borrowing amount</span><span id="howmuch-lbl-newBorrowing"></span></p>' +
        '<p class="large-col"><span>You can borrow</span><span class="bigger-text" id="repay-lbl-borrowingDiff"></span></p>' +
        '</div>' +
        '</div>' +
        '<div id="howmuch-container-alternative" class="alternative-fields hide">' +
        '<p><label for="rate1-explore">Interest rate:</label><input type="text" inputmode="decimal" id="rate1-explore" class="small interest float empty"/> </p>' +
        '<p><label for="payment1-explore">Affordable repayment:</label><input type="text" inputmode="numeric" id="payment1-explore" class="small dollars int empty"/><select class="frequency-select" id="freq1-explore"></select></p>' +
        '<p><label for="length1-explore">Length of loan:</label><input type="text" inputmode="numeric" id="length1-explore" value="25 years" class="small years int"/></p>' +
        '</div></div></div></div>';
    $("#borrow").html(html);


    // How can I repay my loan sooner?
    html = '<h2>How can I repay my loan sooner?</h2>' +
        '<div class="flex input">' +
        '<p class="label-required">required field</p>' +
        '<h3 class="col100">Current ' + CALC_NAME.toLowerCase() + '</h3>' +
        '<p><label for="howlong-amount1">Amount owing:</label><input type="text" inputmode="numeric" id="howlong-amount1" class="dollars int empty"/></p>' +
        '<p><label for="howlong-payment1">Repayment:</label><input type="text" inputmode="numeric" id="howlong-payment1" class="dollars int empty"/></p>' +
        '<p><label for="howlong-payment1">Repayment frequency:</label><select class="frequency-select" id="howlong-freq1"></select></p>' +
        '<p><label for="howlong-rate1">Interest rate:</label><input type="text" inputmode="decimal" id="howlong-rate1" class="interest float empty"/></p>' +
        '<p><label for="howlong-fee1">Fees:</label><input type="text" inputmode="numeric" id="howlong-fee1" value="$10" class="dollars int"/></p>' +
        '<p><label for="howlong-feefreq1">Fees frequency:</label><select class="frequency-select" id="howlong-feefreq1"></select></p>' +
        '<div class="result col100">' +
        '<p class="inline-result col100 highlight-container">Time to repay: <span></span></p>' +
        '<h3 class="col100">Total repayments <button class="tooltip"><span class="tooltiptext">The total amount you will pay your lender over the length of the loan.</span></button></h3>' +
        '<div class="chart result-box col100"></div>';
    // How can I repay my loan sooner? Explore
    html = html + '<div class="alternative col100">' +
        '<h4 class="col100"><select id="howlong-picker" class="whatifPicker"><option value="interestRateChange">&nbsp;What if interest rates change</option><option value="alternative">&nbsp;Compare alternative loan</option></select></h4>' +
        '<div id="howlong-container-intrate" class="alternative-fields">' +
        '<p style="padding-left: 0"><span class="lbl-highlight">Interest rates change by<span class="container-rate-change"><button title="Decrease interest rate" class="btn-square btn-icon-down" id="howlong-btn-lessRate"><span class="no-opacity">&darr;</span></button><span data-rate="' + START_BUFFER_RATE + '" id="howlong-lbl-intRate" class="rate-change-value">&plus;' + formatNumber(START_BUFFER_RATE, 0, 2, true) + '%</span><button title="Increase interest rate" class="btn-square btn-icon-up" id="howlong-btn-moreRate"><span class="no-opacity">&uarr;</span></button></span></p>' +
        '<div class="container-interest-results">' +
        '<p class="mid-col"><span>New interest rate</span><span id="howlong-lbl-newIntRate"></span></p>' +
        '<p class="large-col"><span>Your new repayment time</span><span id="howlong-lbl-newTime"></span></p>' +
        '<p class="mid-col"><span>You can repay</span><span class="bigger-text" id="howlong-lbl-timeDiff"></span></p>' +
        '</div>' +
        '</div>' +
        '<div id="howlong-container-alternative" class="alternative-fields hide">' +
        '<p><label for="howlong-rate1-explore">Interest rate:</label><input type="text" inputmode="decimal" id="howlong-rate1-explore" class="interest float empty"/></p>' +
        '<p><label for="howlong-payment1-explore">Repayment:</label><input type="text" inputmode="numeric" id="howlong-payment1-explore" class="dollars int empty"/><select class="frequency-select" id="howlong-freq1-explore"></select></p>' +
        '</div></div></div></div>';
    $("#howlong").html(html);

    // add the frequency options to the select boxes
    html = '<option value="1">Yearly</option><option value="4">Quarterly</option>' +
        '<option value="12" selected="selected">Monthly</option>' +
        '<option value="26">Fortnightly</option><option value="52">Weekly</option>';
    $('#calculator-container .frequency-select').html(html);
    $('.tab > div').hide();
}


//global vars
var borrowChart;
var repaymentsChart;
var howlongChart;
repayExplore = true;
borrowExplore = true;

function CalculateRepayments(lastEl) {
    if ($('#repayments input:visible.empty').length > 0 && $('#repayments .result').css("display") == "none") { return false; }

    var labelCollection = [];
    var interestCollection = [];
    var principalCollection = [];

    //actual
    var rate = parseFloat($("#repay-rate1").val().replace(/[^0-9\.]/g, '')); //interest rate (entered p.a. so we need to convert per period)
    var per = parseInt($("#repay-freq1").val());  //number of periods (eg. 12 = 1 year)
    var years = parseInt($("#repay-length1").val().replace(/[^0-9]/g, ''));

    if (years < 1) { years = 1; }
    if (years > 30 && CALC_NAME === 'Mortgage') { years = 30 }
    if (years > 15 && CALC_NAME === 'Personal loan') { years = 15; }

    var nper = years * per; //total number of payment periods (eg. 20 years * 12 months = 240)
    var pv = parseFloat($("#repay-amount1").val().replace(/[^0-9\.]/g, ''));  //payment made each period (enter as negative)
    var fee = parseFloat($("#repay-fee1").val().replace(/[^0-9\.]/g, ''));
    var feeFreq = parseInt($("#repay-feefreq1").val());
    var fv = 0;  //future value
    var fees = parseFloat((fee * feeFreq) / (per)); // fee per repayment period
    var pmt = parseFloat(PMT((rate / 100) / per, years * per, -pv, fv, 0)) + fees; //payment made each period
    var result = pmt * per * years;
    var principal = pv;
    var interest = result - principal;
    labelCollection.push('<span class="mc-label-heading">' + CALC_NAME + ' details</span><br><span class="mc-label">Repay </span><span class="mc-label" style="font-weight:bold">$' + formatNumber(pmt, 0, 0, true) + '</span><span class="mc-label">' + freqString(per) + '<br/>' + rate + '% for ' + years + ' years</span>');
    $("#repayments .inline-result span").html('<span class="enlarge-text">$' + formatNumber(pmt, 0, 0, true) + '</span>' + freqString(per));

    // blank out the what if results, if amount borrowed is zero
    if (pv === 0 || isNaN(pv) || isNaN(rate)) { labelCollection[labelCollection.length - 1] = ''; principal = 0; interest = 0; }
    interestCollection.push(interest);
    principalCollection.push(principal);


    //explore scenario
    var rate1Val;
    var per1Val;
    var years1Val;
    var amount1Val;

    if ($("#repay-picker").val() == 'interestRateChange') {
        // keep 'What if interest rates change' synced with the loan details
        var bufferVal = rate + Number(document.getElementById("repay-lbl-intRate").dataset.rate);
        if (bufferVal < 0) {
            // don't let rate go negative, reset to original buffer
            document.getElementById("repay-lbl-intRate").dataset.rate = START_BUFFER_RATE;
            document.getElementById("repay-lbl-intRate").innerHTML = '&plus;' + formatNumber(START_BUFFER_RATE, 0, 2, true) + '%';
            bufferVal = rate + Number(document.getElementById("repay-lbl-intRate").dataset.rate);
        }

        rate1Val = formatNumber(bufferVal, 0, 2, true) + '%';
        amount1Val = $("#repay-amount1").val();
        per1Val = $("#repay-freq1").val();
        years1Val = $("#repay-length1").val();
    } else {
        rate1Val = $("#repay-rate1-explore").val();
        per1Val = $("#repay-freq1-explore").val();
        years1Val = $("#repay-length1-explore").val();
        amount1Val = $("#repay-amount1-explore").val();
    }

    var bufferChange = Number(document.getElementById("repay-lbl-intRate").dataset.rate);
    var rate1 = parseFloat(rate1Val.replace(/[^0-9\.]/g, '')); //interest rate (entered p.a. so we need to convert per period)
    var per1 = parseInt(per1Val);  //number of periods (eg. 12 = 1 year)
    var years1 = parseInt(years1Val.replace(/[^0-9]/g, ''));
    if (years1 < 1) {
        years1 = 1;
    }
    if (years1 > 30 && CALC_NAME === 'Mortgage') {
        years1 = 30
    }
    if (years1 > 15 && CALC_NAME === 'Personal loan') {
        years1 = 15;
    }
    var nper1 = years1 * per1; //total number of payment periods (eg. 20 years * 12 months = 240)
    var pv1 = parseFloat(amount1Val.replace(/[^0-9\.]/g, ''));  //payment made each period (enter as negative)
    var fees1 = parseFloat((fee * feeFreq) / (per1)); // fee per repayment period
    if (pv1 === 0) {
        fees1 = 0;
    }
    var pmt1 = parseFloat(PMT((rate1 / 100) / per1, years1 * per1, -pv1, fv, 0)) + fees1; //payment made each period
    var result1 = pmt1 * per1 * years1;
    var principal1 = pv1;
    var interest1 = result1 - principal1;
    var labelHeading = 'Alternative';
    if ($("#repay-picker").val() == 'interestRateChange') {
        labelHeading = 'If interest rate goes ' + (bufferChange < 0 ? 'down' : 'up') + ' by ' + formatNumber(bufferChange, 0, 2, true) + '%';
    } else if ($("#repay-picker").val() == 'alternative') {
        labelHeading = 'Alternative';
    }
    labelCollection.push('<span class="mc-label-heading">' + labelHeading + '</span><br /><span class="mc-label">Repay </span><span class="mc-label" style="font-weight:bold">$' + formatNumber(pmt1, 0, 0, true) + '</span><span class="mc-label">' + freqString(per1) + '</span><br/><span class="mc-label">' + rate1 + '% for ' + years1 + ' years</span>');

    var newpmt = pmt;
    if (per != per1) {
        // make frequency match for comparison
        newpmt = parseFloat(PMT((rate / 100) / per1, years * per1, -pv, fv, 0)) + fees; //payment made each period
    }
    var diff = newpmt - pmt1;

    // don't show alternative graph if no value entered or is 0
    if (pv1 === 0 || isNaN(pv1) || isNaN(rate1)) {
        labelCollection[labelCollection.length - 1] = '<span style="color:#333;"></span>';
        principal1 = 10; // set to 10 so it displays on safari
        interest1 = 0;
    }

    interestCollection.push(interest1);
    principalCollection.push(principal1);

    var principalData = [];
    var interestData = [];
    var interestColours = ['#A6BEFC', '#e1f8fe'];
    var principalColours = ['#0146F5', '#210c4b'];

    for (var i = 0; i < interestCollection.length; i++) {
        interestData.push({ y: interestCollection[i], color: interestColours[i] })
    }
    for (var i = 0; i < principalCollection.length; i++) {
        principalData.push({ y: principalCollection[i], color: principalColours[i] })
    }

    if (bufferChange < 0) {
        document.getElementById("repay-lbl-resultDesc").innerHTML = 'Your repayments will reduce by';
    } else {
        document.getElementById("repay-lbl-resultDesc").innerHTML = 'Your repayments will cost an extra';
    }

    document.getElementById("repay-lbl-newIntRate").innerHTML = '<span class="enlarge-text">' + formatNumber(rate1, 0, 2, true) + '</span>%';
    document.getElementById("repay-lbl-newRepayment").innerHTML = '<span class="enlarge-text">' + '$' + formatNumber(pmt1, 0, 0, true) + '</span> ' + freqString(per1);
    document.getElementById("repay-lbl-intRateDiff").innerHTML = '<span class="enlarge-text">' + '$' + formatNumber(diff, 0, 0, true) + '</span> ' + freqString(per1);


    //chart
    if (repaymentsChart === undefined) {  //we need to create the chart on first use

        var html = '<div id="repayments-chart1" style="height: 315px; margin: 0 auto;"></div>';
        $("#repayments .chart").html(html);
        repaymentsChart = new Highcharts.Chart({
            chart: { renderTo: 'repayments-chart1', type: 'column', marginBottom: 90, marginTop: 30 },
            colors: ['#ACE8FA', '#0047F5'],
            credits: { enabled: false },
            title: { text: null },
            xAxis: { categories: labelCollection, labels: { y: 30, style: { fontFamily: '\'Montserrat\', sans-serif', fontSize: '15px', color: '#333' } } },
            yAxis: {
                min: 0, title: { text: null },
                stackLabels: {
                    enabled: true,
                    style: {
                        fontWeight: 'bold',
                        fontFamily: '\'Montserrat\', sans-serif',
                        fontSize: '15px',
                        color: '#333',
                        align: 'center',
                        textOutline: "0px",
                    },
                    formatter: function () {
                        if (this.total > 10 || this.x == 0) {
                            return '$' + formatNumber(this.total, 0, 0, true);
                        } else {
                            return '<span class="mc-comparison-label" style="color:#0047F5;">Add comparison below</span>';
                        }
                    }
                },
                labels: { style: { fontFamily: '\'Montserrat\', sans-serif', color: '#333' } }
            },
            legend: { backgroundColor: '#FFFFFF', reversed: true, enabled: false },
            tooltip: { formatter: function () { return this.series.name + ': $' + formatNumber(this.y, 0, 0, true); } },
            plotOptions: { series: { stacking: 'normal' } },
            series: [{
                name: 'Interest (including fees)',
                data: interestData
            }, {
                name: 'Principal',
                data: principalData
            }]
        });

    }

    else {

        repaymentsChart.xAxis[0].setCategories(labelCollection);
        for (var i = 0; i < interestCollection.length; i++) {
            repaymentsChart.series[0].data[i].update(interestCollection[i]);
        }
        for (var i = 0; i < principalCollection.length; i++) {
            repaymentsChart.series[1].data[i].update(principalCollection[i]);
        }

    }

    $("#repayments .result").css('display', 'flex');
    if (CALC_NAME === 'Personal loan') {
        dataLayer.push({ event: 'calculatorCompleted', personalLoanData: serializeData(document.getElementById('calculator-container'), 'A', lastEl) });
    } else {
        dataLayer.push({ event: 'calculatorCompleted', mortgageCalcData: serializeData(document.getElementById('calculator-container'), 'A', lastEl) });
    }

}


function CalculateBorrowAmount(lastEl) {

    if ($('#borrow input:visible.empty').length > 0 && $('#borrow .result').css("display") == "none") { return false; }

    var labelCollection = [];
    var interestCollection = [];
    var principalCollection = [];

    var type = 0; // used for PV function
    //actual
    var rate = parseFloat($("#rate1").val().replace(/[^0-9\.]/g, '')); //interest rate (entered p.a. so we need to convert per period)
    var per = parseInt($("#freq1").val());  //number of periods (eg. 12 = 1 year)
    var years = parseInt($("#length1").val().replace(/[^0-9]/g, ''));
    if (years < 1) { years = 1; }
    if (years > 30 && CALC_NAME === 'Mortgage') { years = 30 }
    if (years > 15 && CALC_NAME === 'Personal loan') { years = 15; }
    var nper = years * per; //total number of payment periods (eg. 20 years * 12 months = 240)
    var pmt = parseFloat($("#payment1").val().replace(/[^0-9\.]/g, ''));  //payment made each period
    var fee = parseFloat($("#fee1").val().replace(/[^0-9\.]/g, ''));
    var feeFreq = parseInt($("#feefreq1").val());
    var fv = 0;  //future value
    var fees = (fee * feeFreq * years);
    var interest = (pmt * per * years) + fees; //interest including fees
    var label;

    //calculate actual
    var principal = PV((rate / 100) / per, nper, -pmt + ((fee * feeFreq) / per), fv, type);
    interest = interest - principal;

    if (principal <= 0) {
        interest = 0; principal = 0;
        $("#borrow .inline-result span:first").html('<span class="enlarge-text">N/A</span>');
        //label = '<span style="color:#D84847">Repayment won\'t cover interest and fees</span>';
        labelCollection.push('<span class="mc-label-heading">Repayment won\'t cover interest and fees</span>');
    }
    else {
        $("#borrow .inline-result span:first").html('<span class="enlarge-text">$' + formatNumber(principal, 0, 0, true) + '</span>');
        //label = '<span style="font-weight:bold;color:#333;font-size:1rem;">' + CALC_NAME + ' details</span><br><span style="color:#333;">Borrow </span><span style="color:#333;font-weight:bold;">$'+formatNumber(principal, 0, 0, true)+'</span><br/>'+rate+'% for '+years+' years';
        labelCollection.push('<span class="mc-label-heading">' + CALC_NAME + ' details</span><br><span class="mc-label">Borrow </span><span class="mc-label" style="font-weight:bold">$' + formatNumber(principal, 0, 0, true) + '</span><br/><span class="mc-label">' + rate + '% for ' + years + ' years</span>');
    }



    // blank out the what if results, if amount borrowed is zero
    if (pmt === 0 || isNaN(pmt) || isNaN(rate)) { labelCollection[labelCollection.length - 1] = ''; principal = 0; interest = 0; }
    interestCollection.push(interest);
    principalCollection.push(principal);

    //explore scenario
    var rate1Val;
    var per1Val;
    var years1Val;
    var payment1Val;

    if ($("#howmuch-picker").val() == 'interestRateChange') {
        // keep 'What if interest rates change' synced with the loan details
        var bufferVal = rate + Number(document.getElementById("howmuch-lbl-intRate").dataset.rate);
        if (bufferVal < 0) {
            // don't let rate go negative, reset to original buffer
            document.getElementById("howmuch-lbl-intRate").dataset.rate = START_BUFFER_RATE;
            document.getElementById("howmuch-lbl-intRate").innerHTML = '&plus;' + formatNumber(START_BUFFER_RATE, 0, 2, true) + '%';
            bufferVal = rate + Number(document.getElementById("howmuch-lbl-intRate").dataset.rate);
        }
        rate1Val = formatNumber(bufferVal, 0, 2, true) + '%';
        payment1Val = $("#payment1").val();
        per1Val = $("#freq1").val();
        years1Val = $("#length1").val();
    } else {
        rate1Val = $("#rate1-explore").val();
        per1Val = $("#freq1-explore").val();
        years1Val = $("#length1-explore").val();
        payment1Val = $("#payment1-explore").val();
    }

    var bufferChange = Number(document.getElementById("howmuch-lbl-intRate").dataset.rate);

    /*
    if ( borrowChart === undefined && CALC_NAME === 'Mortgage' ) {
        // on first calculation prefill scenario to show the buffer interest rate, all other fields copied over
        var bufferVal = rate + START_BUFFER_RATE;
        $("#rate1-explore").val(formatNumber(bufferVal, 0, 2, true) + '%');
        $("#payment1-explore").val($("#payment1").val());
        $("#freq1-explore").val($("#freq1").val());
        $("#length1-explore").val($("#length1").val());

        document.getElementById("rate1-explore").classList.remove("empty");
        document.getElementById("payment1-explore").classList.remove("empty");
    }
    */

    var rate1 = parseFloat(rate1Val.replace(/[^0-9\.]/g, '')); //interest rate (entered p.a. so we need to convert per period)
    var per1 = parseInt(per1Val);  //number of periods (eg. 12 = 1 year)
    var years1 = parseInt(years1Val.replace(/[^0-9]/g, ''));
    if (years1 < 1) { years1 = 1; }
    if (years1 > 30 && CALC_NAME === 'Mortgage') { years1 = 30 }
    if (years1 > 15 && CALC_NAME === 'Personal loan') { years1 = 15; }
    var nper1 = years1 * per1; //total number of payment periods (eg. 20 years * 12 months = 240)
    var pmt1 = parseFloat(payment1Val.replace(/[^0-9\.]/g, ''));  //payment made each period
    var interest1 = (pmt1 * per1 * years1) + fees;
    var label1;

    //calculate explore scenario
    var principal1 = PV((rate1 / 100) / per1, nper1, -pmt1 + ((fee * feeFreq) / per1), fv, type);
    interest1 = interest1 - principal1;

    var labelHeading = 'Alternative';
    if ($("#howmuch-picker").val() == 'interestRateChange') {
        labelHeading = 'If interest rate goes ' + (bufferChange < 0 ? 'down' : 'up') + ' by ' + formatNumber(bufferChange, 0, 2, true) + '%';
    } else if ($("#howmuch-picker").val() == 'alternative') {
        labelHeading = 'Alternative';
    }

    if (principal1 <= 0) {
        interest1 = 0; principal1 = 0;
        labelCollection.push('<span class="mc-label-heading">Repayment won\'t cover interest and fees </span>');
        //label1 = '<span style="color:#D84847">Repayment won\'t cover interest and fees</span>';
    }
    else {
        labelCollection.push('<span class="mc-label-heading">' + labelHeading + '</span><br /><span class="mc-label">Borrow </span><span class="mc-label" style="font-weight:bold">$' + formatNumber(principal1, 0, 0, true) + '</span><br/><span class="mc-label">' + rate1 + '% for ' + years1 + ' years</span>');
        //label1 = '<span style="font-weight:bold;color:#333;font-size:1rem;">Alternative</span><br><span style="color:#333;">Borrow </span><span style="font-weight:bold;">$'+formatNumber(principal1, 0, 0, true)+'</span><br/>'+rate1+'% for '+years1+' years';
    }

    var diff = principal - principal1;

    // don't show alternative graph if no value entered or is 0
    if (pmt1 === 0 || isNaN(pmt1) || isNaN(rate1)) {
        labelCollection[labelCollection.length - 1] = '<span style="color:#333;"></span>';
        principal1 = 0;
        interest1 = 0;
    }

    interestCollection.push(interest1);
    principalCollection.push(principal1);

    var principalData = [];
    var interestData = [];
    var interestColours = ['#A6BEFC', '#e1f8fe'];
    var principalColours = ['#0146F5', '#210c4b'];

    for (var i = 0; i < interestCollection.length; i++) {
        interestData.push({ y: interestCollection[i], color: interestColours[i] })
    }
    for (var i = 0; i < principalCollection.length; i++) {
        principalData.push({ y: principalCollection[i], color: principalColours[i] })
    }

    var diffHeading = 'less';
    if (bufferChange < 0) {
        diffHeading = 'more';
    }

    document.getElementById("howmuch-lbl-newIntRate").innerHTML = '<span class="enlarge-text">' + formatNumber(rate1, 0, 2, true) + '</span>%';
    document.getElementById("howmuch-lbl-newBorrowing").innerHTML = '<span class="enlarge-text">' + '$' + formatNumber(principal1, 0, 0, true) + '</span>';
    document.getElementById("repay-lbl-borrowingDiff").innerHTML = '<span class="enlarge-text">' + '$' + formatNumber(diff, 0, 0, true) + '</span> ' + diffHeading;


    //chart
    if (borrowChart === undefined) {  //we need to create the chart on first use

        var html = '<div id="chart1" style="height: 315px; margin: 0 auto;"></div>';
        $("#borrow .chart").html(html);

        borrowChart = new Highcharts.Chart({
            chart: { renderTo: 'chart1', type: 'column', marginBottom: 90, marginTop: 30 },
            colors: ['#ACE8FA', '#0047F5'],
            credits: { enabled: false },
            title: { text: null },
            xAxis: { categories: labelCollection, labels: { y: 30, style: { fontFamily: '\'Montserrat\', sans-serif', fontSize: '15px', color: '#333' } } },
            yAxis: {
                min: 0, title: { text: null },
                stackLabels: {
                    enabled: true,
                    style: {
                        fontWeight: 'bold',
                        fontFamily: '\'Montserrat\', sans-serif',
                        fontSize: '15px',
                        color: '#333',
                        align: 'center',
                        textOutline: "0px",
                    },
                    formatter: function () {
                        // don't display 'Add comparison below' if they've entered an invalid comparison
                        var invalidComparison = false;
                        var xValue = this.x,
                            xAxis = this.axis.chart.xAxis[0];
                        if (xAxis.categories[xValue] == '<span class="mc-label-heading">Repayment won\'t cover interest and fees</span>') {
                            invalidComparison = true;
                        }

                        if ((this.total > 10 || this.x == 0) || this.x == 1 && invalidComparison == true) {
                            return '$' + formatNumber(this.total, 0, 0, true);
                        } else {
                            return '<span class="mc-comparison-label" style="color:#0047F5;">Add comparison below</span>';
                        }
                    }
                },
                labels: { style: { fontFamily: '\'Montserrat\', sans-serif', color: '#333' } }
            },
            legend: { backgroundColor: '#FFFFFF', reversed: true, enabled: false },
            tooltip: { formatter: function () { return this.series.name + ': $' + formatNumber(this.y, 0, 0, true); } },
            plotOptions: { series: { stacking: 'normal' } },
            series: [{
                name: 'Interest (including fees)',
                data: interestData
            }, {
                name: 'Principal',
                data: principalData
            }]
        });

    }
    else {
        borrowChart.xAxis[0].setCategories(labelCollection);
        for (var i = 0; i < interestCollection.length; i++) {
            borrowChart.series[0].data[i].update(interestCollection[i]);
        }
        for (var i = 0; i < principalCollection.length; i++) {
            borrowChart.series[1].data[i].update(principalCollection[i]);
        }
    }

    $("#borrow .result").css('display', 'flex');


    if (CALC_NAME === 'Personal loan') {
        dataLayer.push({ event: 'calculatorCompleted', personalLoanData: serializeData(document.getElementById('calculator-container'), 'B', lastEl) });
    } else {
        dataLayer.push({ event: 'calculatorCompleted', mortgageCalcData: serializeData(document.getElementById('calculator-container'), 'B', lastEl) });
    }

}


function CalculateHowlong(lastEl) {
    if ($('#howlong input:visible.empty').length > 0 && $('#howlong .result').css("display") == "none") { return false; }

    var labelCollection = [];
    var interestCollection = [];
    var principalCollection = [];
    var type = 0;  // used for NPER function
    //actual
    var rate = parseFloat($("#howlong-rate1").val().replace(/[^0-9\.]/g, '')); //interest rate (entered p.a. so we need to convert per period)
    var per = parseInt($("#howlong-freq1").val());  //number of periods (eg. 12 = 1 year)
    var pv = parseFloat($("#howlong-amount1").val().replace(/[^0-9\.]/g, ''));
    var fee = parseFloat($("#howlong-fee1").val().replace(/[^0-9\.]/g, ''));
    var feeFreq = parseInt($("#howlong-feefreq1").val());
    var fv = 0;  //future value
    var pmt = parseFloat($("#howlong-payment1").val().replace(/[^0-9\.]/g, ''));  //payment made each period
    var nper = NPER((rate / 100) / per, -pmt + ((fee * feeFreq) / per), pv, fv, type); //fee is being matched to period of repayment, this is not 100% accurate, but result should be very close
    var principal = pv;
    var totalRepayments = pmt * nper;
    var interest = totalRepayments - principal;
    var label = '';
    var labelYears = nper / per;
    var labelMonths = Math.ceil((labelYears % 1) * 12);
    labelYears = parseInt(labelYears);
    if (labelMonths === 12) { labelMonths = 0; labelYears = labelYears + 1; }
    if (labelYears > 0) { label = labelYears + (labelYears == 1 ? ' year ' : ' years '); }
    if (labelMonths > 0) { label = label + labelMonths + (labelMonths == 1 ? ' month' : ' months'); }
    var totalMonths = (labelYears * 12) + labelMonths;
    $("#howlong .inline-result span").html('<span class="enlarge-text">' + label + '</span>');
    if (label.length < 1) {
        label = '<span style="color:#D84847">Repayment won\'t cover interest and fees</span>';
        interest = 0; principal = 0;
        $("#howlong .inline-result span").html('<span class="enlarge-text">N/A</span>');
        labelCollection.push('<span class="mc-label-heading">Repayment won\'t cover interest and fees</span>');
    }
    else {
        //label = '<span style="font-weight:bold;color:#333;font-size:1rem;">' + CALC_NAME + ' details</span><br><span style="font-weight:bold;">' + label + '</span><br/>$'+formatNumber(pmt, 0, 0, true) + freqString(per) + ' at ' + rate+'%';
        labelCollection.push('<span class="mc-label-heading">' + CALC_NAME + ' details</span><br><span class="mc-label">' + label + '</span><br/><span class="mc-label">$' + formatNumber(pmt, 0, 0, true) + freqString(per) + ' at ' + rate + '%</span>');
    }

    // blank out the what if results, if amount borrowed is zero
    if (pmt === 0 || isNaN(pmt) || isNaN(rate) || pv === 0 || isNaN(pv)) { label = ''; principal = 0; interest = 0; $("#howlong .inline-result span").text(""); }
    interestCollection.push(interest);
    principalCollection.push(principal);

    //explore scenario
    var rate1Val;
    var per1Val;
    var years1Val;
    var payment1Val;

    if ($("#howlong-picker").val() == 'interestRateChange') {
        // keep 'What if interest rates change' synced with the loan details
        var bufferVal = rate + Number(document.getElementById("howlong-lbl-intRate").dataset.rate);
        if (bufferVal < 0) {
            // don't let rate go negative, reset to original buffer
            document.getElementById("howlong-lbl-intRate").dataset.rate = START_BUFFER_RATE;
            document.getElementById("howlong-lbl-intRate").innerHTML = '&plus;' + formatNumber(START_BUFFER_RATE, 0, 2, true) + '%';
            bufferVal = rate + Number(document.getElementById("howlong-lbl-intRate").dataset.rate);
        }
        rate1Val = formatNumber(bufferVal, 0, 2, true) + '%';
        payment1Val = $("#howlong-payment1").val();
        per1Val = $("#howlong-freq1").val();
    } else {
        rate1Val = $("#howlong-rate1-explore").val();
        payment1Val = $("#howlong-payment1-explore").val();
        per1Val = $("#howlong-freq1-explore").val();
    }

    var bufferChange = Number(document.getElementById("howlong-lbl-intRate").dataset.rate);

    var rate1 = parseFloat(rate1Val.replace(/[^0-9\.]/g, '')); //interest rate (entered p.a. so we need to convert per period)
    var per1 = parseInt(per1Val);  //number of periods (eg. 12 = 1 year)
    var pv1 = pv; // parseFloat( $("#howlong-amount1-explore").val().replace(/[^0-9\.]/g,'') );
    var pmt1 = parseFloat(payment1Val.replace(/[^0-9\.]/g, ''));  //payment made each period
    var nper1 = NPER((rate1 / 100) / per1, -pmt1 + ((fee * feeFreq) / per1), pv1, fv, type); //fee is being matched to period of repayment, this is not 100% accurate, but result should be very close
    var principal1 = pv1;
    var totalRepayments1 = pmt1 * nper1;
    var interest1 = totalRepayments1 - principal1;
    var label1 = '';
    var labelYears1 = nper1 / per1;
    var labelMonths1 = Math.ceil((labelYears1 % 1) * 12);
    labelYears1 = parseInt(labelYears1);
    if (labelMonths1 === 12) { labelMonths1 = 0; labelYears1 = labelYears1 + 1; }
    if (labelYears1 > 0) { label1 = labelYears1 + (labelYears1 == 1 ? ' year ' : ' years '); }
    if (labelMonths1 > 0) { label1 = label1 + labelMonths1 + (labelMonths1 == 1 ? ' month' : ' months'); }
    var totalMonths1 = (labelYears1 * 12) + labelMonths1;

    var labelHeading = 'Alternative';
    if ($("#howlong-picker").val() == 'interestRateChange') {
        labelHeading = 'If interest rate goes ' + (bufferChange < 0 ? 'down' : 'up') + ' by ' + formatNumber(bufferChange, 0, 2, true) + '%';
    } else if ($("#howlong-picker").val() == 'alternative') {
        labelHeading = 'Alternative';
    }

    if (label1.length < 1) {
        //label1 = '<span style="color:#D84847">Repayment won\'t cover interest and fees</span>';
        interest1 = 0;
        principal1 = 0;
        labelCollection.push('<span class="mc-label-heading">Repayment won\'t cover interest and fees</span>');
    } else {
        //label1 = '<span style="font-weight:bold;color:#333;font-size:1rem;">Alternative</span><br><span style="font-weight:bold;">' + label1 + '</span><br/>$'+formatNumber(pmt1, 0, 0, true) + freqString(per1) + ' at ' + rate1+'%';
        labelCollection.push('<span class="mc-label-heading">' + labelHeading + '</span><br><span class="mc-label">' + label1 + '</span><br/><span class="mc-label">$' + formatNumber(pmt1, 0, 0, true) + freqString(per1) + ' at ' + rate1 + '%</span>');
    }

    var diff = '';
    if (bufferChange < 0) {
        diff = (totalMonths - totalMonths1);
    } else {
        diff = totalMonths1 - totalMonths;
    }
    diff = diff + (Number(diff) == 1 ? ' month' : ' months');

    // blank out the what if results, if hidden, or no what if repayment supplied
    if (pmt1 === 0 || isNaN(pmt1)) {
        label1 = ''; principal1 = 0; interest1 = 0;
        labelCollection[labelCollection.length - 1] = '<span style="color:#333;"></span>';
    }

    interestCollection.push(interest1);
    principalCollection.push(principal1);

    var principalData = [];
    var interestData = [];
    var interestColours = ['#A6BEFC', '#e1f8fe'];
    var principalColours = ['#0146F5', '#210c4b'];

    for (var i = 0; i < interestCollection.length; i++) {
        interestData.push({ y: interestCollection[i], color: interestColours[i] })
    }
    for (var i = 0; i < principalCollection.length; i++) {
        principalData.push({ y: principalCollection[i], color: principalColours[i] })
    }

    var diffHeading = 'later';
    if (bufferChange < 0) {
        diffHeading = 'sooner';
    }

    document.getElementById("howlong-lbl-newIntRate").innerHTML = '<span class="enlarge-text">' + formatNumber(rate1, 0, 2, true) + '</span>%';
    document.getElementById("howlong-lbl-newTime").innerHTML = '<span class="enlarge-text enlarge-text-time">' + (label1.length < 1 ? 'N/A' : label1) + '</span> ';
    document.getElementById("howlong-lbl-timeDiff").innerHTML = '<span class="enlarge-text enlarge-text-time">' + (label1.length < 1 ? 'N/A' : diff) + '</span> ' + (label1.length < 1 ? '' : diffHeading);

    //chart
    if (howlongChart === undefined) {  //we need to create the chart on first use

        var html = '<div id="howlong-chart1" style="height: 315px; margin: 0 auto;"></div>';
        $("#howlong .chart").html(html);

        howlongChart = new Highcharts.Chart({
            chart: { renderTo: 'howlong-chart1', type: 'column', marginBottom: 90, marginTop: 30 },
            colors: ['#ACE8FA', '#0047F5'],
            credits: { enabled: false },
            title: { text: null },
            xAxis: { categories: labelCollection, labels: { y: 30, style: { fontFamily: '\'Montserrat\', sans-serif', fontSize: '15px', color: '#333' } } },
            yAxis: {
                min: 0, title: { text: null },
                stackLabels: {
                    enabled: true,
                    style: {
                        fontWeight: 'bold',
                        fontFamily: '\'Montserrat\', sans-serif',
                        fontSize: '15px',
                        color: '#333',
                        align: 'center',
                        textOutline: "0px",
                    },
                    formatter: function () {
                        // don't display 'Add comparison below' if they've entered an invalid comparison
                        var invalidComparison = false;
                        var xValue = this.x,
                            xAxis = this.axis.chart.xAxis[0];
                        if (xAxis.categories[xValue] == '<span class="mc-label-heading">Repayment won\'t cover interest and fees</span>') {
                            invalidComparison = true;
                        }

                        if ((this.total > 10 || this.x == 0) || this.x == 1 && invalidComparison == true) {
                            return '$' + formatNumber(this.total, 0, 0, true);
                        } else {
                            return '<span class="mc-comparison-label" style="color:#0047F5;">Add comparison below</span>';
                        }
                    }
                },
                labels: { style: { fontFamily: '\'Montserrat\', sans-serif', color: '#333' } }
            },
            legend: { backgroundColor: '#FFFFFF', reversed: true, enabled: false },
            tooltip: { formatter: function () { return this.series.name + ': $' + formatNumber(this.y, 0, 0, true); } },
            plotOptions: { series: { stacking: 'normal' } },
            series: [{
                name: 'Interest (including fees)',
                data: interestData
            }, {
                name: 'Principal',
                data: principalData
            }]
        });

    }
    else {
        howlongChart.xAxis[0].setCategories(labelCollection);
        howlongChart.series[0].data[0].update(interest);
        howlongChart.series[1].data[0].update(principal);
        howlongChart.series[0].data[1].update(interest1);
        howlongChart.series[1].data[1].update(principal1);
    }

    $("#howlong .result").css('display', 'flex');

    if (CALC_NAME === 'Personal loan') {
        dataLayer.push({ event: 'calculatorCompleted', personalLoanData: serializeData(document.getElementById('calculator-container'), 'C', lastEl) });
    } else {
        dataLayer.push({ event: 'calculatorCompleted', mortgageCalcData: serializeData(document.getElementById('calculator-container'), 'C', lastEl) });
    }

}

function freqString(s) {
    if (s === 1) { s = 'year'; }
    if (s === 4) { s = 'quarter'; }
    if (s === 12) { s = 'month'; }
    if (s === 26) { s = 'fortnight'; }
    if (s === 52) { s = 'week'; }
    return '\xa0per\xa0' + s;
}

/* CALCULATOR FORMULAS */
// NPER - returns the number of periods for an investment based on an interest rate and a constant payment schedule
function NPER(rate, pmt, pv, fv, type) {
    if (type === undefined) { type = 0; }
    var num = pmt * (1 + rate * type) - fv * rate;
    var den = (pv * rate + pmt * (1 + rate * type));
    if (rate === 0) { return -(fv + pv) / pmt; }
    else { return Math.log(num / den) / Math.log(1 + rate); }
}
// PMT - returns the payment amount for a loan based on an interested rate and a constant payment schedule
function PMT(rate, nper, pv, fv, type) {
    var result;
    if (rate === 0) {
        result = (pv + fv) / nper;
    } else {
        var term = Math.pow(1 + rate, nper);
        if (type === 1) {
            result = (fv * rate / (term - 1) + pv * rate / (1 - 1 / term)) / (1 + rate);
        } else {
            result = fv * rate / (term - 1) + pv * rate / (1 - 1 / term);
        }
    }
    return -result;
}
// PV - returns the present value of an investent based on an interest rate and a constant payment schedule
function PV(rate, nper, pmt, fv, type) {
    if (type === undefined) { type = 0; }
    if (rate === 0) {
        return - pmt * nper - fv;
    } else {
        return (((1 - Math.pow(1 + rate, nper)) / rate) * pmt * (1 + rate * type) - fv) / Math.pow(1 + rate, nper);
    }
}


function formatNumber(number, digits, decimalPlaces, withCommas) {
    number = number.toString();
    var simpleNumber = '';

    // Strips out the dollar sign and commas.
    for (var i = 0; i < number.length; ++i) {
        if ("0123456789.".indexOf(number.charAt(i)) >= 0)
            simpleNumber += number.charAt(i);
    }

    number = parseFloat(simpleNumber);

    if (isNaN(number)) number = 0;
    if (withCommas === null) withCommas = false;
    if (digits === 0) digits = 1;

    var integerPart = (decimalPlaces > 0 ? Math.floor(number) : Math.round(number));
    var string = "";

    for (var i = 0; i < digits || integerPart > 0; ++i) {
        // Insert a comma every three digits.
        if (withCommas && string.match(/^\d\d\d/))
            string = "," + string;

        string = (integerPart % 10) + string;
        integerPart = Math.floor(integerPart / 10);
    }

    if (decimalPlaces > 0) {
        number -= Math.floor(number);
        number *= Math.pow(10, decimalPlaces);

        string += "." + formatNumber(number, decimalPlaces, 0);
    }

    return string;
}

function serializeData(container, calcType, lastEl) {
    var version = "v2";
    changeCount++;
    var data = '';
    var inputs = container.querySelectorAll('input,select');
    var lastElID = lastEl.id;
    var loopCnt = 0;
    var lastChanged = '';
    inputs.forEach(function (input) {
        loopCnt++;
        var inputVal = input.value;

        if (input.classList.contains('dollars')) {
            inputVal = inputVal.replace(/\D+/g, '');
        }
        inputVal = inputVal.replace('%', '');
        inputVal = inputVal.replace(' years', '');
        data += inputVal + '|';
        if (lastElID === input.id) {
            lastChanged = loopCnt.toString();
        }
    });

    data += changeCount.toString() + "|" + calcType + "|" + version + "|" + lastChanged;

    return data;
}
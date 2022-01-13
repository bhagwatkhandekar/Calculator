module Rd::Calculator
  # principleVal = 100
  # rdFreq = "MONTHLY"
  # compIntFreq = "YEARLY"
  # interestRate = "0"
  # tenure = 75
  # tenure_type = "MONTHS"

  def self.calculate(principleVal, rdFreq, compIntFreq, interestRate, tenure, tenure_type)
    if (rdFreq == "DAILY")
      rdFreq = 0;
    elsif (rdFreq == "WEEKLY")
      rdFreq = 1;
    elsif (rdFreq == "BI_WEEKLY")
      rdFreq = 2;
    elsif (rdFreq == "MONTHLY")
      rdFreq = 4;
    elsif (rdFreq == "QAURTERLY")
      rdFreq = 6;
    elsif (rdFreq == "HALF_YEARLY")
      rdFreq = 7;
    elsif (rdFreq == "YEARLY")
      rdFreq = 8;
    end

    if (compIntFreq == "MONTHLY")
      compIntFreq = 2;
    elsif (compIntFreq == "QAURTERLY")
      compIntFreq = 3;
    elsif (compIntFreq == "HALF_YEARLY")
      compIntFreq = 4;
    elsif (compIntFreq == "YEARLY")
      compIntFreq = 5;
    end

    if tenure_type == "DAYS"
      tenure = tenure/365.0
    elsif tenure_type == "WEEKS"
      tenure = tenure/52.0
    else
      tenure = tenure/12.0
    end

    result = computeForm(0, principleVal, rdFreq, compIntFreq, interestRate, tenure)

    return result
  end

  def computeForm(principleVal, rdAmount, rdFreq, compIntFreq, interestRate, tenure)
    binding.pry
    fv = 0;
    totDeposits = 0;
    totalint = 0;

    i = sn(interestRate);
    i /= 100

    vcompDays = 0;
    maxCompsPerYr = 0;

    if (compIntFreq == 0)
      i /= 365;
      vcompDays = 1;
      maxCompsPerYr = 365;
    elsif (compIntFreq == 1)
      i /= 52;
      vcompDays = 7;
      maxCompsPerYr = 52;
    elsif (compIntFreq == 2) # MONTHLY
      i /= 12;
      vcompDays = 30;
      maxCompsPerYr = 12;
    elsif (compIntFreq == 3) # QAURTERLY
      i /= 4;
      vcompDays = 91;
      maxCompsPerYr = 4;
    elsif (compIntFreq == 4) # HALF_YEARLY
      i /= 2;
      vcompDays = 182;
      maxCompsPerYr = 2;
    elsif (compIntFreq == 5) # YEARLY
      i /= 1;
      vcompDays = 365;
      maxCompsPerYr = 1;
    end

    vperiodDays  = 0;
    maxAddsPerYr = 0;

    if (rdFreq == 0)
      vperiodDays = 1;
      maxAddsPerYr = 365;
    elsif (rdFreq == 1)
      vperiodDays = 7;
      maxAddsPerYr = 52;
    elsif (rdFreq == 2)
      vperiodDays = 14;
      maxAddsPerYr = 26;
    elsif (rdFreq == 3)
      vperiodDays = 15;
      maxAddsPerYr = 24;
    elsif (rdFreq == 4)
      # // MONTHLY
      vperiodDays = 30;
      maxAddsPerYr = 12;
    elsif (rdFreq == 5)
      vperiodDays = 61;
      maxAddsPerYr = 6;
    elsif (rdFreq == 6)
      vperiodDays = 91;
      maxAddsPerYr = 4;
    elsif (rdFreq == 7)
      vperiodDays = 182;
      maxAddsPerYr = 2;
    elsif (rdFreq == 8)
      vperiodDays = 365;
      maxAddsPerYr = 1;
    end

    ma = sn(rdAmount);
    binding.pry
    # //IF DEPOSIT FREQUENCY EQUALS COMPOUNDING FREQUENCY
    if (vperiodDays == vcompDays)

      prin = sn(principleVal);
      origPrin = prin;
      pmts = sn(tenure);
      pmts = number(pmts * maxCompsPerYr);
      count = 0;

      while (count < pmts) do
        newprin = prin + ma;
        prin = (newprin * i) + number(prin + ma);
        count = count + 1;
      end

      vfv = prin;
      fv = fn(prin, 2, 1);

      totinv = number(count * ma) + number(origPrin);
      totDeposits = fn(totinv, 2, 1);

      vtotalint = number(prin - totinv);
      totalint = fn(vtotalint, 2, 1);

    # IF DEPOSITS ARE LESS FREQUENT THAN COMPOUNDING FREQUENCY
    elsif (vperiodDays > vcompDays)

      prin = sn(principleVal);
      origPrin = prin;

      pmts = sn(tenure);
      pmts = pmts * 365;

      maxComps = number(pmts * maxCompsPerYr);
      maxAdds  = number(tenure * maxAddsPerYr);

      count     = 0;
      accumAdd  = number(ma);
      numAdds   = 1;
      accumPrin = 0;
      countAddDays  = 0;
      countCompDays = 0;
      numComps   = 0;
      accumComp  = 0;
      currentInt = 0;
      prin = number(prin) + number(ma);
      
      while (count < pmts) do
        binding.pry
        # //Compound interest if interval is met
        if (countCompDays == vcompDays && numComps < maxComps)
          accumComp = number(accumComp) + number(prin * i)
          prin = number(prin * i) + number(prin);
          currentInt = number(prin * i);
          numComps   = number(numComps) + number(1);
          countCompDays = 1;
        else
          countCompDays = number(countCompDays) + number(1);
        end

        # Add Addition if interval is met
        if (countAddDays == vperiodDays && numAdds < maxAdds)
          prin = number(prin) + number(ma);
          accumAdd  = number(accumAdd) + number(ma);
          accumPrin = number(accumPrin) + number(prin);
          numAdds   = number(numAdds) + number(1);
          countAddDays = 1;
        else
          countAddDays = number(countAddDays) + number(1);
        end

        count = number(count) + number(1);
      end

      vfv = prin;
      fv = fn(prin, 2, 1);

      totinv = number(accumAdd) + number(origPrin);
      totDeposits = fn(totinv, 2, 1);

      vtotalint = number(prin - totinv);
      totalint = fn(vtotalint, 2, 1);

      # //IF DEPOSITS ARE MORE FREQUENT THAN COMPOUNDING FREQUENCY
    else
      binding.pry
      if (rdFreq == 5)
        vperiodDays = 60;
      end

      if (rdFreq == 0) # DAILY
        countAddDays = 1;
      else
        countAddDays = 0;
      end

      prin = sn(principleVal.to
      origPrin = prin;

      pmts = sn(tenure);
      pmts = pmts * 365;

      maxComps = number(pmts * maxCompsPerYr);
      maxAdds  = number(pmts * maxAddsPerYr);

      count = 0;
      accumAdd = 0;
      numAdds = 0;
      countCompDays = 0;
      numComps = 0;
      accumComp = 0;
      depositIntervalDays = 0;
      periodsPast = 0;
      accumPrin = 0;
      prinAvg = 0;

      periodsPerComp = (vcompDays / vperiodDays).to_i;
      
      while (count < pmts) do
        binding.pry
        depositIntervalDays = number(depositIntervalDays) + number(1);

        # //Accumulate period balances to figure average balance
        if (depositIntervalDays == vperiodDays || countCompDays == vcompDays)
          periodsPast = number(periodsPast) + number(1);
          depositIntervalDays = 0;
        end

        # //Add Addition if interval is met
        if (countAddDays == vperiodDays && numAdds < maxAdds)
          binding.pry
          prin = number(prin) + number(ma);
          accumAdd = number(accumAdd) + number(ma);
          accumPrin = number(accumPrin) + number(prin);
          prinAvg = accumPrin / periodsPast;
          numAdds = number(numAdds) + number(1);
          countAddDays = 1;
        else
          binding.pry
          countAddDays = number(countAddDays) + number(1);
        end

        # //Compound interest if interval is met
        if (countCompDays == (vcompDays - 1) && numComps < maxComps)
          binding.pry
          periodsPast = 0;
          prin = number(prinAvg * i) + number(prin);
          accumPrin = 0;
          accumComp = number(accumComp) + number(prinAvg * i)
          numComps = number(numComps) + number(1);
          countCompDays = 1;
        else
          countCompDays = number(countCompDays) + number(1);
        end

        count = number(count) + number(1);
      end
      binding.pry
      vfv = prin;
      fv = fn(prin, 2, 1);

      totinv = (accumAdd).to_f + (origPrin).to_f;
      totDeposits = fn(totinv, 2, 1);

      vtotalint = number(prin - totinv);
      totalint = fn(vtotalint, 2, 1);
      # //END IF ELSE STATEMENT THAT DETERMINES WHICH ROUTINE TO RUN
    end

    # //END NESTED IF TO CHECK FOR NON-NUMERIC ENTRIES
    return [fv.round, totDeposits.round, totalint.round]
  end

  def number(value)
    value.to_f
  end

  def fn(num, places, comma)
    return num
  end

  def sn(num)
    return num.to_f
  end

  # def self.fn(num, places, comma)
  #   isNeg = 0;

  #   if (num < 0)
  #     num = num * -1;
  #     isNeg = 1;
  #   end

  #   myDecFact = 1;
  #   myPlaces = 0;
  #   myZeros = "";

  #   while (myPlaces < places) do
  #     myDecFact = myDecFact * 10;
  #     myPlaces = number(myPlaces) + number(1);
  #     myZeros = myZeros + "0";
  #   end

  #   onum = (num * myDecFact).round / myDecFact;
  #   integer = onum.to_f;

  #   if ((onum).round == integer)
  #     decimal = myZeros;
  #   else
  #     decimal = ((onum - integer) * myDecFact).round
  #   end

  #   decimal = decimal.to_s
  #   if (decimal.length < places)
  #     fillZeroes = places - decimal.length;
  #     for z in 0..fillZeroes
  #     # for (z = 0; z < fillZeroes; z++) {
  #       decimal = "0" + decimal;
  #     end
  #   end

  #   if (places > 0)
  #     decimal = "." + decimal;
  #   end

  #   if (comma == 1)
  #     integer = integer.to_s
  #     tmpnum = "";
  #     tmpinteger = "";
  #     y = 0;

  #     for x in integer.length..1
  #     # for (x = integer.length; x > 0; x--) {
  #       tmpnum = tmpnum + integer.to_s[x - 1].to_s;
  #       y = y + 1;
  #       if (y == 3 & x > 1)
  #         tmpnum = tmpnum + ",";
  #         y = 0;
  #       end
  #     end

  #     for x in tmpnum.length..1
  #     # for (x = tmpnum.length; x > 0; x--) {
  #       # byebug
  #       tmpinteger = tmpinteger + tmpnum[x - 1].to_s;
  #     end

  #     finNum = tmpinteger + "" + decimal;
  #   else
  #     finNum = integer + "" + decimal;
  #   end

  #   if (isNeg == 1)
  #     finNum = "-" + finNum;
  #   end

  #   return finNum;
  # end

  # def self.sn(num)
  #   num  = num.to_s

  #   len  = num.length;
  #   rnum = "";
  #   test = "";
  #   j = 0;

  #   b = num.slice(0..1);

  #   if (b == "-")
  #     rnum = "-";
  #   end

  #   for i in 0..len
  #   # for (i = 0; i <= len; i++) {
  #     b = num.slice(i..i + 1);

  #     if (b == "0" || b == "1" || b == "2" || b == "3" || b == "4" || b == "5" || b == "6" || b == "7" || b == "8" || b == "9" || b == ".")
  #       rnum = rnum + "" + b;
  #     end
  #   end

  #   if (rnum == "" || rnum == "-")
  #     rnum = 0;
  #   end

  #   rnum = number(rnum);
  #   return rnum;
  # end

end